import AsyncDisplayKit

final class CreateButtonNode: ASButtonNode {
    private let plusContainerNode = ASDisplayNode()
    private let plusTextNode = ASTextNode()
    private let titleTextNode = ASTextNode()
    private let buttonNode = ASButtonNode()
    
    var onTap: (() -> Void)?
    
    init(text: String) {
        super.init()
        
        automaticallyManagesSubnodes = true
        
        setupButton()
        setupPlusContainer()
        setupPlusText()
        setupTitleText(text: text)
    }
    
    private func setupButton() {
        backgroundColor = UIColor.hex("3F51B5")
        isUserInteractionEnabled = true
        addTarget(self, action: #selector(touchDown), forControlEvents: .touchDown)
        addTarget(self, action: #selector(touchUp), forControlEvents: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    private func setupPlusContainer() {
        plusContainerNode.backgroundColor = UIColor.hex("2A3CA3")
    }
    
    private func setupPlusText() {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.poppinsWithFallback(.medium, size: 24, fallback: .medium),
            .foregroundColor: UIColor.white
        ]
        plusTextNode.attributedText = NSAttributedString(string: "+", attributes: attributes)
    }
    
    private func setupTitleText(text: String) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.poppinsWithFallback(.medium, size: 18, fallback: .medium),
            .foregroundColor: UIColor.white
        ]
        titleTextNode.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let plusCenterSpec = ASCenterLayoutSpec(
            centeringOptions: .XY,
            sizingOptions: [],
            child: plusTextNode
        )

        plusContainerNode.style.width = ASDimension(unit: .points, value: 60)
        plusContainerNode.style.flexGrow = 1.0

        let plusOverlaySpec = ASOverlayLayoutSpec(child: plusContainerNode, overlay: plusCenterSpec)

        let titleInsetSpec = ASInsetLayoutSpec(
            insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20),
            child: titleTextNode
        )
        
        let horizontalStack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 16,
            justifyContent: .start,
            alignItems: .center,
            children: [plusOverlaySpec, titleInsetSpec]
        )
        
        return horizontalStack
    }
    
    override func didLoad() {
        super.didLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
//        animateTap()
        onTap?()
    }
    
    @objc private func touchDown() {
        UIView.animate(withDuration: 0.1) {
            self.view.alpha = 0.8
            self.view.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        }
    }
    
    @objc private func touchUp() {
        UIView.animate(withDuration: 0.1) {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform.identity
        }
    }
    
    private func animateTap() {
        UIView.animate(withDuration: 0.1, animations: {
            self.view.alpha = 0.8
            self.view.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.view.alpha = 1.0
                self.view.transform = CGAffineTransform.identity
            }
        }
    }
}
