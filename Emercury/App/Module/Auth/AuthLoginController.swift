import AsyncDisplayKit

class AuthLoginController: ASDKViewController<ASDisplayNode> {
    private let logoNode = ASImageNode()
    private let footerTextNode = ASTextNode()
    private let loginButton = ASButtonNode()
    private let loginNode = AuthLoginNode()
    
    override init() {
        super.init(node: ASDisplayNode())
        setupUI()
        
        node.automaticallyManagesSubnodes = true
        node.backgroundColor = UIColor.hex("e5e5e5")
        node.layoutSpecBlock = { [weak self] _, _ in
            return self?.layout() ?? ASLayoutSpec()
        }
    }
    
    private func setupUI() {
        logoNode.image = UIImage(named: "dark-logo")
        logoNode.contentMode = .scaleAspectFit
        logoNode.style.preferredSize = CGSize(width: UIScreen.main.bounds.width * 0.33, height: 60)
        
        loginNode.style.flexGrow = 1
        loginNode.style.flexShrink = 1
        loginNode.style.alignSelf = .stretch
        
        footerTextNode.attributedText = NSAttributedString(
            string: "Need An Account - ",
            attributes: [
                .font: UIFont(name: "Poppins-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.hex("444444")
            ]
        )
        let loginTitle = NSAttributedString(
            string: "Register Here",
            attributes: [
                .font: UIFont(name: "Poppins-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.hex("575988"),
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )
        loginButton.setAttributedTitle(loginTitle, for: .normal)
        loginButton.contentEdgeInsets = .zero
        loginButton.addTarget(self, action: #selector(loginTapped), forControlEvents: .touchUpInside)
    }
    
    private func layout() -> ASLayoutSpec {
        let logoWrapper = ASRatioLayoutSpec(ratio: 0.5, child: logoNode)
        logoWrapper.style.alignSelf = .center
        
        let headerStack = ASStackLayoutSpec.horizontal()
        headerStack.style.alignSelf = .center
        headerStack.alignItems = .center
        headerStack.children = [logoNode]
        
        let footerStack = ASStackLayoutSpec.horizontal()
        footerStack.spacing = 4
        footerStack.alignItems = .center
        footerStack.children = [footerTextNode, loginButton]
        footerStack.style.alignSelf = .center

        let verticalStack = ASStackLayoutSpec.vertical()
        verticalStack.spacing = 22
        verticalStack.justifyContent = .spaceBetween
        verticalStack.alignItems = .stretch
        verticalStack.children = [headerStack, loginNode, footerStack]

        return ASInsetLayoutSpec(
            insets: UIEdgeInsets(top: 80, left: 20, bottom: 40, right: 20),
            child: verticalStack
        )
    }
    
    @objc private func loginTapped() {
        print("Кнопка Войти нажата")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
