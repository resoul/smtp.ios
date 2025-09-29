import AsyncDisplayKit
import UIKit

extension UserDomainController: ASCollectionDataSource, ASCollectionDelegate {
    func collectionNode(
        _ collectionNode: ASCollectionNode,
        numberOfItemsInSection section: Int
    ) -> Int {
        items.count
    }
    
    func collectionNode(
        _ collectionNode: ASCollectionNode,
        nodeBlockForItemAt indexPath: IndexPath
    ) -> ASCellNodeBlock {
        return { [weak self] in
            guard let self = self else { return ASCellNode() }
            return UserDomainCollectionCell(
                user: viewModel.getCurrentUser(),
                userDomain: self.items[indexPath.item],
                onDelete: { [weak self] in
                    self?.handleDeleteRequest(at: indexPath)
                },
                onTest: {
                    print("test")
                }
            )
        }
    }

    private func handleDeleteRequest(at indexPath: IndexPath) {
        // Present the alert for user confirmation
        let alert = UIAlertController(
            title: "Delete Domain",
            message: "Are you sure you want to delete this domain?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.deleteDomain(at: indexPath)
        })

        // Present alert on main thread
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    private func deleteDomain(at indexPath: IndexPath) {
        guard indexPath.item < items.count else { return }
        Task {
            try await viewModel.delete(domainUuid: items[indexPath.item].uuid)
            items.remove(at: indexPath.item)
            totalCount = totalCount - 1
            await collectionNode.performBatchUpdates({
                collectionNode.deleteItems(at: [indexPath])
            })
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, willDisplayItemWith node: ASCellNode) {
        let threshold = 3
        let lastIndex = items.count - threshold
        if let indexPath = collectionNode.indexPath(for: node),
           indexPath.row == lastIndex,
           items.count < totalCount {
            loadMoreData()
        }
        
        
        
//        let threshold = 3
//        guard threshold >= items.count else {
//            return
//        }
//        
//        let lastIndex = items.count - threshold
//        if let indexPath = collectionNode.indexPath(for: node), indexPath.item == lastIndex {
//            print("lastIndex", lastIndex)
//            print("indexPath", indexPath.item)
//            loadMoreData()
//        }
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
