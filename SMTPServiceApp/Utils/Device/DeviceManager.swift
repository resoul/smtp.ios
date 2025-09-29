import UIKit
import Combine

class DeviceManager: ObservableObject {
    static let shared = DeviceManager()

    private let device = UIDevice.current
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Combine Publishers

    /// Publisher for device changes
    @Published var currentDevice: Device

    /// Publisher for orientation changes
    let orientationPublisher: AnyPublisher<UIDeviceOrientation, Never>

    /// Publisher for battery level changes
    let batteryLevelPublisher: AnyPublisher<Float, Never>

    /// Publisher for battery state changes
    let batteryStatePublisher: AnyPublisher<UIDevice.BatteryState, Never>

    /// Publisher for Safe Area changes
    let safeAreaPublisher: AnyPublisher<UIEdgeInsets, Never>

    /// Combined publisher for all device changes
    let deviceChangesPublisher: AnyPublisher<Device, Never>

    private let orientationSubject = PassthroughSubject<UIDeviceOrientation, Never>()
    private let batteryLevelSubject = PassthroughSubject<Float, Never>()
    private let batteryStateSubject = PassthroughSubject<UIDevice.BatteryState, Never>()
    private let safeAreaSubject = PassthroughSubject<UIEdgeInsets, Never>()

    private init() {
        // Enable battery monitoring
        device.isBatteryMonitoringEnabled = true

        // Initialize current device
        self.currentDevice = Self.createDevice()

        var safeAreaInsets: UIEdgeInsets = .zero
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            safeAreaInsets = window.safeAreaInsets
        }

        self.orientationPublisher = orientationSubject.eraseToAnyPublisher()
        self.batteryLevelPublisher = batteryLevelSubject.eraseToAnyPublisher()
        self.batteryStatePublisher = batteryStateSubject.eraseToAnyPublisher()
        self.safeAreaPublisher = safeAreaSubject.eraseToAnyPublisher()
        self.deviceChangesPublisher = Publishers.CombineLatest4(
            orientationPublisher.prepend(device.orientation),
            batteryLevelPublisher.prepend(device.batteryLevel),
            batteryStatePublisher.prepend(device.batteryState),
            safeAreaPublisher.prepend(safeAreaInsets)
        )
        .map { _, _, _, _ in
            Self.createDevice()
        }
        .eraseToAnyPublisher()

