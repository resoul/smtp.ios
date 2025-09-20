import AsyncDisplayKit

extension UserDomainController: ASCollectionDataSource, ASCollectionDelegate {
    func collectionNode(
        _ collectionNode: ASCollectionNode,
        numberOfItemsInSection section: Int
    ) -> Int {
        totalCount
    }
    
    func collectionNode(
        _ collectionNode: ASCollectionNode,
        nodeBlockForItemAt indexPath: IndexPath
    ) -> ASCellNodeBlock {
        return {
            UserDomainCollectionCell(userDomain: self.items[indexPath.item])
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, willDisplayItemWith node: ASCellNode) {
        let threshold = 3
        guard threshold >= items.count else {
            return
        }
        
        let lastIndex = items.count - threshold
        if let indexPath = collectionNode.indexPath(for: node), indexPath.item == lastIndex {
            print("lastIndex", lastIndex)
            print("indexPath", indexPath.item)
            loadMoreData()
        }
    }
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        1
    }
    
    func collectionNode(
        _ collectionNode: ASCollectionNode,
        constrainedSizeForItemAt indexPath: IndexPath
    ) -> ASSizeRange {
        let width = collectionNode.bounds.width - 32
        return ASSizeRangeMake(
            CGSize(width: width, height: 0),
            CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        )
    }
}
