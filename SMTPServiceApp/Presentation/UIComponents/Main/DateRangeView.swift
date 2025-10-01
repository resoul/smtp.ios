import UIKit

// MARK: - DateRangeView Component
final class DateRangeView: UIView {
    
    // MARK: - Callbacks
    var onDateRangeSelected: ((Date, Date) -> Void)?
    var onDateRangeCleared: (() -> Void)?
    
    // MARK: - Public Properties
    var placeholder: String = "Select date range" {
        didSet {
            if startDate == nil || endDate == nil {
                dateRangeLabel.text = placeholder
            }
        }
    }
    
    var dateFormat: String = "MM/dd/yyyy" {
        didSet {
            updateDateRangeLabel()
        }
    }
    
    // MARK: - Private UI Components
    private let dateRangeLabel: UILabel = {
        let label = UILabel()
        label.text = "Select date range"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17)
        label.backgroundColor = .systemGray6
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    private let calendarView: UICalendarView = {
        let view = UICalendarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.calendar = Calendar.current
        view.locale = Locale.current
        view.fontDesign = .default
        return view
    }()
    
    private let selectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Date Range", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Clear", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Private Properties
    private var isPickerVisible = false
    private var containerHeightConstraint: NSLayoutConstraint?
    private var startDate: DateComponents?
    private var endDate: DateComponents?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupCalendar()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupCalendar()
        setupActions()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        addSubview(dateRangeLabel)
        addSubview(containerView)
        
        containerView.addSubview(calendarView)
        containerView.addSubview(selectButton)
        containerView.addSubview(clearButton)
        
        containerHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            dateRangeLabel.topAnchor.constraint(equalTo: topAnchor),
            dateRangeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            dateRangeLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            dateRangeLabel.heightAnchor.constraint(equalToConstant: 50),
            
            containerView.topAnchor.constraint(equalTo: dateRangeLabel.bottomAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerHeightConstraint!,
            
            calendarView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            calendarView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            calendarView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            calendarView.heightAnchor.constraint(equalToConstant: 400),
            
            clearButton.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 16),
            clearButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            clearButton.widthAnchor.constraint(equalToConstant: 100),
            clearButton.heightAnchor.constraint(equalToConstant: 44),
            
            selectButton.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 16),
            selectButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            selectButton.leadingAnchor.constraint(equalTo: clearButton.trailingAnchor, constant: 12),
            selectButton.heightAnchor.constraint(equalToConstant: 44),
            selectButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupCalendar() {
        let multiDateSelection = UICalendarSelectionMultiDate(delegate: self)
        calendarView.selectionBehavior = multiDateSelection
    }
    
    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dateRangeLabelTapped))
        dateRangeLabel.addGestureRecognizer(tapGesture)
        
        selectButton.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func dateRangeLabelTapped() {
        isPickerVisible.toggle()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            if self.isPickerVisible {
                self.containerHeightConstraint?.constant = 520
                self.containerView.alpha = 1
            } else {
                self.containerHeightConstraint?.constant = 0
                self.containerView.alpha = 0
            }
            self.layoutIfNeeded()
        }
    }
    
    @objc private func selectButtonTapped() {
        if let start = startDate, let end = endDate,
           let startDateObj = Calendar.current.date(from: start),
           let endDateObj = Calendar.current.date(from: end) {
            updateDateRangeLabel()
            onDateRangeSelected?(startDateObj, endDateObj)
            dateRangeLabelTapped() // Close the picker
        }
    }
    
    @objc private func clearButtonTapped() {
        if let selection = calendarView.selectionBehavior as? UICalendarSelectionMultiDate {
            selection.setSelectedDates([], animated: true)
        }
        startDate = nil
        endDate = nil
        dateRangeLabel.text = placeholder
        onDateRangeCleared?()
        dateRangeLabelTapped() // Close the picker
    }
    
    // MARK: - Public Methods
    func setDateRange(start: Date, end: Date) {
        let startComponents = Calendar.current.dateComponents([.year, .month, .day], from: start)
        let endComponents = Calendar.current.dateComponents([.year, .month, .day], from: end)
        
        startDate = startComponents
        endDate = endComponents
        
        selectDateRange(from: startComponents, to: endComponents)
        updateDateRangeLabel()
    }
    
    func clearSelection() {
        clearButtonTapped()
    }
    
    func getSelectedDates() -> (start: Date?, end: Date?) {
        guard let start = startDate, let end = endDate else {
            return (nil, nil)
        }
        return (Calendar.current.date(from: start), Calendar.current.date(from: end))
    }
    
    // MARK: - Private Helper Methods
    private func updateDateRangeLabel() {
        guard let start = startDate, let end = endDate,
              let startDateObj = Calendar.current.date(from: start),
              let endDateObj = Calendar.current.date(from: end) else {
            dateRangeLabel.text = placeholder
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        
        let startDateString = formatter.string(from: startDateObj)
        let endDateString = formatter.string(from: endDateObj)
        
        dateRangeLabel.text = "\(startDateString) - \(endDateString)"
    }
    
    private func selectDateRange(from start: DateComponents, to end: DateComponents) {
        guard let selection = calendarView.selectionBehavior as? UICalendarSelectionMultiDate else { return }
        guard let startDate = Calendar.current.date(from: start),
              let endDate = Calendar.current.date(from: end) else { return }
        
        var datesToSelect: [DateComponents] = []
        var currentDate = startDate
        
        while currentDate <= endDate {
            datesToSelect.append(Calendar.current.dateComponents([.year, .month, .day], from: currentDate))
            guard let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = nextDate
        }
        
        selection.setSelectedDates(datesToSelect, animated: true)
    }
}

// MARK: - UICalendarSelectionMultiDateDelegate
extension DateRangeView: UICalendarSelectionMultiDateDelegate {
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didSelectDate dateComponents: DateComponents) {
        let selectedDates = selection.selectedDates.sorted { date1, date2 in
            guard let d1 = Calendar.current.date(from: date1),
                  let d2 = Calendar.current.date(from: date2) else { return false }
            return d1 < d2
        }
        
        guard let clickedDate = Calendar.current.date(from: dateComponents) else { return }
        
        // Если уже есть выбранный диапазон
        if let start = startDate, let end = endDate,
           let startDateObj = Calendar.current.date(from: start),
           let endDateObj = Calendar.current.date(from: end) {
            
            // Проверяем, клик внутри текущего диапазона
            if clickedDate >= startDateObj && clickedDate <= endDateObj {
                // Клик внутри диапазона - оставляем от start до clicked
                startDate = start
                endDate = dateComponents
                selectDateRange(from: start, to: dateComponents)
                return
            } else {
                // Клик вне диапазона - начинаем новый выбор
                selection.setSelectedDates([dateComponents], animated: true)
                startDate = dateComponents
                endDate = nil
                return
            }
        }
        
        if selectedDates.count == 1 {
            // Первая дата выбрана - это start date
            startDate = selectedDates[0]
            endDate = nil
        } else if selectedDates.count >= 2 {
            // Вторая дата выбрана - создаем диапазон
            startDate = selectedDates.first
            endDate = selectedDates.last
            
            if let start = startDate, let end = endDate {
                selectDateRange(from: start, to: end)
            }
        }
    }
    
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didDeselectDate dateComponents: DateComponents) {
        // Этот метод не должен вызываться из-за canDeselectDate
    }
    
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, canSelectDate dateComponents: DateComponents) -> Bool {
        return true
    }
    
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, canDeselectDate dateComponents: DateComponents) -> Bool {
        // Запрещаем ручной deselect
        return false
    }
}