        setupCombineObservers()
        setupNotifications()
    }

    deinit {
        device.endGeneratingDeviceOrientationNotifications()
        cancellables.removeAll()
    }

    // MARK: - Public Methods

    /// Get current device information
    func getCurrentDevice() -> Device {
        return currentDevice
    }

    /// Get device description summary
    func getDeviceDescription() -> String {
        return currentDevice.description
    }

    /// Check if device is iPhone
    func isiPhone() -> Bool {
        return device.userInterfaceIdiom == .phone
    }

    /// Check if device is iPad
    func isiPad() -> Bool {
        return device.userInterfaceIdiom == .pad
    }

    /// Get screen size in points
    func getScreenSize() -> CGSize {
        return UIScreen.main.bounds.size
    }

    /// Get Safe Area insets for current window
    func getSafeAreaInsets() -> UIEdgeInsets {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            return window.safeAreaInsets
        }

        return .zero
    }

    /// Publisher for filtered orientation changes (only significant ones)
    var significantOrientationChanges: AnyPublisher<UIDeviceOrientation, Never> {
        return orientationPublisher
            .filter { orientation in
                // Filter only portrait and landscape orientations
                switch orientation {
                case .portrait, .portraitUpsideDown, .landscapeLeft, .landscapeRight:
                    return true
                default:
                    return false
                }
            }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    /// Publisher for critical battery changes
    var criticalBatteryChanges: AnyPublisher<Float, Never> {
        return batteryLevelPublisher
            .filter { level in
                level <= 0.2 // Notify when battery is 20% or lower
            }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    /// Publisher for charging status changes
    var chargingStatusChanges: AnyPublisher<Bool, Never> {
        return batteryStatePublisher
            .map { state in
                return state == .charging
            }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    // MARK: - Private Methods

    private static func createDevice() -> Device {
        let device = UIDevice.current
        return Device(
            name: device.name,
            model: DeviceManager.getDeviceModel(),
            systemName: device.systemName,
            systemVersion: device.systemVersion,
            screenSize: UIScreen.main.bounds.size,
            screenScale: UIScreen.main.scale,
            idiom: device.userInterfaceIdiom,
            orientation: device.orientation,
            batteryLevel: device.batteryLevel,
            batteryState: device.batteryState,
            isSimulator: DeviceManager.isRunningOnSimulator(),
            deviceIdentifier: device.identifierForVendor?.uuidString ?? "Denied"
        )
    }

    private func setupCombineObservers() {
        // Subscribe to device changes and update @Published property
        deviceChangesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] device in
                self?.currentDevice = device
            }
            .store(in: &cancellables)
    }

    private func setupNotifications() {
        // Enable orientation notifications
        device.beginGeneratingDeviceOrientationNotifications()

        // Device orientation
        NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
            .map { _ in UIDevice.current.orientation }
            .sink { [weak self] orientation in
                self?.orientationSubject.send(orientation)
            }
            .store(in: &cancellables)

        // Battery level
        NotificationCenter.default.publisher(for: UIDevice.batteryLevelDidChangeNotification)
            .map { _ in UIDevice.current.batteryLevel }
            .sink { [weak self] level in
                self?.batteryLevelSubject.send(level)
            }
            .store(in: &cancellables)

        // Battery state
        NotificationCenter.default.publisher(for: UIDevice.batteryStateDidChangeNotification)
            .map { _ in UIDevice.current.batteryState }
            .sink { [weak self] state in
                self?.batteryStateSubject.send(state)
            }
            .store(in: &cancellables)

        // Safe Area changes (on orientation change)
        orientationPublisher
            .delay(for: 0.1, scheduler: DispatchQueue.main) // Small delay for Safe Area update
            .sink { [weak self] _ in
                let safeArea = self?.getSafeAreaInsets() ?? .zero
                self?.safeAreaSubject.send(safeArea)
            }
            .store(in: &cancellables)
    }

    private static func getDeviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return mapToDevice(identifier: identifier)
    }

    private static func mapToDevice(identifier: String) -> String {
        switch identifier {
        case "iPhone14,7": return "iPhone 13 mini"
        case "iPhone14,8": return "iPhone 13"
        case "iPhone15,2": return "iPhone 14"
        case "iPhone15,3": return "iPhone 14 Plus"
        case "iPhone15,4": return "iPhone 14 Pro"
        case "iPhone15,5": return "iPhone 14 Pro Max"
        case "iPhone16,1": return "iPhone 15"
        case "iPhone16,2": return "iPhone 15 Plus"
        case "iPhone16,3": return "iPhone 15 Pro"
        case "iPhone16,4": return "iPhone 15 Pro Max"
        case "iPad13,1", "iPad13,2": return "iPad Air (5th generation)"
        case "iPad14,1", "iPad14,2": return "iPad mini (6th generation)"
        default: return identifier
        }
    }

    private static func isRunningOnSimulator() -> Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
}

extension DeviceManager {

    /// Create debounced publisher for orientation changes (avoid frequent updates)
    func debouncedOrientationChanges(for interval: TimeInterval = 0.3) -> AnyPublisher<UIDeviceOrientation, Never> {
        return orientationPublisher
            .debounce(for: .seconds(interval), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    /// Create throttled publisher for battery changes (limit update frequency)
    func throttledBatteryChanges(for interval: TimeInterval = 1.0) -> AnyPublisher<Float, Never> {
        return batteryLevelPublisher
            .throttle(for: .seconds(interval), scheduler: DispatchQueue.main, latest: true)
            .eraseToAnyPublisher()
    }

    /// Get publisher for device updates at specified intervals
    func deviceUpdates(every interval: TimeInterval = 1.0) -> AnyPublisher<Device, Never> {
        return Timer.publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .map { _ in Self.createDevice() }
            .eraseToAnyPublisher()
    }
}
