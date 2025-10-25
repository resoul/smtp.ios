import UIKit

final class StackedBarChartView: UIView {
    
    private let legendStackView = UIStackView()
    private let scrollView = UIScrollView()
    private let chartCanvasView = StackedBarCanvasView()
    
    private var configuration: StackedBarChartConfiguration?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        
        legendStackView.axis = .horizontal
        legendStackView.spacing = 16
        legendStackView.distribution = .fillProportionally
        legendStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(legendStackView)
        
        scrollView.showsVerticalScrollIndicator = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        
        chartCanvasView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(chartCanvasView)
        
        NSLayoutConstraint.activate([
            legendStackView.topAnchor.constraint(equalTo: topAnchor),
            legendStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            legendStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            legendStackView.heightAnchor.constraint(equalToConstant: 30),
            
            scrollView.topAnchor.constraint(equalTo: legendStackView.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            chartCanvasView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            chartCanvasView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            chartCanvasView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            chartCanvasView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            chartCanvasView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupLegend(categories: [StackedBarCategory]) {
        legendStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for category in categories {
            let container = UIStackView()
            container.axis = .horizontal
            container.spacing = 6
            container.alignment = .center
            
            let square = UIView()
            square.backgroundColor = category.color
            square.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                square.widthAnchor.constraint(equalToConstant: 12),
                square.heightAnchor.constraint(equalToConstant: 12)
            ])
            
            let label = UILabel()
            label.text = category.name
            label.font = .systemFont(ofSize: 11, weight: .regular)
            label.textColor = .label
            
            container.addArrangedSubview(square)
            container.addArrangedSubview(label)
            legendStackView.addArrangedSubview(container)
        }
    }
    
    func configure(with configuration: StackedBarChartConfiguration) {
        self.configuration = configuration
        setupLegend(categories: configuration.categories)
        
        chartCanvasView.configuration = configuration
        
        let barHeight: CGFloat = 30
        let barSpacing: CGFloat = 10
        let contentHeight = CGFloat(configuration.data.count) * (barHeight + barSpacing) + 100
        
        chartCanvasView.heightAnchor.constraint(equalToConstant: contentHeight).isActive = true
        chartCanvasView.setNeedsDisplay()
    }
}
