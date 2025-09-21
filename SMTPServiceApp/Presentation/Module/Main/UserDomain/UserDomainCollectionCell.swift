import AsyncDisplayKit

final class UserDomainCollectionCell: ASCellNode {
    private let userDomainNode: UserDomainNode
    init(user: User?, userDomain: UserDomain, onDelete: (() -> Void)? = nil, onTest: (() -> Void)? = nil) {
        userDomainNode = UserDomainNode(user: user, userDomain: userDomain, onDelete: onDelete, onTest: onTest)
        super.init()
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        ASWrapperLayoutSpec(layoutElement: userDomainNode)
    }
}
