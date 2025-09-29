//import UIKit
//
//// MARK: - Status Model
//struct EmailStatus {
//    let id: String
//    let title: String
//    let color: UIColor
//
//    static let allStatuses = [
//        EmailStatus(id: "delivered", title: "Delivered", color: .systemGreen),
//        EmailStatus(id: "hardBounce", title: "Hard Bounce", color: .systemRed),
//        EmailStatus(id: "softBounce", title: "Soft Bounce", color: .systemBlue),
//        EmailStatus(id: "blocked", title: "Blocked", color: .systemGray),
//        EmailStatus(id: "complaint", title: "Complaint", color: .systemOrange),
//        EmailStatus(id: "error", title: "Error", color: .systemRed),
//        EmailStatus(id: "filtered", title: "Filtered", color: .systemYellow),
//        EmailStatus(id: "incorrect", title: "Incorrect", color: .systemPink),
//        EmailStatus(id: "queued", title: "Queued", color: .systemIndigo),
//        EmailStatus(id: "unsubscribe", title: "Unsubscribe", color: .systemPurple)
//    ]
//}
//
//// MARK: - Selected Status Tag View
//class StatusTagView: UIView {
//    private let titleLabel = UILabel()
//    private let removeButton = UIButton(type: .system)
//
//    var onRemove: (() -> Void)?
//
//    init(status: EmailStatus) {
//        super.init(frame: .zero)
//        setupView(with: status)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupView(with status: EmailStatus) {
//        backgroundColor = status.color.withAlphaComponent(0.2)
//        layer.cornerRadius = 16
//        layer.borderWidth = 1
//        layer.borderColor = status.color.cgColor
//
//        titleLabel.text = status.title
//        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
//        titleLabel.textColor = status.color
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        removeButton.setTitle("×", for: .normal)
//        removeButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
//        removeButton.tintColor = status.color
//        removeButton.translatesAutoresizingMaskIntoConstraints = false
//        removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
//
//        addSubview(titleLabel)
//        addSubview(removeButton)
//
//        NSLayoutConstraint.activate([
//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
//            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
//
//            removeButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
//            removeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
//            removeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
//            removeButton.widthAnchor.constraint(equalToConstant: 20),
//            removeButton.heightAnchor.constraint(equalToConstant: 20),
//
//            heightAnchor.constraint(equalToConstant: 32)
//        ])
//    }
//
//    @objc private func removeButtonTapped() {
//        onRemove?()
//    }
//}
//
//// MARK: - Dropdown Table View Cell
//class StatusTableViewCell: UITableViewCell {
//    private let checkmarkImageView = UIImageView()
//    private let titleLabel = UILabel()
//    private let colorView = UIView()
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupCell()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupCell() {
//        selectionStyle = .none
//
//        colorView.layer.cornerRadius = 4
//        colorView.translatesAutoresizingMaskIntoConstraints = false
//
//        titleLabel.font = UIFont.systemFont(ofSize: 16)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        checkmarkImageView.image = UIImage(systemName: "checkmark")
//        checkmarkImageView.tintColor = .systemBlue
//        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
//        checkmarkImageView.isHidden = true
//
//        contentView.addSubview(colorView)
//        contentView.addSubview(titleLabel)
//        contentView.addSubview(checkmarkImageView)
//
//        NSLayoutConstraint.activate([
//            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            colorView.widthAnchor.constraint(equalToConstant: 8),
//            colorView.heightAnchor.constraint(equalToConstant: 8),
//
//            titleLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 12),
//            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//
//            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            checkmarkImageView.widthAnchor.constraint(equalToConstant: 20),
//            checkmarkImageView.heightAnchor.constraint(equalToConstant: 20)
//        ])
//    }
//
//    func configure(with status: EmailStatus, isSelected: Bool) {
//        titleLabel.text = status.title
//        colorView.backgroundColor = status.color
//        checkmarkImageView.isHidden = !isSelected
//    }
//}
//
//// MARK: - MultiSelect Status View
//class MultiSelectStatusView: UIView {
//    private let containerStackView = UIStackView()
//    private let headerStackView = UIStackView()
//    private let tagsStackView = UIStackView()
//    private let selectButton = UIButton(type: .system)
//    private let dropdownTableView = UITableView()
//    private let backgroundOverlay = UIView()
//
//    private var allStatuses = EmailStatus.allStatuses
//    private var selectedStatuses: [EmailStatus] = []
//    private var isDropdownVisible = false
//
//    var onSelectionChanged: (([EmailStatus]) -> Void)?
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//        setupInitialSelection()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupView() {
//        backgroundColor = .systemBackground
//        layer.cornerRadius = 8
//        layer.borderWidth = 1
//        layer.borderColor = UIColor.systemGray4.cgColor
//
//        setupContainerStackView()
//        setupHeaderStackView()
//        setupTagsStackView()
//        setupSelectButton()
//        setupDropdownTableView()
//        setupBackgroundOverlay()
//    }
//
//    private func setupContainerStackView() {
//        containerStackView.axis = .vertical
//        containerStackView.spacing = 12
//        containerStackView.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(containerStackView)
//
//        NSLayoutConstraint.activate([
//            containerStackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
//            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
//            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
//            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
//        ])
//    }
//
//    private func setupHeaderStackView() {
//        headerStackView.axis = .horizontal
//        headerStackView.distribution = .fillProportionally
//        headerStackView.alignment = .center
//
//        let titleLabel = UILabel()
//        titleLabel.text = "Select Statuses"
//        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//        titleLabel.textColor = .label
//        titleLabel.isUserInteractionEnabled = true
//
//        // Добавляем tap gesture для titleLabel
//        let titleTapGesture = UITapGestureRecognizer(target: self, action: #selector(selectButtonTapped))
//        titleLabel.addGestureRecognizer(titleTapGesture)
//
//        headerStackView.addArrangedSubview(titleLabel)
//        headerStackView.addArrangedSubview(selectButton)
//
//        containerStackView.addArrangedSubview(headerStackView)
//    }
//
//    private func setupTagsStackView() {
//        tagsStackView.axis = .vertical
//        tagsStackView.spacing = 8
//        containerStackView.addArrangedSubview(tagsStackView)
//    }
//
//    private func setupSelectButton() {
//        selectButton.setTitle("▼", for: .normal)
//        selectButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//        selectButton.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
//        selectButton.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            selectButton.widthAnchor.constraint(equalToConstant: 30),
//            selectButton.heightAnchor.constraint(equalToConstant: 30)
//        ])
//    }
//
//    private func setupBackgroundOverlay() {
//        backgroundOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.3)
//        backgroundOverlay.alpha = 0
//        backgroundOverlay.isHidden = true
//
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
//        backgroundOverlay.addGestureRecognizer(tapGesture)
//    }
//
//    private func setupDropdownTableView() {
//        dropdownTableView.delegate = self
//        dropdownTableView.dataSource = self
//        dropdownTableView.register(StatusTableViewCell.self, forCellReuseIdentifier: "StatusCell")
//        dropdownTableView.layer.cornerRadius = 8
//        dropdownTableView.layer.borderWidth = 1
//        dropdownTableView.layer.borderColor = UIColor.systemGray4.cgColor
//        dropdownTableView.backgroundColor = .systemBackground
//        dropdownTableView.translatesAutoresizingMaskIntoConstraints = false
//        dropdownTableView.isHidden = true
//    }
//
//    private func setupInitialSelection() {
//        // Предустановленные статусы как на скриншоте
//        let preselectedIds = ["delivered", "hardBounce"]
//        selectedStatuses = allStatuses.filter { preselectedIds.contains($0.id) }
//        updateTagsView()
//    }
//
//    private func updateTagsView() {
//        // Очищаем существующие теги
//        tagsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
//
//        if selectedStatuses.isEmpty {
//            tagsStackView.isHidden = true
//            return
//        }
//
//        tagsStackView.isHidden = false
//
//        // Создаем горизонтальные контейнеры для тегов
//        var currentRowStackView: UIStackView?
//        let maxRowWidth: CGFloat = 300 // Примерная ширина
//
//        for status in selectedStatuses {
//            if currentRowStackView == nil {
//                currentRowStackView = createRowStackView()
//                tagsStackView.addArrangedSubview(currentRowStackView!)
//            }
//
//            let tagView = StatusTagView(status: status)
//            tagView.onRemove = { [weak self] in
//                self?.removeStatus(status)
//            }
//
//            currentRowStackView!.addArrangedSubview(tagView)
//
//            // Если строка становится слишком широкой, создаем новую
//            if currentRowStackView!.arrangedSubviews.count >= 3 {
//                currentRowStackView = nil
//            }
//        }
//    }
//
//    private func createRowStackView() -> UIStackView {
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.spacing = 8
//        stackView.alignment = .leading
//        stackView.distribution = .fillProportionally
//        return stackView
//    }
//
//    private func removeStatus(_ status: EmailStatus) {
//        selectedStatuses.removeAll { $0.id == status.id }
//        updateTagsView()
//        dropdownTableView.reloadData()
//        onSelectionChanged?(selectedStatuses)
//    }
//
//    @objc private func selectButtonTapped() {
//        toggleDropdown()
//    }
//
//    @objc private func backgroundTapped() {
//        hideDropdown()
//    }
//
//    private func toggleDropdown() {
//        if isDropdownVisible {
//            hideDropdown()
//        } else {
//            showDropdown()
//        }
//    }
//
//    private func showDropdown() {
//        guard let window = self.window else { return }
//
//        isDropdownVisible = true
//        selectButton.setTitle("▲", for: .normal)
//
//        // Добавляем overlay
//        backgroundOverlay.frame = window.bounds
//        backgroundOverlay.isHidden = false
//        window.addSubview(backgroundOverlay)
//
//        // Позиционируем dropdown
//        let globalFrame = self.convert(self.bounds, to: window)
//        dropdownTableView.frame = CGRect(
//            x: globalFrame.origin.x,
//            y: globalFrame.maxY + 4,
//            width: globalFrame.width,
//            height: min(300, CGFloat(allStatuses.count * 50))
//        )
//
//        dropdownTableView.isHidden = false
//        window.addSubview(dropdownTableView)
//
//        // Анимация появления
//        UIView.animate(withDuration: 0.2) {
//            self.backgroundOverlay.alpha = 1
//        }
//    }
//
//    private func hideDropdown() {
//        isDropdownVisible = false
//        selectButton.setTitle("▼", for: .normal)
//
//        UIView.animate(withDuration: 0.2, animations: {
//            self.backgroundOverlay.alpha = 0
//        }) { _ in
//            self.backgroundOverlay.isHidden = true
//            self.backgroundOverlay.removeFromSuperview()
//            self.dropdownTableView.isHidden = true
//            self.dropdownTableView.removeFromSuperview()
//        }
//    }
//}
//
//// MARK: - TableView DataSource & Delegate
//extension MultiSelectStatusView: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return allStatuses.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "StatusCell", for: indexPath) as! StatusTableViewCell
//        let status = allStatuses[indexPath.row]
//        let isSelected = selectedStatuses.contains { $0.id == status.id }
//        cell.configure(with: status, isSelected: isSelected)
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let status = allStatuses[indexPath.row]
//
//        if let index = selectedStatuses.firstIndex(where: { $0.id == status.id }) {
//            selectedStatuses.remove(at: index)
//        } else {
//            selectedStatuses.append(status)
//        }
//
//        updateTagsView()
//        tableView.reloadRows(at: [indexPath], with: .none)
//        onSelectionChanged?(selectedStatuses)
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
//}
//
//// MARK: - Usage Example
//class ExampleViewController: UIViewController {
//    private let multiSelectView = MultiSelectStatusView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//
//        multiSelectView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(multiSelectView)
//
//        NSLayoutConstraint.activate([
//            multiSelectView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
//            multiSelectView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            multiSelectView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
//        ])
//
//        multiSelectView.onSelectionChanged = { selectedStatuses in
//            print("Selected statuses: \(selectedStatuses.map { $0.title })")
//        }
//    }
//}

import UIKit

// MARK: - Selection Mode
enum SelectionMode {
    case single
    case multiple
}

// MARK: - Status Model
struct EmailStatus {
    let id: String
    let title: String
    let color: UIColor
    
    static let allStatuses = [
        EmailStatus(id: "delivered", title: "Delivered", color: .systemGreen),
        EmailStatus(id: "hardBounce", title: "Hard Bounce", color: .systemRed),
        EmailStatus(id: "softBounce", title: "Soft Bounce", color: .systemBlue),
        EmailStatus(id: "blocked", title: "Blocked", color: .systemGray),
        EmailStatus(id: "complaint", title: "Complaint", color: .systemOrange),
        EmailStatus(id: "error", title: "Error", color: .systemRed),
        EmailStatus(id: "filtered", title: "Filtered", color: .systemYellow),
        EmailStatus(id: "incorrect", title: "Incorrect", color: .systemPink),
        EmailStatus(id: "queued", title: "Queued", color: .systemIndigo),
        EmailStatus(id: "unsubscribe", title: "Unsubscribe", color: .systemPurple)
    ]
}

// MARK: - Selected Status Tag View (for multiselect)
class StatusTagView: UIView {
    private let titleLabel = UILabel()
    private let removeButton = UIButton(type: .system)
    
    var onRemove: (() -> Void)?
    
    init(status: EmailStatus) {
        super.init(frame: .zero)
        setupView(with: status)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(with status: EmailStatus) {
        backgroundColor = status.color.withAlphaComponent(0.2)
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = status.color.cgColor
        
        titleLabel.text = status.title
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = status.color
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        removeButton.setTitle("×", for: .normal)
        removeButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        removeButton.tintColor = status.color
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        
        addSubview(titleLabel)
        addSubview(removeButton)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            removeButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            removeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            removeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            removeButton.widthAnchor.constraint(equalToConstant: 20),
            removeButton.heightAnchor.constraint(equalToConstant: 20),
            
            heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    @objc private func removeButtonTapped() {
        onRemove?()
    }
}

// MARK: - Single Selection Display View
class SingleStatusView: UIView {
    private let colorView = UIView()
    private let titleLabel = UILabel()
    private let chevronImageView = UIImageView()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
        
        colorView.layer.cornerRadius = 4
        colorView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .label
        titleLabel.text = "Select Status"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        chevronImageView.image = UIImage(systemName: "chevron.down")
        chevronImageView.tintColor = .systemGray
        chevronImageView.contentMode = .scaleAspectFit
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(colorView)
        addSubview(titleLabel)
        addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            colorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 8),
            colorView.heightAnchor.constraint(equalToConstant: 8),
            
            titleLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            chevronImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            chevronImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 16),
            chevronImageView.heightAnchor.constraint(equalToConstant: 16),
            
            heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func configure(with status: EmailStatus?) {
        if let status = status {
            titleLabel.text = status.title
            colorView.backgroundColor = status.color
            colorView.isHidden = false
        } else {
            titleLabel.text = "Select Status"
            colorView.isHidden = true
        }
    }
    
    func setDropdownState(_ isOpen: Bool) {
        let imageName = isOpen ? "chevron.up" : "chevron.down"
        chevronImageView.image = UIImage(systemName: imageName)
    }
}

// MARK: - Dropdown Table View Cell
class StatusTableViewCell: UITableViewCell {
    private let checkmarkImageView = UIImageView()
    private let radioImageView = UIImageView()
    private let titleLabel = UILabel()
    private let colorView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        selectionStyle = .none
        
        colorView.layer.cornerRadius = 4
        colorView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Checkmark for multiselect
        checkmarkImageView.image = UIImage(systemName: "checkmark")
        checkmarkImageView.tintColor = .systemBlue
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkImageView.isHidden = true
        
        // Radio button for single select
        radioImageView.tintColor = .systemBlue
        radioImageView.translatesAutoresizingMaskIntoConstraints = false
        radioImageView.isHidden = true
        
        contentView.addSubview(colorView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(checkmarkImageView)
        contentView.addSubview(radioImageView)
        
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 8),
            colorView.heightAnchor.constraint(equalToConstant: 8),
            
            titleLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 20),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 20),
            
            radioImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            radioImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            radioImageView.widthAnchor.constraint(equalToConstant: 20),
            radioImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(with status: EmailStatus, isSelected: Bool, selectionMode: SelectionMode) {
        titleLabel.text = status.title
        colorView.backgroundColor = status.color
        
        switch selectionMode {
        case .single:
            checkmarkImageView.isHidden = true
            radioImageView.isHidden = false
            radioImageView.image = UIImage(systemName: isSelected ? "largecircle.fill.circle" : "circle")
        case .multiple:
            radioImageView.isHidden = true
            checkmarkImageView.isHidden = !isSelected
        }
    }
}

