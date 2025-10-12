import UIKit

final class LineChartCanvasView: UIView {
    
    var configuration: LineChartConfiguration?
    
    private let padding: CGFloat = 50
    private let topPadding: CGFloat = 20
    private let bottomPadding: CGFloat = 35
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let config = configuration, !config.series.isEmpty else { return }
        
        drawAxes(in: rect)
        drawGridLines(in: rect, config: config)
        drawXLabels(in: rect, config: config)
        drawYLabels(in: rect, config: config)
        drawLines(in: rect, config: config)
        
        if config.showDataLabels {
            drawPoints(in: rect, config: config)
        }
    }
    
    private func getAllDates(from config: LineChartConfiguration) -> [Date] {
        var allDates = Set<Date>()
        config.series.forEach { series in
            series.dataPoints.forEach { allDates.insert($0.date) }
        }
        return Array(allDates).sorted()
    }
    
    private func drawAxes(in rect: CGRect) {
        let axisPath = UIBezierPath()
        UIColor.separator.setStroke()
        
        axisPath.move(to: CGPoint(x: padding, y: topPadding))
        axisPath.addLine(to: CGPoint(x: padding, y: rect.height - bottomPadding))
        axisPath.addLine(to: CGPoint(x: rect.width, y: rect.height - bottomPadding))
        
        axisPath.lineWidth = 1.5
        axisPath.stroke()
    }
    
    private func drawGridLines(in rect: CGRect, config: LineChartConfiguration) {
        let steps = Int(config.maxValue / config.yAxisStride)
        let chartHeight = rect.height - topPadding - bottomPadding
        let gridPath = UIBezierPath()
        UIColor.separator.withAlphaComponent(0.2).setStroke()
        
        for i in 0...steps {
            let y = rect.height - bottomPadding - (chartHeight * CGFloat(i) / CGFloat(steps))
            gridPath.move(to: CGPoint(x: padding, y: y))
            gridPath.addLine(to: CGPoint(x: rect.width, y: y))
        }
        
        gridPath.lineWidth = 0.5
        gridPath.stroke()
    }
    
    private func drawXLabels(in rect: CGRect, config: LineChartConfiguration) {
        let dates = getAllDates(from: config)
        guard dates.count > 1 else { return }
        
        let chartWidth = rect.width - padding
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: UIColor.secondaryLabel
        ]
        
        for (index, date) in dates.enumerated() {
            let x = padding + (chartWidth / CGFloat(dates.count - 1)) * CGFloat(index)
            let label = formatter.string(from: date)
            
            let size = (label as NSString).size(withAttributes: attributes)
            let point = CGPoint(x: x - size.width / 2, y: rect.height - bottomPadding + 10)
            (label as NSString).draw(at: point, withAttributes: attributes)
        }
    }
    
    private func drawYLabels(in rect: CGRect, config: LineChartConfiguration) {
        let steps = Int(config.maxValue / config.yAxisStride)
        let chartHeight = rect.height - topPadding - bottomPadding
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: UIColor.secondaryLabel
        ]
        
        for i in 0...steps {
            let value = config.yAxisStride * Double(i)
            let label = String(format: "%.0f", value)
            let y = rect.height - bottomPadding - (chartHeight * CGFloat(i) / CGFloat(steps))
            
            let size = (label as NSString).size(withAttributes: attributes)
            let point = CGPoint(x: padding - size.width - 10, y: y - size.height / 2)
            (label as NSString).draw(at: point, withAttributes: attributes)
        }
    }
    
    private func drawLines(in rect: CGRect, config: LineChartConfiguration) {
        let dates = getAllDates(from: config)
        guard dates.count > 1 else { return }
        
        let chartWidth = rect.width - padding
        let chartHeight = rect.height - topPadding - bottomPadding
        
        for series in config.series {
            guard !series.dataPoints.isEmpty else { continue }
            
            let path = UIBezierPath()
            series.color.setStroke()
            
            var isFirstPoint = true
            for point in series.dataPoints.sorted(by: { $0.date < $1.date }) {
                guard let dateIndex = dates.firstIndex(of: point.date) else { continue }
                
                let x = padding + (chartWidth / CGFloat(dates.count - 1)) * CGFloat(dateIndex)
                let y = rect.height - bottomPadding - (chartHeight * CGFloat(point.value / config.maxValue))
                
                if isFirstPoint {
                    path.move(to: CGPoint(x: x, y: y))
                    isFirstPoint = false
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            
            path.lineWidth = 2.5
            path.lineCapStyle = .round
            path.lineJoinStyle = .round
            path.stroke()
        }
    }
    
    private func drawPoints(in rect: CGRect, config: LineChartConfiguration) {
        let dates = getAllDates(from: config)
        guard dates.count > 1 else { return }
        
        let chartWidth = rect.width - padding
        let chartHeight = rect.height - topPadding - bottomPadding
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 8, weight: .semibold),
            .foregroundColor: UIColor.label
        ]
        
        for series in config.series {
            for point in series.dataPoints {
                guard let dateIndex = dates.firstIndex(of: point.date) else { continue }
                
                let x = padding + (chartWidth / CGFloat(dates.count - 1)) * CGFloat(dateIndex)
                let y = rect.height - bottomPadding - (chartHeight * CGFloat(point.value / config.maxValue))
                
                let outerCircle = UIBezierPath(arcCenter: CGPoint(x: x, y: y),
                                               radius: 5,
                                               startAngle: 0,
                                               endAngle: .pi * 2,
                                               clockwise: true)
                UIColor.systemBackground.setFill()
                outerCircle.fill()
                
                let innerCircle = UIBezierPath(arcCenter: CGPoint(x: x, y: y),
                                               radius: 3.5,
                                               startAngle: 0,
                                               endAngle: .pi * 2,
                                               clockwise: true)
                series.color.setFill()
                innerCircle.fill()
                
                let valueLabel = String(format: "%.1f", point.value)
                let size = (valueLabel as NSString).size(withAttributes: attributes)
                let labelPoint = CGPoint(x: x - size.width / 2, y: y - 18)
                (valueLabel as NSString).draw(at: labelPoint, withAttributes: attributes)
            }
        }
    }
}
