import AsyncDisplayKit
import FontManager

final class AuthTextButtonNode: ASButtonNode {
    init(
        text: String,
        textColor: UIColor = .white,
        textSize: CGFloat = 14,
        backgroundColor: UIColor = .clear,
        isUnderlined: Bool = true,
        alignment: NSTextAlignment = .center
    ) {
        super.init()
        automaticallyManagesSubnodes = true
        contentEdgeInsets = .zero
        self.backgroundColor = backgroundColor
        
        var attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.poppinsWithFallback(.regular, size: textSize),
            .foregroundColor: textColor
        ]
        
        if isUnderlined {
            attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        attributes[.paragraphStyle] = paragraphStyle

        setAttributedTitle(
            NSAttributedString(string: text, attributes: attributes),
            for: .normal
        )
    }

    func updateTextColor(_ color: UIColor) {
        guard let current = attributedTitle(for: .normal)?.mutableCopy() as? NSMutableAttributedString else { return }
        let fullRange = NSRange(location: 0, length: current.length)
        current.addAttribute(.foregroundColor, value: color, range: fullRange)
        setAttributedTitle(current, for: .normal)
    }
}
