import AsyncDisplayKit

final class LabelNode: ASTextNode {
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
                .font: UIFont(name: "Poppins-Bold", size: textSize) ?? UIFont.systemFont(ofSize: textSize),
                .foregroundColor: UIColor.hex("444444")
            ]
        )
    }
}
