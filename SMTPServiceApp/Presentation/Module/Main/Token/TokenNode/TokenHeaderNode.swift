import AsyncDisplayKit

final class TokenHeaderNode: ASCellNode {
    private let titleNode = ASTextNode()
    private let addButtonNode = CreateButtonNode(text: "Generate New Token")
    var onGenerateToken: (() -> Void)?
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        selectionStyle = .none
        setupNodes()
    }

   private func setupNodes() {
       titleNode.attributedText = NSAttributedString(string: "SMTP Tokens", attributes: [
           NSAttributedString.Key.font: UIFont.poppinsWithFallback(.bold, size: 20),
           NSAttributedString.Key.foregroundColor: UIColor.label
       ])
       addButtonNode.onTap = { [weak self] in
           self?.onGenerateToken?()
       }
   }

   override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
       let headerStack = ASStackLayoutSpec(
           direction: .vertical,
           spacing: 16,
           justifyContent: .start,
           alignItems: .start,
           children: [titleNode, addButtonNode]
       )

       addButtonNode.style.height = ASDimension(unit: .points, value: 60)
       addButtonNode.style.minWidth = ASDimension(unit: .points, value: 180)

       return ASInsetLayoutSpec(
           insets: UIEdgeInsets(top: 24, left: 16, bottom: 16, right: 16),
           child: headerStack
       )
   }
}
