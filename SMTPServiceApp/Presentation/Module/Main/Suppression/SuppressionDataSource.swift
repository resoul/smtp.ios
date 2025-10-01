import AsyncDisplayKit
import UIKit

extension SuppressionController: ASTableDataSource, ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = SuppressionViewModel.Section(rawValue: section) else { return 0 }
        
        switch sectionType {
        case .suppression:
            return items.count
        default:
            return sectionType.numberOfRows
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        SuppressionViewModel.Section.allCases.count
    }
    
    func tableNode(
        _ tableNode: ASTableNode,
        nodeBlockForRowAt indexPath: IndexPath
    ) -> ASCellNodeBlock {
        return { [weak self] in
            guard let self = self,
                  let section = SuppressionViewModel.Section(rawValue: indexPath.section) else {
                return ASCellNode()
            }
  
            switch section {
            case .suppressionHeader:
                let node = SuppressionFilterNode()
                node.onApplyFilter = { [weak self] data in
//                    self?.handleFilter(data)
                }
                node.onTapFilter = { [weak self] in
                    self?.handleFilter()
                }
                
                return node
            case .suppression:
                return SuppressionNode(suppression: self.items[indexPath.row])
            }
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, willDisplayRowWith node: ASCellNode) {
        let threshold = 3
        let lastIndex = items.count - threshold
        if let indexPath = tableNode.indexPath(for: node),
           indexPath.row == lastIndex,
           items.count < totalCount {
            loadMoreData()
        }
    }
    
    // MARK: - Table View Height
    func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        let width = tableNode.bounds.width
        
        guard let section = SuppressionViewModel.Section(rawValue: indexPath.section) else {
            return ASSizeRangeMake(CGSize(width: width, height: 0), CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        }
        
        switch section {
        case .suppressionHeader:
            return ASSizeRangeMake(CGSize(width: width, height: 70), CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        case .suppression:
            return ASSizeRangeMake(CGSize(width: width, height: 80), CGSize(width: width, height: 120))
        }
    }
}
