import AsyncDisplayKit
import Combine

class MainCollectionController: ASDKViewController<ASCollectionNode> {
    private var cancellables = Set<AnyCancellable>()
    let themeManager: ThemeManager = .shared
    
    override init(node: ASCollectionNode) {
        super.init(node: node)
        bindTheme()
        setupBindings()
    }
    
    func setupBindings() {}
    
    private func bindTheme() {
        themeManager.themePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] theme in
                self?.applyTheme(theme)
            }
            .store(in: &cancellables)
    }
    
    func applyTheme(_ theme: Theme) {}

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
