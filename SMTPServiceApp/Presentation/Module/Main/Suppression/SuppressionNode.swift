import AsyncDisplayKit

final class SuppressionNode: ASCellNode {
    private let containerNode = ASDisplayNode()
    private let nameNode = ASTextNode()
    private let valueNode = ASTextNode()
    private let statusNode = ASTextNode()
    private let createdNode = ASTextNode()

    private let suppression: Suppression

   init(suppression: Suppression) {
       self.suppression = suppression
       super.init()
       selectionStyle = .none
       automaticallyManagesSubnodes = true
       setupNodes()
   }

   private func setupNodes() {
       nameNode.attributedText = NSAttributedString(
            string: suppression.email,
           attributes: [
               NSAttributedString.Key.font: UIFont.poppinsWithFallback(.medium, size: 16),
               NSAttributedString.Key.foregroundColor: UIColor.label
           ]
       )
       
       valueNode.attributedText = NSAttributedString(
        string: "Domain: \(suppression.domainName)",
           attributes: [
               NSAttributedString.Key.font: UIFont.poppinsWithFallback(.regular, size: 12),
               NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel
           ]
       )

       statusNode.attributedText = NSAttributedString(
        string: suppression.type.rawValue,
           attributes: [
               NSAttributedString.Key.font: UIFont.poppinsWithFallback(.medium, size: 12),
               NSAttributedString.Key.foregroundColor: UIColor.green
           ]
       )

       createdNode.attributedText = NSAttributedString(
        string: suppression.createdAt.formattedDateString(timeStyle: .medium),
           attributes: [
               NSAttributedString.Key.font: UIFont.poppinsWithFallback(.regular, size: 12),
               NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel
           ]
       )
   }

   override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
       let topRowStack = ASStackLayoutSpec(
           direction: .horizontal,
           spacing: 8,
           justifyContent: .spaceBetween,
           alignItems: .center,
           children: [nameNode]
       )

       let valueStack = ASStackLayoutSpec(
           direction: .horizontal,
           spacing: 8,
           justifyContent: .spaceBetween,
           alignItems: .center,
           children: [valueNode]
       )

       let bottomRowStack = ASStackLayoutSpec(
           direction: .horizontal,
           spacing: 8,
           justifyContent: .spaceBetween,
           alignItems: .center,
           children: [statusNode, createdNode]
       )

       let mainStack = ASStackLayoutSpec(
           direction: .vertical,
           spacing: 6,
           justifyContent: .start,
           alignItems: .stretch,
           children: [topRowStack, valueStack, bottomRowStack]
       )

       let containerSpec = ASBackgroundLayoutSpec(child: mainStack, background: containerNode)

       return ASInsetLayoutSpec(
           insets: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16),
           child: containerSpec
       )
   }
}
