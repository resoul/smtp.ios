import AsyncDisplayKit

final class UserDomainCollectionCell: ASCellNode {
    private let userDomainNode: UserDomainNode
    init(userDomain: UserDomain, onDelete: (() -> Void)? = nil, onTest: (() -> Void)? = nil) {
        userDomainNode = UserDomainNode(userDomain: userDomain, onDelete: onDelete, onTest: onTest)
        super.init()
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        ASWrapperLayoutSpec(layoutElement: userDomainNode)
    }
}
