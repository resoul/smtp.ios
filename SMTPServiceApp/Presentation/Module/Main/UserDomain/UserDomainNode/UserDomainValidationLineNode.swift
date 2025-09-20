import AsyncDisplayKit
import FontManager

final class UserDomainValidationLineNode: DisplayNode {
    private let headline: String
    private let contentNode: ASDisplayNode?
    private var onSettingsButtonPressed: (() -> Void)?
    private lazy var validationText = ASTextNode()
    private lazy var statusImageNode = VerifiedMarkNode()
    private lazy var settingsButton: ASButtonNode = {
        let btn = ASButtonNode()
        btn.setImage(UIImage(named: "settings"), for: .normal)
        btn.style.height = ASDimension(unit: .points, value: 24)
        btn.style.width = ASDimension(unit: .points, value: 24)
        return btn
    }()
    
    // MARK: - Expansion state
    private var isExpanded: Bool = false // Hide contentNode by default

    init(
        headline: String,
        isValid: Bool,
        contentNode: (() -> ASDisplayNode)? = nil,
        onSettingsButtonPressed: (() -> Void)? = nil
    ) {
        self.headline = headline
        self.contentNode = contentNode?()
        self.onSettingsButtonPressed = onSettingsButtonPressed
        super.init()
        automaticallyManagesSubnodes = true
        settingsButton.addTarget(self, action: #selector(buttonPressed(_:)), forControlEvents: .touchUpInside)
        statusImageNode.setValidated(isValid)
        validationText.attributedText = NSAttributedString(
            string: headline,
            attributes: [
                .font: UIFont.poppinsWithFallback(.regular, size: 17, fallback: .regular),
                .foregroundColor: themeManager.currentTheme.mainPresentationData.mainTextColor
            ]
        )
        if let contentNode = self.contentNode {
            addSubnode(contentNode)
        }
    }
    
    @objc private func buttonPressed(_ sender: Any) {
        onSettingsButtonPressed?()
        isExpanded.toggle()
        transitionLayout(withAnimation: true, shouldMeasureAsync: false, measurementCompletion: nil)
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
        
        if let contentNode = contentNode, isExpanded {
            let wrapper = ASStackLayoutSpec.vertical()
            wrapper.children = [hLayout, contentNode]
            return ASInsetLayoutSpec(
                insets: .init(top: 0, left: 0, bottom: 0, right: 8),
                child: wrapper
            )
        } else {
            return ASInsetLayoutSpec(
                insets: .init(top: 0, left: 0, bottom: 0, right: 8),
                child: hLayout
            )
        }
    }
    
    // Fade in/out animation for smoother transition
    override func animateLayoutTransition(_ context: ASContextTransitioning) {
        if let contentNode = contentNode {
            if isExpanded {
                // Appearing
                if let node = context.insertedSubnodes().first(where: { $0 === contentNode }) {
                    node.alpha = 0.0
                    UIView.animate(withDuration: 0.25, animations: {
                        node.alpha = 1.0
                    }, completion: { _ in
                        context.completeTransition(true)
                    })
                } else {
                    context.completeTransition(true)
                }
            } else {
                // Disappearing
                if let node = context.removedSubnodes().first(where: { $0 === contentNode }) {
                    UIView.animate(withDuration: 0.25, animations: {
                        node.alpha = 0.0
                    }, completion: { _ in
                        context.completeTransition(true)
                    })
                } else {
                    context.completeTransition(true)
                }
            }
        } else {
            context.completeTransition(true)
        }
    }
}
