import AsyncDisplayKit

final class ButtonPrimaryNode: ASButtonNode {
    init(
        text: String,
        textColor: UIColor = UIColor.hex("FFFFFF"),
        textSize: CGFloat = 16,
        backgroundColor: UIColor = UIColor.hex("3F51B5")
    ) {
        super.init()
        automaticallyManagesSubnodes = true
        self.backgroundColor = backgroundColor
        setTitle(
            text,
            with: UIFont.poppinsWithFallback(.medium, size: textSize, fallback: .medium),
            with: textColor,
            for: .normal
        )
    }
}
