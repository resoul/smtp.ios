import AsyncDisplayKit

final class UserDomainCollectionCell: ASCellNode {
    private let userDomainNode: UserDomainNode

    init(userDomain: UserDomain) {
        userDomainNode = UserDomainNode(userDomain: userDomain)
        super.init()
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        ASWrapperLayoutSpec(layoutElement: userDomainNode)
    }
}
