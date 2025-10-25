import AsyncDisplayKit

final class PreviewIntroNode: ASDisplayNode {
    private let headlineTextNode = ASTextNode()
    private let backgroundImageNode = ASImageNode()
    private let descriptionTextNode = ASTextNode()
    private var currentPreview: PreviewIntro?

    func configure(with preview: PreviewIntro) {
        currentPreview = preview
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .justified

        headlineTextNode.attributedText = NSAttributedString(
            string: preview.headline,
            attributes: [
                .font: preview.headlineFont,
                .foregroundColor: preview.headlineColor
            ]
        )

        descriptionTextNode.attributedText = NSAttributedString(
            string: preview.description,
            attributes: [
                .font: preview.descriptionFont,
                .foregroundColor: preview.descriptionColor,
                .paragraphStyle: paragraph
            ]
        )

        backgroundColor = preview.backgroundColor
        backgroundImageNode.image = preview.image
        applyTransition(style: preview.transitionStyle, duration: preview.animationDuration)
    }

    private func applyTransition(style: PreviewTransitionStyle, duration: TimeInterval) {
        switch style {
        case .fade:
            animateFade(duration: duration)
        case .slide:
            animateSlide(duration: duration)
        case .scale:
            animateScale(duration: duration)
        case .slideFromBottom:
            animateSlideFromBottom(duration: duration)
        case .custom(let customAnimation):
            customAnimation(self) { [weak self] in
                self?.resetNodeStates()
            }
        }
    }

    private func animateFade(duration: TimeInterval) {
        headlineTextNode.alpha = 0
        backgroundImageNode.alpha = 0
        descriptionTextNode.alpha = 0

        UIView.animate(
            withDuration: duration,
            delay: 0.1,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut
        ) {
            self.headlineTextNode.alpha = 1
        }

        UIView.animate(
            withDuration: duration,
            delay: 0.3,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut
        ) {
            self.backgroundImageNode.alpha = 1
        }

        UIView.animate(
            withDuration: duration,
            delay: 0.5,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut
        ) {
            self.descriptionTextNode.alpha = 1
        }
    }

    private func animateSlide(duration: TimeInterval) {
        headlineTextNode.alpha = 0
        backgroundImageNode.alpha = 0
        descriptionTextNode.alpha = 0

        headlineTextNode.view.transform = CGAffineTransform(translationX: -50, y: 0)
        backgroundImageNode.view.transform = CGAffineTransform(translationX: 50, y: 0)
        descriptionTextNode.view.transform = CGAffineTransform(translationX: -50, y: 0)

        UIView.animate(
            withDuration: duration,
            delay: 0.1,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut
        ) {
            self.headlineTextNode.alpha = 1
            self.headlineTextNode.view.transform = .identity
        }

        UIView.animate(
            withDuration: duration,
            delay: 0.25,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut
        ) {
            self.backgroundImageNode.alpha = 1
            self.backgroundImageNode.view.transform = .identity
        }

        UIView.animate(
            withDuration: duration,
            delay: 0.4,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut
        ) {
            self.descriptionTextNode.alpha = 1
            self.descriptionTextNode.view.transform = .identity
        }
    }

    private func animateScale(duration: TimeInterval) {
        headlineTextNode.alpha = 0
        backgroundImageNode.alpha = 0
        descriptionTextNode.alpha = 0

        headlineTextNode.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        backgroundImageNode.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        descriptionTextNode.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

        UIView.animate(
            withDuration: duration,
            delay: 0.1,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.8,
            options: .curveEaseOut
        ) {
            self.headlineTextNode.alpha = 1
            self.headlineTextNode.view.transform = .identity
        }

        UIView.animate(
            withDuration: duration,
            delay: 0.25,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.8,
            options: .curveEaseOut
        ) {
            self.backgroundImageNode.alpha = 1
            self.backgroundImageNode.view.transform = .identity
        }

        UIView.animate(
            withDuration: duration,
            delay: 0.4,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.8,
            options: .curveEaseOut
        ) {
            self.descriptionTextNode.alpha = 1
            self.descriptionTextNode.view.transform = .identity
        }
    }

    private func animateSlideFromBottom(duration: TimeInterval) {
        headlineTextNode.alpha = 0
        backgroundImageNode.alpha = 0
        descriptionTextNode.alpha = 0

        headlineTextNode.view.transform = CGAffineTransform(translationX: 0, y: 30)
        backgroundImageNode.view.transform = CGAffineTransform(translationX: 0, y: 50)
        descriptionTextNode.view.transform = CGAffineTransform(translationX: 0, y: 30)

        UIView.animate(
            withDuration: duration,
            delay: 0.1,
            usingSpringWithDamping: 0.75,
            initialSpringVelocity: 0.6,
            options: .curveEaseOut
        ) {
            self.headlineTextNode.alpha = 1
            self.headlineTextNode.view.transform = .identity
        }

        UIView.animate(
            withDuration: duration,
            delay: 0.25,
            usingSpringWithDamping: 0.75,
            initialSpringVelocity: 0.6,
            options: .curveEaseOut
        ) {
            self.backgroundImageNode.alpha = 1
            self.backgroundImageNode.view.transform = .identity
        }

        UIView.animate(
            withDuration: duration,
            delay: 0.4,
            usingSpringWithDamping: 0.75,
            initialSpringVelocity: 0.6,
            options: .curveEaseOut
        ) {
            self.descriptionTextNode.alpha = 1
            self.descriptionTextNode.view.transform = .identity
        }
    }

    private func resetNodeStates() {
        headlineTextNode.alpha = 1
        backgroundImageNode.alpha = 1
        descriptionTextNode.alpha = 1
        headlineTextNode.view.transform = .identity
        backgroundImageNode.view.transform = .identity
        descriptionTextNode.view.transform = .identity
    }

    private func animateAppearance() {
        UIView.animate(withDuration: 0.6, delay: 0.1, options: .curveEaseInOut) {
            self.headlineTextNode.alpha = 1
        }

        UIView.animate(withDuration: 0.6, delay: 0.3, options: .curveEaseInOut) {
            self.backgroundImageNode.alpha = 1
        }

        UIView.animate(withDuration: 0.6, delay: 0.5, options: .curveEaseInOut) {
            self.descriptionTextNode.alpha = 1
        }
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let top = ASInsetLayoutSpec(
            insets: UIEdgeInsets(top: 0, left: 16, bottom: 5, right: 16),
            child: headlineTextNode
        )

        let center = ASCenterLayoutSpec(
            centeringOptions: .XY,
            sizingOptions: [],
            child: backgroundImageNode
        )

        let bottom = ASInsetLayoutSpec(
            insets: UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16),
            child: descriptionTextNode
        )

        return ASStackLayoutSpec(
            direction: .vertical,
            spacing: 20,
            justifyContent: .center,
            alignItems: .center,
            children: [top, center, bottom]
        )
    }

    private func setupAccessibility() {
        headlineTextNode.isAccessibilityElement = true
        headlineTextNode.accessibilityTraits = .header

        descriptionTextNode.isAccessibilityElement = true
        descriptionTextNode.accessibilityTraits = .staticText

        backgroundImageNode.isAccessibilityElement = true
        backgroundImageNode.accessibilityTraits = .image
    }

    private func setupUI() {
        automaticallyManagesSubnodes = true
        headlineTextNode.alpha = 0
        descriptionTextNode.alpha = 0
        backgroundImageNode.contentMode = .scaleAspectFit
        backgroundImageNode.alpha = 0
    }

    override init() {
        super.init()
        setupUI()
        setupAccessibility()
    }
}
