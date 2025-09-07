import AsyncDisplayKit

class AuthNode: DisplayNode {
    lazy var logo: ASImageNode = {
        let img = ASImageNode()
        img.image = UIImage(named: "dark-logo")
        img.contentMode = .scaleAspectFit
        img.style.preferredSize = CGSize(width: UIScreen.main.bounds.width * 0.33, height: 60)

        return img
    }()
    
    lazy var authForm: ASDisplayNode = {
        let form = ASDisplayNode()
        form.style.flexGrow = 1
        form.style.flexShrink = 1
        form.style.alignSelf = .stretch
        form.automaticallyManagesSubnodes = true
        form.backgroundColor = themeManager.currentTheme.authPresentationData.backgroundColor
        
        return form
    }()
    
    lazy var authFormWrapper: ASDisplayNode = {
        let form = ASDisplayNode()
        form.automaticallyManagesSubnodes = true
        form.backgroundColor = themeManager.currentTheme.authPresentationData.formBackgroundColor
        
        return form
    }()
    
    func getAuthFormLayout(elements: [ASLayoutElement]) -> ASDisplayNode {
        authForm.addSubnode(authFormWrapper)
        authFormWrapper.layoutSpecBlock = { _, _ in
            let layout = ASStackLayoutSpec.vertical()
            layout.spacing = 20
            layout.alignItems = .stretch
            layout.children = elements
            
            return ASInsetLayoutSpec(
                insets: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15),
                child: layout
            )
        }
        
        authForm.layoutSpecBlock = { [weak self] _, _ in
            guard let self = self else { return ASLayoutSpec() }
            
            let centerLayout = ASCenterLayoutSpec(
                centeringOptions: .Y,
                sizingOptions: [],
                child: self.authFormWrapper
            )
 
            return ASInsetLayoutSpec(
                insets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15),
                child: centerLayout
            )
        }
        
        return authForm
    }
    
    func getHeaderLayout() -> ASLayoutSpec {
        let layout = ASStackLayoutSpec.horizontal()
        layout.style.alignSelf = .center
        layout.alignItems = .center
        layout.children = [logo]
        
        return layout
    }
    
    override func applyTheme(_ theme: Theme) {
        backgroundColor = theme.authPresentationData.backgroundColor
    }
}
