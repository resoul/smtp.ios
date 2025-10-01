import AsyncDisplayKit

struct SuppressionFilterData {
}

final class SuppressionFilterNode: ASCellNode {
    var onApplyFilter: ((SuppressionFilterData) -> Void)?
    var onTapFilter: (() -> Void)?
    private let filterButtonNode = ButtonPrimaryNode(text: "Filter")
    
    override init() {
        super.init()
        selectionStyle = .none
        automaticallyManagesSubnodes = true
        setupNodes()
    }
    
    private func setupNodes() {
        filterButtonNode.addTarget(self, action: #selector(handleFilter), forControlEvents: .touchUpInside)
    }

    private func handleApplyFilter(data: SuppressionFilterData) {
        onApplyFilter?(data)
    }
    
    @objc
    private func handleFilter() {
        onTapFilter?()
    }

   override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
       filterButtonNode.style.height = ASDimension(unit: .points, value: 50)
       let layout = ASStackLayoutSpec(
           direction: .vertical,
           spacing: 8,
           justifyContent: .start,
           alignItems: .stretch,
           children: [filterButtonNode]
       )

       return ASInsetLayoutSpec(
           insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
           child: layout
       )
   }
}
