import AsyncDisplayKit

final class AuthLabelNode: ASTextNode {
    init(
        text: String,
        textSize: CGFloat = 16,
        textColor: UIColor = UIColor.hex("444444")
    ) {
        super.init()
        automaticallyManagesSubnodes = true
        attributedText = NSAttributedString(
            string: text,
            attributes: [
                .font: UIFont.poppinsWithFallback(.bold, size: textSize),
                .foregroundColor: textColor
            ]
        )
    }
}
