import UIKit

struct Device {
    let name: String
    let model: String
    let systemName: String
    let systemVersion: String
    let screenSize: CGSize
    let screenScale: CGFloat
    let idiom: UIUserInterfaceIdiom
    let orientation: UIDeviceOrientation
    let batteryLevel: Float
    let batteryState: UIDevice.BatteryState
    let isSimulator: Bool
    let deviceIdentifier: String

    var description: String {
        return """
        Name: \(name)
        Model: \(model)
        System: \(systemName) \(systemVersion)
        Screen Size: \(screenSize.width)x\(screenSize.height)
        Screen scale: \(screenScale)x
        Idiom Description: \(idiomDescription)
        Orientation Description: \(orientationDescription)
        Battery Level: \(batteryLevel > 0 ? "\(Int(batteryLevel * 100))%" : "Unknown")
        Battery State Description: \(batteryStateDescription)
        Simulator: \(isSimulator ? "Yes" : "No")
        Identifier: \(deviceIdentifier)
        """
    }

    private var idiomDescription: String {
        switch idiom {
        case .phone: return "iPhone"
        case .pad: return "iPad"
        case .tv: return "Apple TV"
        case .carPlay: return "CarPlay"
        case .mac: return "Mac (Catalyst)"
        case .vision: return "Vision Pro"
        default: return "Unknown"
        }
    }

    private var orientationDescription: String {
        switch orientation {
        case .portrait: return "Portrait"
        case .portraitUpsideDown: return "Portrait (Upside Down)"
        case .landscapeLeft: return "Landscape (Left)"
        case .landscapeRight: return "Landscape (Right)"
        case .faceUp: return "Face up"
        case .faceDown: return "Face down"
        default: return "Unknown"
        }
    }

    private var batteryStateDescription: String {
        switch batteryState {
        case .charging: return "Charging"
        case .full: return "Full"
        case .unplugged: return "Unplugged"
        default: return "Unknown"
        }
    }
}
