import AsyncDisplayKit
import FontManager
import Combine

final class UserDomainNode: DisplayNode {
    private let userDomain: UserDomain
    private var items: [ASDisplayNode] = []
    
    init(userDomain: UserDomain) {
        self.userDomain = userDomain
        super.init()
        automaticallyManagesSubnodes = true
        items = []
    }
    
    override func applyTheme(_ theme: any Theme) {
        backgroundColor = theme.userDomainPresentationData.backgroundColor
        layer.borderWidth = 1
        layer.borderColor = theme.mainPresentationData.mainBorderColor
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let layout = ASStackLayoutSpec.vertical()
        layout.spacing = 11
        layout.children = items

        return ASInsetLayoutSpec(
            insets: .init(top: 8, left: 16, bottom: 8, right: 8),
            child: layout
        )
    }
}