// MARK: - Flexible Status Selector View
class StatusSelectorView: UIView {
    private let containerStackView = UIStackView()
    private let headerStackView = UIStackView()
    private let tagsStackView = UIStackView()
    private let singleStatusView = SingleStatusView()
    private let dropdownTableView = UITableView()
    private let backgroundOverlay = UIView()
    
    private var allStatuses = EmailStatus.allStatuses
    private var selectedStatuses: [EmailStatus] = []
    private var isDropdownVisible = false
    
    // Configuration
    var selectionMode: SelectionMode = .single {
        didSet {
            updateDisplayMode()
        }
    }
    
    var placeholder: String = "Select Status" {
        didSet {
            updatePlaceholder()
        }
    }
    
    // Callbacks
    var onSelectionChanged: (([EmailStatus]) -> Void)?
    var onSingleSelectionChanged: ((EmailStatus?) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
        
        setupContainerStackView()
        setupSingleStatusView()
        setupTagsStackView()
        setupDropdownTableView()
        setupBackgroundOverlay()
        updateDisplayMode()
    }
    
    private func setupContainerStackView() {
        containerStackView.axis = .vertical
        containerStackView.spacing = 12
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerStackView)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    private func setupSingleStatusView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleDropdown))
        singleStatusView.addGestureRecognizer(tapGesture)
        singleStatusView.isUserInteractionEnabled = true
    }
    
    private func setupTagsStackView() {
        tagsStackView.axis = .vertical
        tagsStackView.spacing = 8
    }
    
    private func setupBackgroundOverlay() {
        backgroundOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        backgroundOverlay.alpha = 0
        backgroundOverlay.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundOverlay.addGestureRecognizer(tapGesture)
    }
    
    private func setupDropdownTableView() {
        dropdownTableView.delegate = self
        dropdownTableView.dataSource = self
        dropdownTableView.register(StatusTableViewCell.self, forCellReuseIdentifier: "StatusCell")
        dropdownTableView.layer.cornerRadius = 8
        dropdownTableView.layer.borderWidth = 1
        dropdownTableView.layer.borderColor = UIColor.systemGray4.cgColor
        dropdownTableView.backgroundColor = .systemBackground
        dropdownTableView.translatesAutoresizingMaskIntoConstraints = false
        dropdownTableView.isHidden = true
    }
    
    private func updateDisplayMode() {
        containerStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        switch selectionMode {
        case .single:
            containerStackView.addArrangedSubview(singleStatusView)
            updateSingleStatusDisplay()
        case .multiple:
            setupMultipleHeader()
            containerStackView.addArrangedSubview(headerStackView)
            containerStackView.addArrangedSubview(tagsStackView)
            updateTagsView()
        }
    }
    
    private func setupMultipleHeader() {
        headerStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        headerStackView.axis = .horizontal
        headerStackView.distribution = .fillProportionally
        headerStackView.alignment = .center
        
        let titleLabel = UILabel()
        titleLabel.text = placeholder
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .label
        titleLabel.isUserInteractionEnabled = true
        
        let selectButton = UIButton(type: .system)
        selectButton.setTitle("▼", for: .normal)
        selectButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        selectButton.addTarget(self, action: #selector(toggleDropdown), for: .touchUpInside)
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            selectButton.widthAnchor.constraint(equalToConstant: 30),
            selectButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        let titleTapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleDropdown))
        titleLabel.addGestureRecognizer(titleTapGesture)
        
        headerStackView.addArrangedSubview(titleLabel)
        headerStackView.addArrangedSubview(selectButton)
    }
    
    private func updateSingleStatusDisplay() {
        let selectedStatus = selectedStatuses.first
        singleStatusView.configure(with: selectedStatus)
        singleStatusView.setDropdownState(isDropdownVisible)
    }
    
    private func updateTagsView() {
        tagsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if selectedStatuses.isEmpty {
            tagsStackView.isHidden = true
            return
        }
        
        tagsStackView.isHidden = false
        
        var currentRowStackView: UIStackView?
        
        for status in selectedStatuses {
            if currentRowStackView == nil {
                currentRowStackView = createRowStackView()
                tagsStackView.addArrangedSubview(currentRowStackView!)
            }
            
            let tagView = StatusTagView(status: status)
            tagView.onRemove = { [weak self] in
                self?.removeStatus(status)
            }
            
            currentRowStackView!.addArrangedSubview(tagView)
            
            if currentRowStackView!.arrangedSubviews.count >= 3 {
                currentRowStackView = nil
            }
        }
    }
    
    private func createRowStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        return stackView
    }
    
    private func updatePlaceholder() {
        if selectionMode == .single {
            singleStatusView.configure(with: selectedStatuses.first)
        } else {
            updateDisplayMode()
        }
    }
    
    private func removeStatus(_ status: EmailStatus) {
        selectedStatuses.removeAll { $0.id == status.id }
        updateTagsView()
        dropdownTableView.reloadData()
        notifySelectionChanged()
    }
    
    private func notifySelectionChanged() {
        switch selectionMode {
        case .single:
            onSingleSelectionChanged?(selectedStatuses.first)
        case .multiple:
            onSelectionChanged?(selectedStatuses)
        }
    }
    
    // MARK: - Public Methods
    
    func setSelectedStatuses(_ statuses: [EmailStatus]) {
        selectedStatuses = statuses
        updateDisplayMode()
        dropdownTableView.reloadData()
    }
    
    func setSelectedStatus(_ status: EmailStatus?) {
        if let status = status {
            selectedStatuses = [status]
        } else {
            selectedStatuses = []
        }
        updateDisplayMode()
        dropdownTableView.reloadData()
    }
    
    @objc private func toggleDropdown() {
        if isDropdownVisible {
            hideDropdown()
        } else {
            showDropdown()
        }
    }
    
    @objc private func backgroundTapped() {
        hideDropdown()
    }
    
    private func showDropdown() {
        guard let window = self.window else { return }
        
        isDropdownVisible = true
        
        if selectionMode == .single {
            singleStatusView.setDropdownState(true)
        } else {
            if let selectButton = headerStackView.arrangedSubviews.last as? UIButton {
                selectButton.setTitle("▲", for: .normal)
            }
        }
        
        backgroundOverlay.frame = window.bounds
        backgroundOverlay.isHidden = false
        window.addSubview(backgroundOverlay)
        
        let globalFrame = self.convert(self.bounds, to: window)
        dropdownTableView.frame = CGRect(
            x: globalFrame.origin.x,
            y: globalFrame.maxY + 4,
            width: globalFrame.width,
            height: min(300, CGFloat(allStatuses.count * 50))
        )
        
        dropdownTableView.isHidden = false
        window.addSubview(dropdownTableView)
        
        UIView.animate(withDuration: 0.2) {
            self.backgroundOverlay.alpha = 1
        }
    }
    
    private func hideDropdown() {
        isDropdownVisible = false
        
        if selectionMode == .single {
            singleStatusView.setDropdownState(false)
        } else {
            if let selectButton = headerStackView.arrangedSubviews.last as? UIButton {
                selectButton.setTitle("▼", for: .normal)
            }
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundOverlay.alpha = 0
        }) { _ in
            self.backgroundOverlay.isHidden = true
            self.backgroundOverlay.removeFromSuperview()
            self.dropdownTableView.isHidden = true
            self.dropdownTableView.removeFromSuperview()
        }
    }
}

