import AsyncDisplayKit
import FontManager

final class UserDomainValidationLineNode: DisplayNode {
    private let headline: String
    private let contentNode: ASDisplayNode?
    private lazy var validationText = ASTextNode()
    private lazy var statusImageNode = VerifiedMarkNode()
    private lazy var settingsButton: ASButtonNode = {
        let btn = ASButtonNode()
        btn.setImage(UIImage(named: "settings"), for: .normal)
        btn.style.height = ASDimension(unit: .points, value: 24)
        btn.style.width = ASDimension(unit: .points, value: 24)

        return btn
    }()

    init(headline: String, isValid: Bool, contentNode: (() -> ASDisplayNode)? = nil) {
        self.headline = headline
        self.contentNode = contentNode?()
        super.init()
        automaticallyManagesSubnodes = true
        statusImageNode.setValidated(isValid)
        validationText.attributedText = NSAttributedString(
            string: headline,
            attributes: [
                .font: UIFont.poppinsWithFallback(.regular, size: 17, fallback: .regular),
                .foregroundColor: themeManager.currentTheme.mainPresentationData.mainTextColor
            ]
        )
        guard let contentNode = contentNode?() else { return }
        addSubnode(contentNode)
    }
    
    override func applyTheme(_ theme: any Theme) {
        validationText.attributedText = NSAttributedString(
            string: headline,
            attributes: [
                .font: UIFont.poppinsWithFallback(.regular, size: 17, fallback: .regular),
                .foregroundColor: theme.mainPresentationData.mainTextColor
            ]
        )
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        validationText.style.flexShrink = 1.0
        let stackLayout = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 11,
            justifyContent: .start,
            alignItems: .center,
            children: [statusImageNode, validationText]
        )
        stackLayout.style.flexShrink = 1.0
        stackLayout.style.maxWidth = ASDimension(unit: .fraction, value: 1.0)
        
        let hLayout = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 5,
            justifyContent: .spaceBetween,
            alignItems: .center,
            children: [stackLayout, settingsButton]
        )
        
        guard let contentNode = contentNode else {
            return ASInsetLayoutSpec(
                insets: .init(top: 0, left: 0, bottom: 0, right: 8),
                child: hLayout
            )
        }
        
        let wrapper = ASStackLayoutSpec.vertical()
        wrapper.children = [hLayout, contentNode]

        return ASInsetLayoutSpec(
            insets: .init(top: 0, left: 0, bottom: 0, right: 8),
            child: wrapper
        )
    }
}
