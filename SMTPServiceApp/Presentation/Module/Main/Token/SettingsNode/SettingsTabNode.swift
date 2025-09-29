import AsyncDisplayKit


final class SettingsTabNode: ASCellNode {
    private var tab: TokenViewModel.SettingsTab
    private let tabBar = SettingsTabBarNode(titles: ["SMTP", "API details"])
    private let smtpButton = ASButtonNode()
    private let apiButton = ASButtonNode()
    
    var onTabChanged: ((TokenViewModel.SettingsTab) -> Void)?
    
    init(tab: TokenViewModel.SettingsTab) {
        self.tab = tab
        super.init()
        automaticallyManagesSubnodes = true
        selectionStyle = .none
        setupNodes()
    }
    
    private func setupNodes() {
        tabBar.onTabSelected = { [weak self] index in
            guard let self else { return }
            if index == 0 {
                self.tab = .smtp
                self.onTabChanged?(self.tab)
            } else {
                self.tab = .apiDetails
                self.onTabChanged?(self.tab)
            }
        }
    }

    private let bottomBorder: ASDisplayNode = {
        let node = ASDisplayNode()
        node.backgroundColor = UIColor.hex("F1F1F4")
        return node
    }()
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        bottomBorder.style.height = ASDimension(unit: .points, value: 1)
        bottomBorder.style.width = ASDimension(unit: .fraction, value: 1.0)
        
        return ASOverlayLayoutSpec(
            child: ASInsetLayoutSpec(
                insets: .init(top: 6, left: 16, bottom: 0, right: 16),
                child: tabBar
            ),
            overlay: ASInsetLayoutSpec(
                insets: .init(top: .infinity, left: 0, bottom: 0, right: 0),
                child: bottomBorder
            )
        )
    }
}
