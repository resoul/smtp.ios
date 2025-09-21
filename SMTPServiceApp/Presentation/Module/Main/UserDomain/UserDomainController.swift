import AsyncDisplayKit
import Combine

final class UserDomainController: MainCollectionController {
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: UserDomainCoordinator?
    let collectionNode: ASCollectionNode
    let viewModel: UserDomainViewModel
    var currentUser: User?
    
    var currentPage: Int = 1
    var totalCount: Int = 0
    var items: [UserDomain] = []
    
    init(viewModel: UserDomainViewModel) {
        self.viewModel = viewModel
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        collectionNode = ASCollectionNode(collectionViewLayout: layout)
        super.init(node: collectionNode)
        collectionNode.dataSource = self
        collectionNode.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMoreData()
    }
    
    func loadMoreData() {
        Task {
            try await viewModel.fetchListings()
            currentPage += 1
        }
    }
    
    override func setupBindings() {
        viewModel.totalItems
            .sink { [weak self] total in
                self?.handleTotal(total: total)
            }
            .store(in: &cancellables)
        
        viewModel.items
            .sink { [weak self] items in
                self?.handleItems(domains: items)
            }
            .store(in: &cancellables)
        
        viewModel.currentUser
            .sink { [weak self] user in
                self?.handleUserUpdate(user)
            }
            .store(in: &cancellables)
    }
    
    private func handleUserUpdate(_ user: User?) {
        currentUser = user
    }
    
    private func handleItems(domains: [UserDomain]) {
        let oldCount = items.count
        items.append(contentsOf: domains)

        let newCount = items.count
        let indexPaths = (oldCount..<newCount).map { IndexPath(item: $0, section: 0) }
        collectionNode.performBatchUpdates({
            collectionNode.insertItems(at: indexPaths)
        })
    }
    
    private func handleTotal(total: Int) {
        if total != totalCount {
            totalCount = total
        }
    }
    
    override func applyTheme(_ theme: any Theme) {
        collectionNode.backgroundColor = theme.mainPresentationData.backgroundColor
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
