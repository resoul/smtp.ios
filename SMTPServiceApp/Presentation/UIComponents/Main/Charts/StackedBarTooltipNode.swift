import AsyncDisplayKit

final class StackedBarTooltipNode: DisplayNode {
    private let headerNode = ASTextNode()
    private let stackNode = ASStackLayoutSpec()
    
    private var categoryRows: [ASLayoutSpec] = []
    
    override func setupUI() {
        backgroundColor = .systemBackground
        cornerRadius = 8
        shadowColor = UIColor.black.cgColor
        shadowOpacity = 0.15
        shadowOffset = CGSize(width: 0, height: 2)
        shadowRadius = 8
    }
    
    func configure(label: String, categories: [StackedBarCategory], values: [Double]) {
        headerNode.attributedText = NSAttributedString(
            string: label,
            attributes: [
                .font: UIFont.systemFont(ofSize: 12, weight: .medium),
                .foregroundColor: UIColor.label
            ]
        )
        
        categoryRows = []
        for (index, category) in categories.enumerated() {
            guard index < values.count else { continue }
            
            let circle = ASDisplayNode()
            circle.backgroundColor = category.color
            circle.style.preferredSize = CGSize(width: 12, height: 12)
            circle.cornerRadius = 6
            
            let nameNode = ASTextNode()
            nameNode.attributedText = NSAttributedString(
                string: "\(category.name):",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 12),
                    .foregroundColor: UIColor.label
                ]
            )
            
            let valueNode = ASTextNode()
            valueNode.attributedText = NSAttributedString(
                string: "\(Int(values[index]))",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                    .foregroundColor: UIColor.label
                ]
            )
            valueNode.style.flexShrink = 0
            valueNode.style.alignSelf = .end
            
            let row = ASStackLayoutSpec.horizontal()
            row.spacing = 8
            row.alignItems = .center
            row.children = [circle, nameNode, valueNode]
            
            categoryRows.append(row)
        }
        
        setNeedsLayout()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.vertical()
        stack.spacing = 12
        
        var children: [ASLayoutElement] = [headerNode]
        children.append(contentsOf: categoryRows)
        stack.children = children
        
        let inset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return ASInsetLayoutSpec(insets: inset, child: stack)
    }
}

final class StackedBarTooltipView: UIView {
    
    private let headerLabel = UILabel()
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 8
        
        headerLabel.font = .systemFont(ofSize: 12, weight: .medium)
        headerLabel.textColor = .label
        headerLabel.numberOfLines = 0
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(headerLabel)
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            stackView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    func configure(label: String, categories: [StackedBarCategory], values: [Double]) {
        headerLabel.text = label
        
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, category) in categories.enumerated() {
            guard index < values.count else { continue }
            
            let container = UIStackView()
            container.axis = .horizontal
            container.spacing = 8
            container.alignment = .center
            
            let circle = UIView()
            circle.backgroundColor = category.color
            circle.layer.cornerRadius = 6
            circle.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                circle.widthAnchor.constraint(equalToConstant: 12),
                circle.heightAnchor.constraint(equalToConstant: 12)
            ])
            
            let nameLabel = UILabel()
            nameLabel.text = "\(category.name):"
            nameLabel.font = .systemFont(ofSize: 12)
            nameLabel.textColor = .label
            nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
            
            let valueLabel = UILabel()
            valueLabel.text = "\(Int(values[index]))"
            valueLabel.font = .systemFont(ofSize: 12, weight: .semibold)
            valueLabel.textColor = .label
            valueLabel.textAlignment = .right
            valueLabel.setContentHuggingPriority(.required, for: .horizontal)
            
            container.addArrangedSubview(circle)
            container.addArrangedSubview(nameLabel)
            container.addArrangedSubview(valueLabel)
            
            stackView.addArrangedSubview(container)
        }
    }
}
