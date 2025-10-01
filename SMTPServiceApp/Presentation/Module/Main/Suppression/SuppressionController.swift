import AsyncDisplayKit
import Combine

final class SuppressionController: MainTableController {
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: SuppressionCoordinator?
    let viewModel: SuppressionViewModel

    var tableNode: ASTableNode {
        return node
    }
    
    var currentPage: Int = 1
    var totalCount: Int = 0
    var items: [Suppression] = []
    
    init(viewModel: SuppressionViewModel) {
        self.viewModel = viewModel
        super.init(node: ASTableNode())
        tableNode.view.allowsMultipleSelectionDuringEditing = false
        tableNode.dataSource = self
        tableNode.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMoreData()
    }
    
    func loadMoreData() {
        Task {
            try await self.viewModel.fetchListings()
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
                self?.handleItems(suppression: items)
            }
            .store(in: &cancellables)
    }

    private func handleItems(suppression: [Suppression]) {
        let oldCount = items.count
        items.append(contentsOf: suppression)

        let newCount = items.count
        let indexPaths = (oldCount..<newCount).map {
            IndexPath(row: $0, section: SuppressionViewModel.Section.suppression.rawValue)
        }
        
        tableNode.performBatchUpdates({
            tableNode.insertRows(at: indexPaths, with: .automatic)
        })
    }
    
    func handleFilter() {
        coordinator?.showSuppressionFilter(from: self)
    }
    
    private func handleTotal(total: Int) {
        if total != totalCount {
            totalCount = total
        }
    }

    override func applyTheme(_ theme: any Theme) {
        tableNode.backgroundColor = theme.mainPresentationData.backgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    deinit {
        cancellables.removeAll()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
