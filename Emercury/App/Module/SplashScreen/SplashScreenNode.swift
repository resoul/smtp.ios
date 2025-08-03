import AsyncDisplayKit

final class SplashScreenNode: ASDisplayNode {
    
    private let splashScreenItem: SplashScreenItem
    
    private let titleNode = ASTextNode()
    private let imageNode = ASImageNode()
    private let descriptionNode = ASTextNode()
    
    init(item: SplashScreenItem) {
        splashScreenItem = item
        super.init()
        automaticallyManagesSubnodes = true

        setupUI()

        layoutSpecBlock = { [weak self] _, _ in
            return self?.layout() ?? ASLayoutSpec()
        }
    }
    
    private func setupUI() {
        titleNode.attributedText = NSAttributedString(
            string: splashScreenItem.title,
            attributes: [
                .font: UIFont(name: "Poppins-Bold", size: 28) ?? UIFont.boldSystemFont(ofSize: 28),
                .foregroundColor: UIColor.white
            ]
        )
        titleNode.style.alignSelf = .center
        
        imageNode.image = UIImage(named: splashScreenItem.image)
        imageNode.contentMode = .scaleAspectFit
        imageNode.style.flexShrink = 1
        imageNode.style.flexGrow = 1
        imageNode.style.width = ASDimension(unit: .fraction, value: 1.0)
        imageNode.style.height = ASDimension(unit: .points, value: 200)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        paragraphStyle.hyphenationFactor = 1.0
        
        descriptionNode.attributedText = NSAttributedString(
            string: splashScreenItem.description,
            attributes: [
                .font: UIFont(name: "Poppins-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle
            ]
        )
        descriptionNode.style.alignSelf = .stretch
    }
    
    private func layout() -> ASLayoutSpec {
        let titleInset = ASInsetLayoutSpec(
            insets: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24),
            child: titleNode
        )
        let ratioImage = ASRatioLayoutSpec(ratio: 9.0 / 16.0, child: imageNode)
        let descriptionInset = ASInsetLayoutSpec(
            insets: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24),
            child: descriptionNode
        )
        
        let verticalStack = ASStackLayoutSpec.vertical()
        verticalStack.spacing = 20
        verticalStack.justifyContent = .center
        verticalStack.alignItems = .stretch
        verticalStack.children = [titleInset, ratioImage, descriptionInset]
        
        let shiftedUp = ASInsetLayoutSpec(
            insets: UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0),
            child: verticalStack
        )

        return ASCenterLayoutSpec(
            centeringOptions: .XY,
            sizingOptions: [],
            child: shiftedUp
        )
    }
}
