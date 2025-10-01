import AsyncDisplayKit

final class RequirementNode: ASDisplayNode {
    private let iconNode: ASImageNode
    private let textNode: ASTextNode
    private let text: String
    
    init(text: String) {
        self.text = text
        
        iconNode = ASImageNode()
        iconNode.image = UIImage(systemName: "circle")
        iconNode.tintColor = .systemGray4
        iconNode.style.preferredSize = CGSize(width: 12, height: 12)
        
        textNode = ASTextNode()
        textNode.attributedText = NSAttributedString(
            string: text,
            attributes: [
                .font: UIFont.poppinsWithFallback(.regular, size: 12),
                .foregroundColor: UIColor.systemGray
            ]
        )
        
        super.init()
        automaticallyManagesSubnodes = true
        
        layoutSpecBlock = { [weak self] _, _ in
            return self?.layoutSpec() ?? ASLayoutSpec()
        }
    }
    
    func updateStatus(_ isMet: Bool) {
        let imageName = isMet ? "checkmark.circle.fill" : "circle"
        let color = isMet ? UIColor.systemGreen : UIColor.systemGray4
        let textColor = isMet ? UIColor.systemGreen : UIColor.systemGray
        
        iconNode.image = UIImage(systemName: imageName)
        iconNode.tintColor = color
        
        textNode.attributedText = NSAttributedString(
            string: text,
            attributes: [
                .font: UIFont.poppinsWithFallback(.regular, size: 12),
                .foregroundColor: textColor
            ]
        )
    }
    
    private func layoutSpec() -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.horizontal()
        stack.spacing = 8
        stack.alignItems = .center
        stack.children = [iconNode, textNode]
        
        return stack
    }
}
