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
                onTest: { [weak self] in
                    self?.handleVerificationRequest(at: indexPath)
                }
            )
        }
    }

    private func handleVerificationRequest(at indexPath: IndexPath) {
        guard indexPath.item < items.count else { return }
        Task {
            let domain = try await viewModel.verify(userDomain: items[indexPath.item])
            items[indexPath.item] = domain
            await MainActor.run {
                collectionNode.reloadItems(at: [indexPath])
                if domain.state == .verified {
                    showSuccessToast("Domain is \(domain.state)")
                } else {
                    showInfoToast("Domain is \(domain.state)")
                }
            }
        }
    }

    private func handleDeleteRequest(at indexPath: IndexPath) {
        let alert = UIAlertController(
            title: "Delete Domain",
            message: "Are you sure you want to delete this domain?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.deleteDomain(at: indexPath)
        })

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
                showSuccessToast("Domain was successfully deleted")
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
