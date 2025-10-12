import AsyncDisplayKit

final class StackedBarCanvasView: UIView {
    
    var configuration: StackedBarChartConfiguration?
    
    private let leftPadding: CGFloat = 150
    private let rightPadding: CGFloat = 20
    private let topPadding: CGFloat = 20
    private let barHeight: CGFloat = 30
    private let barSpacing: CGFloat = 10
    
    private var tooltipView: StackedBarTooltipNode?
    private var hoveredBarIndex: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupHoverTracking()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHoverTracking() {
        let hoverGesture = UIHoverGestureRecognizer(target: self, action: #selector(handleHover(_:)))
        addGestureRecognizer(hoverGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleHover(_ gesture: UIHoverGestureRecognizer) {
        let location = gesture.location(in: self)
        
        switch gesture.state {
        case .began, .changed:
            showTooltipIfNeeded(at: location)
        case .ended, .cancelled:
            hideTooltip()
        default:
            break
        }
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        showTooltipIfNeeded(at: location)
    }
    
    private func showTooltipIfNeeded(at location: CGPoint) {
        guard let config = configuration else { return }
        
        let barIndex = getBarIndex(at: location)
        
        if barIndex != hoveredBarIndex {
            hoveredBarIndex = barIndex
            setNeedsDisplay()
        }
        
        guard let index = barIndex, index < config.data.count else {
            hideTooltip()
            return
        }
        
        showTooltip(for: index, at: location)
    }
    
    private func getBarIndex(at point: CGPoint) -> Int? {
        guard let config = configuration else { return nil }
        
        let y = point.y - topPadding
        let index = Int(y / (barHeight + barSpacing))
        
        if index >= 0 && index < config.data.count {
            let barY = topPadding + CGFloat(index) * (barHeight + barSpacing)
            if point.y >= barY && point.y <= barY + barHeight && point.x >= leftPadding {
                return index
            }
        }
        
        return nil
    }
    
    private func showTooltip(for barIndex: Int, at location: CGPoint) {
        guard let config = configuration else { return }
        let barData = config.data[barIndex]
        
        if tooltipView == nil {
            tooltipView = StackedBarTooltipNode()
            if let window = self.window {
                window.addSubnode(tooltipView!)
            } else {
                addSubnode(tooltipView!)
            }
        }
        
        tooltipView?.configure(label: barData.label, categories: config.categories, values: barData.values)
        let tooltipSize = CGSize(width: 220, height: config.categories.count * 23 + 50)
        let convertedLocation = convert(location, to: window ?? self)
        
        var tooltipX = convertedLocation.x + 15
        var tooltipY = convertedLocation.y - tooltipSize.height / 2
        
        if let window = window {
            if tooltipX + tooltipSize.width > window.bounds.width - 20 {
                tooltipX = convertedLocation.x - tooltipSize.width - 15
            }
            if tooltipY < 20 {
                tooltipY = 20
            } else if tooltipY + tooltipSize.height > window.bounds.height - 20 {
                tooltipY = window.bounds.height - tooltipSize.height - 20
            }
            
            if 0 > tooltipX {
                tooltipX = 0
            }
        }
        
        print(CGRect(x: tooltipX, y: tooltipY, width: 220, height: tooltipSize.height))

        tooltipView?.frame = CGRect(x: tooltipX, y: tooltipY, width: 220, height: tooltipSize.height)
        tooltipView?.alpha = 1.0
    }
    
    private func hideTooltip() {
        hoveredBarIndex = nil
        setNeedsDisplay()
        
        UIView.animate(withDuration: 0.2) {
            self.tooltipView?.alpha = 0
        } completion: { _ in
            self.tooltipView?.removeFromSupernode()
            self.tooltipView = nil
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let config = configuration else { return }
        
        drawGridLines(in: rect, maxValue: config.maxTotal)
        drawXAxisLabels(in: rect, maxValue: config.maxTotal)
        drawBars(in: rect, config: config)
        drawYAxisLabel(in: rect)
    }
    
    private func drawYAxisLabel(in rect: CGRect) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 11, weight: .medium),
            .foregroundColor: UIColor.secondaryLabel
        ]
        
        let label = "Message count"
        
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        
        let labelSize = (label as NSString).size(withAttributes: attributes)
        let x: CGFloat = 15
        let y = rect.height / 2 + labelSize.width / 2
        
        context?.translateBy(x: x, y: y)
        context?.rotate(by: -.pi / 2)
        
        (label as NSString).draw(at: .zero, withAttributes: attributes)
        
        context?.restoreGState()
    }
    
    private func drawGridLines(in rect: CGRect, maxValue: Double) {
        let chartWidth = rect.width - leftPadding - rightPadding
        let gridPath = UIBezierPath()
        UIColor.separator.withAlphaComponent(0.2).setStroke()
        
        let step = 50.0
        let steps = Int(ceil(maxValue / step))
        
        for i in 0...steps {
            let value = Double(i) * step
            let x = leftPadding + (chartWidth * CGFloat(value / maxValue))
            
            gridPath.move(to: CGPoint(x: x, y: topPadding))
            gridPath.addLine(to: CGPoint(x: x, y: rect.height))
        }
        
        gridPath.lineWidth = 1.0
        gridPath.stroke()
    }
    
    private func drawXAxisLabels(in rect: CGRect, maxValue: Double) {
        let chartWidth = rect.width - leftPadding - rightPadding
        let step = 50.0
        let steps = Int(ceil(maxValue / step))
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: UIColor.secondaryLabel
        ]
        
        for i in 0...steps {
            let value = Int(Double(i) * step)
            let label = "\(value)"
            let x = leftPadding + (chartWidth * CGFloat(Double(i) * step / maxValue))
            
            let size = (label as NSString).size(withAttributes: attributes)
            let point = CGPoint(x: x - size.width / 2, y: 0)
            (label as NSString).draw(at: point, withAttributes: attributes)
        }
    }
    
    private func drawBars(in rect: CGRect, config: StackedBarChartConfiguration) {
        let chartWidth = rect.width - leftPadding - rightPadding
        let maxValue = config.maxTotal
        
        let labelAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 11),
            .foregroundColor: UIColor.label
        ]
        
        for (index, barData) in config.data.enumerated() {
            let y = topPadding + CGFloat(index) * (barHeight + barSpacing)
            let isHovered = hoveredBarIndex == index
            
            if isHovered {
                let backgroundRect = CGRect(x: 0, y: y - 2, width: rect.width, height: barHeight + 4)
                let backgroundPath = UIBezierPath(rect: backgroundRect)
                UIColor.systemGray6.setFill()
                backgroundPath.fill()
            }
            
            let labelSize = (barData.label as NSString).size(withAttributes: labelAttributes)
            let labelPoint = CGPoint(x: leftPadding - labelSize.width - 10, y: y + (barHeight - labelSize.height) / 2)
            (barData.label as NSString).draw(at: labelPoint, withAttributes: labelAttributes)

            var currentX = leftPadding
            
            for (categoryIndex, value) in barData.values.enumerated() {
                guard value > 0, categoryIndex < config.categories.count else { continue }
                
                let segmentWidth = chartWidth * CGFloat(value / maxValue)
                let segmentRect = CGRect(x: currentX, y: y, width: segmentWidth, height: barHeight)
                
                let path = UIBezierPath(rect: segmentRect)
                
                var color = config.categories[categoryIndex].color
                if isHovered {
                    color = color.withAlphaComponent(0.85)
                }
                
                color.setFill()
                path.fill()
                
                currentX += segmentWidth
            }
        }
    }
}
