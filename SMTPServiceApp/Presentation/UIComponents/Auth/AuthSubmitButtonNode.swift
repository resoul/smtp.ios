import AsyncDisplayKit
import FontManager

final class AuthSubmitButtonNode: ASButtonNode {
    init(
        text: String,
        textColor: UIColor = .white,
        textSize: CGFloat = 16,
        backgroundColor: UIColor = UIColor.hex("F8555A")
    ) {
        super.init()
        automaticallyManagesSubnodes = true
        self.backgroundColor = backgroundColor
        setTitle(
            text,
            with: UIFont.poppinsWithFallback(.bold, size: textSize, fallback: .bold),
            with: textColor,
            for: .normal
        )
        style.height = ASDimension(unit: .points, value: 50)
    }
    
    func setButtonEnabled(_ isEnabled: Bool) {
        self.isEnabled = isEnabled
        alpha = isEnabled ? 1.0 : 0.6
    }
}