// MARK: - TableView DataSource & Delegate
extension StatusSelectorView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allStatuses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatusCell", for: indexPath) as! StatusTableViewCell
        let status = allStatuses[indexPath.row]
        let isSelected = selectedStatuses.contains { $0.id == status.id }
        cell.configure(with: status, isSelected: isSelected, selectionMode: selectionMode)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let status = allStatuses[indexPath.row]
        
        switch selectionMode {
        case .single:
            selectedStatuses = [status]
            updateSingleStatusDisplay()
            tableView.reloadData() // Перезагружаем всю таблицу для обновления radio buttons
            hideDropdown()
        case .multiple:
            if let index = selectedStatuses.firstIndex(where: { $0.id == status.id }) {
                selectedStatuses.remove(at: index)
            } else {
                selectedStatuses.append(status)
            }
            updateTagsView()
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        notifySelectionChanged()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

// MARK: - Usage Examples
//class ExampleViewController: UIViewController {
//    private let singleSelectView = StatusSelectorView()
//    private let multiSelectView = StatusSelectorView()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//        title = "Status Selector Example"
//        
//        setupSingleSelect()
//        setupMultiSelect()
//        setupLayout()
//    }
//    
//    private func setupSingleSelect() {
//        // Single select configuration (default)
//        singleSelectView.selectionMode = .single
//        singleSelectView.placeholder = "Choose Status"
//        singleSelectView.translatesAutoresizingMaskIntoConstraints = false
//        
//        singleSelectView.onSingleSelectionChanged = { status in
//            print("Single selection: \(status?.title ?? "None")")
//        }
//        
//        view.addSubview(singleSelectView)
//    }
//    
//    private func setupMultiSelect() {
//        // Multi select configuration
//        multiSelectView.selectionMode = .multiple
//        multiSelectView.placeholder = "Select Multiple Statuses"
//        multiSelectView.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Set initial selection for demo
//        let preselectedStatuses = EmailStatus.allStatuses.filter { ["delivered", "hardBounce"].contains($0.id) }
//        multiSelectView.setSelectedStatuses(preselectedStatuses)
//        
//        multiSelectView.onSelectionChanged = { statuses in
//            print("Multiple selection: \(statuses.map { $0.title })")
//        }
//        
//        view.addSubview(multiSelectView)
//    }
//    
//    private func setupLayout() {
//        NSLayoutConstraint.activate([
//            singleSelectView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
//            singleSelectView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            singleSelectView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            
//            multiSelectView.topAnchor.constraint(equalTo: singleSelectView.bottomAnchor, constant: 30),
//            multiSelectView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            multiSelectView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
//        ])
//    }
//}
