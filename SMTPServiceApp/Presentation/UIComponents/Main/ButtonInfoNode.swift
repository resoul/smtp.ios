import AsyncDisplayKit
import FontManager

final class ButtonInfoNode: ASButtonNode {
    init(
        text: String,
        textColor: UIColor = UIColor.hex("3F51B5"),
        textSize: CGFloat = 16,
        backgroundColor: UIColor = UIColor.hex("F2F2F2")
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
