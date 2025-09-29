import AsyncDisplayKit

final class UserDomainCollectionCell: ASCellNode {
    private let userDomainNode: UserDomainNode
    init(user: User?, userDomain: UserDomain, onDelete: (() -> Void)? = nil, onTest: (() -> Void)? = nil) {
        self.userDomainNode = UserDomainNode(user: user, userDomain: userDomain, onDelete: onDelete, onTest: onTest)
        super.init()
        self.selectionStyle = .none
        self.addSubnode(self.userDomainNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: .zero, child: self.userDomainNode)
    }
}
