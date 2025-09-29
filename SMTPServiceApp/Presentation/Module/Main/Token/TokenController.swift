import AsyncDisplayKit
import Combine

final class TokenController: MainTableController {
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: TokenCoordinator?
    let viewModel: TokenViewModel
    var currentSettingsTab: TokenViewModel.SettingsTab = .smtp

    var tableNode: ASTableNode {
        return node
    }
    
    var currentPage: Int = 1
    var totalCount: Int = 0
    var items: [Token] = []
    
    init(viewModel: TokenViewModel) {
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
                self?.handleItems(token: items)
            }
            .store(in: &cancellables)
        
        viewModel.needsReload
            .sink { [weak self] in
                self?.reloadTokens()
            }
            .store(in: &cancellables)
    }
    
    private func reloadTokens() {
        items.removeAll()
        currentPage = 1
        tableNode.reloadSections(
            IndexSet(integer: TokenViewModel.Section.tokens.rawValue),
            with: .automatic
        )
        loadMoreData()
    }
    
    private func handleItems(token: [Token]) {
        let oldCount = items.count
        items.append(contentsOf: token)

        let newCount = items.count
        let indexPaths = (oldCount..<newCount).map {
            IndexPath(row: $0, section: TokenViewModel.Section.tokens.rawValue)
        }
        tableNode.performBatchUpdates({
            tableNode.insertRows(at: indexPaths, with: .automatic)
        })
        
        tableNode.reloadSections(
            IndexSet(integer: TokenViewModel.Section.content.rawValue),
            with: .fade
        )
    }
    
    private func handleTotal(total: Int) {
        if total != totalCount {
            totalCount = total
        }
    }
    
    // MARK: - Token Actions
    func handleDeleteToken(at indexPath: IndexPath) {
        let token = items[indexPath.row]

        let alert = UIAlertController(
            title: "Delete Token",
            message: "Are you sure you want to delete the token '\(token.tokenName)'?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.confirmDeleteToken(at: indexPath)
        })

        present(alert, animated: true)
    }

    func handleUpdateToken(at indexPath: IndexPath) {
        let token = items[indexPath.row]

        let alert = UIAlertController(
            title: "Update Token",
            message: "Enter a new name for the token:",
            preferredStyle: .alert
        )

        alert.addTextField { textField in
            textField.text = token.tokenName
            textField.placeholder = "Token name"
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Update", style: .default) { [weak self] _ in
            guard let newName = alert.textFields?.first?.text, !newName.isEmpty else { return }
            self?.updateTokenName(at: indexPath, newName: newName)
        })

        present(alert, animated: true)
    }
    
    func updateTokenName(at indexPath: IndexPath, newName: String) {
        let token = items[indexPath.row]

        Task {
 //            try await viewModel.updateToken(id: token.token, newName: newName)

            DispatchQueue.main.async { [weak self] in
                self?.tableNode.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }

    func handleBlockToken(at indexPath: IndexPath) {
        let token = items[indexPath.row]
 //        let isBlocking = token.status != .blocked
 //
 //        Task {
 //            if isBlocking {
 //                try await viewModel.blockToken(id: token.id)
 //            } else {
 //                try await viewModel.unblockToken(id: token.id)
 //            }
 //
 //            DispatchQueue.main.async { [weak self] in
 //                self?.tableNode.reloadRows(at: [indexPath], with: .automatic)
 //            }
 //        }
    }
    
    func confirmDeleteToken(at indexPath: IndexPath) {
        let token = items[indexPath.row]

        Task {
 //            try await viewModel.deleteToken(id: token.id)

            DispatchQueue.main.async { [weak self] in
                self?.items.remove(at: indexPath.row)
                self?.tableNode.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func handleCreateToken() {
        coordinator?.showCreateToken(from: self)
    }
    
    override func applyTheme(_ theme: any Theme) {
        tableNode.backgroundColor = theme.mainPresentationData.backgroundColor
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
