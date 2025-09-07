import AsyncDisplayKit
import Combine

class DisplayNode: ASDisplayNode {
    private var cancellables = Set<AnyCancellable>()
    let themeManager: ThemeManager = .shared
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        bindTheme()
        setupUI()
    }
    
    func setupUI() {}
    
    private func bindTheme() {
        themeManager.themePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] theme in
                self?.applyTheme(theme)
            }
            .store(in: &cancellables)
    }
    
    func applyTheme(_ theme: Theme) {}
}
