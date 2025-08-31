import UIKit
import Combine

// MARK: - Tab Manager
class TabBarManager {
    static let shared = TabBarManager()
    
    // Publishers for reactive updates
    private let allTabsSubject = CurrentValueSubject<[TabItem], Never>([])
    private let enabledTabsSubject = CurrentValueSubject<[TabItem], Never>([])
    private let savedTabsSubject = CurrentValueSubject<[TabItem], Never>([])
    
    var allTabsPublisher: AnyPublisher<[TabItem], Never> {
        allTabsSubject.eraseToAnyPublisher()
    }
    
    var enabledTabsPublisher: AnyPublisher<[TabItem], Never> {
        enabledTabsSubject.eraseToAnyPublisher()
    }
    
    var savedTabsPublisher: AnyPublisher<[TabItem], Never> {
        savedTabsSubject.eraseToAnyPublisher()
    }
    
    var allTabs: [TabItem] {
        get { allTabsSubject.value }
        set {
            allTabsSubject.send(newValue)
            updateEnabledTabs()
        }
    }
    
    var enabledTabs: [TabItem] {
        enabledTabsSubject.value
    }
    
    var savedTabs: [TabItem] {
        savedTabsSubject.value
    }
    
    private let userDefaults = UserDefaults.standard
    private let tabsKey = "customTabBarItems"
    private var cancellables = Set<AnyCancellable>()
    
    weak var tabBarController: UITabBarController?
    
    private init() {
        loadTabs()
        setupBindings()
    }
    
    private func setupBindings() {
        // Удаляем автообновление TabBar - теперь только по команде
        // Только автосохранение настроек в UserDefaults остается
    }
    
    private func updateEnabledTabs() {
        let enabled = allTabs
            .filter { $0.isEnabled }
            .sorted { $0.order < $1.order }
        enabledTabsSubject.send(enabled)
    }
    
    func updateTab(_ tab: TabItem) {
        if let index = allTabs.firstIndex(where: { $0.id == tab.id }) {
            var updatedTabs = allTabs
            updatedTabs[index] = tab
            allTabs = updatedTabs
        }
    }
    
    func moveTab(from sourceIndex: Int, to destinationIndex: Int) {
        var updatedTabs = allTabs
        let movedTab = updatedTabs.remove(at: sourceIndex)
        updatedTabs.insert(movedTab, at: destinationIndex)
        
        // Обновляем порядок
        for (index, var tab) in updatedTabs.enumerated() {
            tab.order = index
            updatedTabs[index] = tab
        }
        
        allTabs = updatedTabs
    }
    
    func resetToDefault() {
        allTabs = TabItem.defaultTabs
    }
    
    func saveAndApplyChanges() {
        // Сохраняем текущее состояние как основное
        let currentTabs = allTabs
        savedTabsSubject.send(currentTabs)
        saveTabs(currentTabs)
        updateTabBarController()
    }
    
    func discardChanges() {
        // Возвращаем к сохраненному состоянию
        allTabs = savedTabs
    }
    
    func hasUnsavedChanges() -> Bool {
        return allTabs != savedTabs
    }
    
    private func loadTabs() {
        var loadedTabs: [TabItem]
        if let data = userDefaults.data(forKey: tabsKey),
           let tabs = try? JSONDecoder().decode([TabItem].self, from: data) {
            loadedTabs = tabs
        } else {
            loadedTabs = TabItem.defaultTabs
        }
        
        allTabs = loadedTabs
        savedTabsSubject.send(loadedTabs) // Инициализируем сохраненное состояние
        updateEnabledTabs()
    }
    
    private func saveTabs(_ tabs: [TabItem]) {
        if let data = try? JSONEncoder().encode(tabs) {
            userDefaults.set(data, forKey: tabsKey)
        }
    }
    
    private func updateTabBarController() {
        guard let tabBarController = tabBarController else { return }
        
        DispatchQueue.main.async {
            let viewControllers = self.enabledTabs.compactMap { tab in
                self.createViewController(for: tab)
            }
            
            tabBarController.setViewControllers(viewControllers, animated: true)
        }
    }
    
    private func createViewController(for tab: TabItem) -> UIViewController {
        let viewController: UIViewController
        
        // Factory pattern для создания контроллеров
        switch tab.viewControllerType {
        case "HomeViewController":
            viewController = UIViewController()
        case "SearchViewController":
            viewController = UIViewController()
        case "FavoritesViewController":
            viewController = UIViewController()
        case "ProfileViewController":
            viewController = UIViewController()
        case "SettingsViewController":
            viewController = UIViewController()
        case "MessagesViewController":
            viewController = UIViewController()
        default:
            viewController = UIViewController()
        }
        
        viewController.tabBarItem = UITabBarItem(
            title: tab.title,
            image: UIImage(systemName: tab.icon),
            selectedImage: UIImage(systemName: tab.icon + ".fill")
        )
        
        return UINavigationController(rootViewController: viewController)
    }
}
