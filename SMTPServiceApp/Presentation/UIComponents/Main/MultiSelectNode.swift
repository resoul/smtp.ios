import AsyncDisplayKit

final class StatusTagNode: ASDisplayNode {
    private let titleNode = ASTextNode()
    private let removeButton = ASButtonNode()
    
    var onRemove: (() -> Void)?
    
    init(status: EmailStatus) {
        super.init()
        automaticallyManagesSubnodes = true
        
        backgroundColor = status.color.withAlphaComponent(0.2)
        cornerRadius = 16
        borderWidth = 1
        borderColor = status.color.cgColor
        
        titleNode.attributedText = NSAttributedString(
            string: status.title,
            attributes: [
                .font: UIFont.systemFont(ofSize: 14, weight: .medium),
                .foregroundColor: status.color
            ]
        )
        
        removeButton.setTitle("×", with: UIFont.systemFont(ofSize: 18, weight: .bold), with: status.color, for: .normal)
        removeButton.addTarget(self, action: #selector(removeTapped), forControlEvents: .touchUpInside)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.horizontal()
        stack.spacing = 8
        stack.alignItems = .center
        stack.children = [titleNode, removeButton]
        
        let inset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 8), child: stack)
        
        return inset
    }
    
    @objc private func removeTapped() {
        onRemove?()
    }
}

final class StatusCellNode: ASCellNode {
    private let colorNode = ASDisplayNode()
    private let titleNode = ASTextNode()
    private let checkmarkNode = ASImageNode()
    
    init(status: EmailStatus, isSelected: Bool) {
        super.init()
        automaticallyManagesSubnodes = true
        
        colorNode.backgroundColor = status.color
        colorNode.style.preferredSize = CGSize(width: 8, height: 8)
        colorNode.cornerRadius = 4
        
        titleNode.attributedText = NSAttributedString(
            string: status.title,
            attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.label]
        )
        
        checkmarkNode.image = UIImage(systemName: "checkmark")
        checkmarkNode.tintColor = .systemBlue
        checkmarkNode.style.preferredSize = CGSize(width: 20, height: 20)
        checkmarkNode.isHidden = !isSelected
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let horizontal = ASStackLayoutSpec.horizontal()
        horizontal.spacing = 12
        horizontal.alignItems = .center
        horizontal.justifyContent = .spaceBetween
        horizontal.children = [colorNode, titleNode, checkmarkNode]
        
        let inset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16), child: horizontal)
        return inset
    }
}

final class MultiSelectStatusNode: ASDisplayNode {
    private let headerNode = ASTextNode()
    private let toggleButton = ASButtonNode()
    private let tagsStack = ASStackLayoutSpec.vertical()
    private let tableNode = ASTableNode()
    
    private var allStatuses = EmailStatus.allStatuses
    private var selectedStatuses: [EmailStatus] = []
    private var isDropdownVisible = false
    
    var onSelectionChanged: (([EmailStatus]) -> Void)?
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        
        backgroundColor = .systemBackground
        cornerRadius = 8
        borderWidth = 1
        borderColor = UIColor.systemGray4.cgColor
        
        headerNode.attributedText = NSAttributedString(
            string: "Select Statuses",
            attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .medium),
                         .foregroundColor: UIColor.label]
        )
        
        toggleButton.setTitle("▼", with: UIFont.systemFont(ofSize: 14), with: .systemBlue, for: .normal)
        toggleButton.addTarget(self, action: #selector(toggleDropdown), forControlEvents: .touchUpInside)
        
        tableNode.dataSource = self
        tableNode.delegate = self
        tableNode.style.height = ASDimension(unit: .points, value: 0) // скрыт
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let header = ASStackLayoutSpec.horizontal()
        header.justifyContent = .spaceBetween
        header.alignItems = .center
        header.children = [headerNode, toggleButton]
        
        var children: [ASLayoutElement] = [header]
        
        if !selectedStatuses.isEmpty {
            let tagNodes = selectedStatuses.map { status -> ASLayoutElement in
                let tag = StatusTagNode(status: status)
                tag.onRemove = { [weak self] in
                    self?.removeStatus(status)
                }
                return tag
            }
            let tagStack = ASStackLayoutSpec.vertical()
            tagStack.spacing = 8
            tagStack.children = tagNodes
            children.append(tagStack)
        }
        
        if isDropdownVisible {
            children.append(tableNode)
        }
        
        let vertical = ASStackLayoutSpec.vertical()
        vertical.spacing = 12
        vertical.children = children
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12), child: vertical)
    }
    
    @objc private func toggleDropdown() {
        isDropdownVisible.toggle()
        toggleButton.setTitle(isDropdownVisible ? "▲" : "▼", with: UIFont.systemFont(ofSize: 14), with: .systemBlue, for: .normal)
        transitionLayout(withAnimation: true, shouldMeasureAsync: false)
    }
    
    private func removeStatus(_ status: EmailStatus) {
        selectedStatuses.removeAll { $0.id == status.id }
        onSelectionChanged?(selectedStatuses)
        tableNode.reloadData()
        setNeedsLayout()
    }
}

extension MultiSelectStatusNode: ASTableDataSource, ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return allStatuses.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let status = allStatuses[indexPath.row]
        let isSelected = selectedStatuses.contains { $0.id == status.id }
        return StatusCellNode(status: status, isSelected: isSelected)
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        let status = allStatuses[indexPath.row]
        
        if let index = selectedStatuses.firstIndex(where: { $0.id == status.id }) {
            selectedStatuses.remove(at: index)
        } else {
            selectedStatuses.append(status)
        }
        
        onSelectionChanged?(selectedStatuses)
        tableNode.reloadData()
        setNeedsLayout()
    }
}

//class ExampleViewController: ASDKViewController<ASDisplayNode> {
//    private let multiSelectNode = MultiSelectStatusNode()
//
//    override init() {
//        super.init(node: ASDisplayNode())
//        node.backgroundColor = .systemBackground
//        node.addSubnode(multiSelectNode)
//
//        multiSelectNode.onSelectionChanged = { statuses in
//            print("Selected: \(statuses.map { $0.title })")
//        }
//    }
//
//    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        multiSelectNode.frame = CGRect(x: 16, y: view.safeAreaInsets.top + 20, width: view.bounds.width - 32, height: 400)
//    }
//}
