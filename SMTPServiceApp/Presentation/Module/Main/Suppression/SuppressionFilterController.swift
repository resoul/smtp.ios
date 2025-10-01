import UIKit

final class SuppressionFilterController: UIViewController {
    private let dateRangeView = DateRangeView()
    private let singleSelectView = SelectView<TokenState>(items: TokenState.allCases)
    private let multiSelectView = SelectView<TokenState>(items: TokenState.allCases)
    private var nameTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        nameTextField.placeholder = "Search email"
        nameTextField.borderStyle = .roundedRect
        nameTextField.font = UIFont.systemFont(ofSize: 16)
        nameTextField.autocapitalizationType = .none
        nameTextField.returnKeyType = .done
        nameTextField.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(nameTextField)
        setupDateRangeView()
        setupSingleSelect()
        setupMultiSelect()
        setupLayout()
    }
    
    private func setupSingleSelect() {
        // Single select configuration (default)
        singleSelectView.selectionMode = .single
        singleSelectView.placeholder = "Select Domain"
        singleSelectView.translatesAutoresizingMaskIntoConstraints = false
        
        singleSelectView.onSelectionChanged = { selected in
            print(selected.map { $0.title })
        }
        
        view.addSubview(singleSelectView)
    }
    
    private func setupDateRangeView() {
        dateRangeView.placeholder = "Select date range"
        dateRangeView.dateFormat = "MM/dd/yyyy"
        dateRangeView.translatesAutoresizingMaskIntoConstraints = false
        
        dateRangeView.onDateRangeSelected = { startDate, endDate in
            print("Selected range: \(startDate) - \(endDate)")
            // Ваша логика при выборе диапазона
        }
        
        dateRangeView.onDateRangeCleared = {
            print("Date range cleared")
            // Ваша логика при очистке
        }
        
        view.addSubview(dateRangeView)
    }
    
    private func setupMultiSelect() {
        multiSelectView.selectionMode = .multiple
        multiSelectView.placeholder = "Select Type"
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
            dateRangeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            dateRangeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dateRangeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            singleSelectView.topAnchor.constraint(equalTo: dateRangeView.bottomAnchor, constant: 20),
            singleSelectView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            singleSelectView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            multiSelectView.topAnchor.constraint(equalTo: singleSelectView.bottomAnchor, constant: 30),
            multiSelectView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            multiSelectView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            nameTextField.topAnchor.constraint(equalTo: multiSelectView.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
}
