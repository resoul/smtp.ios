import UIKit

final class LineChartView: UIView {
    
    private let titleLabel = UILabel()
    private let legendScrollView = UIScrollView()
    private let legendStackView = UIStackView()
    private let chartCanvasView = LineChartCanvasView()
    
    private var configuration: LineChartConfiguration?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.separator.cgColor
        
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        legendScrollView.showsHorizontalScrollIndicator = false
        legendScrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(legendScrollView)
        
        legendStackView.axis = .horizontal
        legendStackView.spacing = 16
        legendStackView.translatesAutoresizingMaskIntoConstraints = false
        legendScrollView.addSubview(legendStackView)
        
        chartCanvasView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(chartCanvasView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            legendScrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            legendScrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            legendScrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            legendScrollView.heightAnchor.constraint(equalToConstant: 30),
            
            legendStackView.topAnchor.constraint(equalTo: legendScrollView.topAnchor),
            legendStackView.leadingAnchor.constraint(equalTo: legendScrollView.leadingAnchor),
            legendStackView.trailingAnchor.constraint(equalTo: legendScrollView.trailingAnchor),
            legendStackView.bottomAnchor.constraint(equalTo: legendScrollView.bottomAnchor),
            legendStackView.heightAnchor.constraint(equalTo: legendScrollView.heightAnchor),
            
            chartCanvasView.topAnchor.constraint(equalTo: legendScrollView.bottomAnchor, constant: 16),
            chartCanvasView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            chartCanvasView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            chartCanvasView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    private func setupLegend(for config: LineChartConfiguration) {
        legendStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        guard config.showLegend else { return }
        
        for series in config.series {
            let container = UIStackView()
            container.axis = .horizontal
            container.spacing = 6
            container.alignment = .center
            
            let circle = UIView()
            circle.backgroundColor = series.color
            circle.layer.cornerRadius = 5
            circle.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                circle.widthAnchor.constraint(equalToConstant: 10),
                circle.heightAnchor.constraint(equalToConstant: 10)
            ])
            
            let label = UILabel()
            label.text = series.name
            label.textColor = series.color
            label.font = .systemFont(ofSize: 12, weight: .medium)
            
            container.addArrangedSubview(circle)
            container.addArrangedSubview(label)
            legendStackView.addArrangedSubview(container)
        }
    }
    
    func configure(with config: LineChartConfiguration) {
        self.configuration = config
        titleLabel.text = config.title
        setupLegend(for: config)
        chartCanvasView.configuration = config
        chartCanvasView.setNeedsDisplay()
    }
}
