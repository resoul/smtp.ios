import AsyncDisplayKit
import Combine

final class SettingsController: MainCollectionController {
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: SettingsCoordinator?
    let collectionNode: ASCollectionNode
    let viewModel: SettingsViewModel
    var currentUser: User?
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        collectionNode = ASCollectionNode(collectionViewLayout: UICollectionViewFlowLayout())
        super.init(node: collectionNode)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupBindings() {
        viewModel.currentUser
            .sink { [weak self] user in
                self?.handleUserUpdate(user)
            }
            .store(in: &cancellables)
    }
    
    private func handleUserUpdate(_ user: User?) {
        currentUser = user
    }
    
    override func applyTheme(_ theme: any Theme) {
        collectionNode.backgroundColor = theme.mainPresentationData.backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
