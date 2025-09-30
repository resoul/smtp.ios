import UIKit

final class DashboardController: UIViewController {
    weak var coordinator: Coordinator?
    private let singleSelectView = SelectView<TokenState>(items: TokenState.allCases)
    private let multiSelectView = SelectView<TokenState>(items: TokenState.allCases)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupSingleSelect()
        setupMultiSelect()
        setupLayout()
    }
    
    private func setupSingleSelect() {
        // Single select configuration (default)
        singleSelectView.selectionMode = .single
        singleSelectView.placeholder = "Choose Status"
        singleSelectView.translatesAutoresizingMaskIntoConstraints = false
        
        singleSelectView.onSelectionChanged = { selected in
            print(selected.map { $0.title })
        }
        
        view.addSubview(singleSelectView)
    }
    
    private func setupMultiSelect() {
        multiSelectView.selectionMode = .multiple
        multiSelectView.placeholder = "Select Multiple Statuses"
        multiSelectView.translatesAutoresizingMaskIntoConstraints = false
        let preselectedStatuses = TokenState.allCases.filter { ["active"].contains($0.id) }
        
        multiSelectView.setSelectedItems(preselectedStatuses)

        multiSelectView.onSelectionChanged = { statuses in
            print("Multiple selection: \(statuses.map { $0.title })")
        }
        
        view.addSubview(multiSelectView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            singleSelectView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            singleSelectView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            singleSelectView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            multiSelectView.topAnchor.constraint(equalTo: singleSelectView.bottomAnchor, constant: 30),
            multiSelectView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            multiSelectView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
