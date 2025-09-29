import AsyncDisplayKit
import UIKit

extension TokenController: ASTableDataSource, ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = TokenViewModel.Section(rawValue: section) else { return 0 }
        
        switch sectionType {
        case .tokens:
            return items.count
        default:
            return sectionType.numberOfRows
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        TokenViewModel.Section.allCases.count
    }
    
    private func handleTabChange(_ tab: TokenViewModel.SettingsTab) {
        currentSettingsTab = tab
        tableNode.reloadRows(at: [
            IndexPath(row: 0, section: TokenViewModel.Section.content.rawValue)
        ], with: .fade)
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return { [weak self] in
            guard let self = self,
                  let section = TokenViewModel.Section(rawValue: indexPath.section) else {
                return ASCellNode()
            }

            switch section {
            case .tabs:
                let node = SettingsTabNode(tab: currentSettingsTab)
                node.onTabChanged = { [weak self] tab in
                    self?.handleTabChange(tab)
                }
                
                return node
            case .content:
                guard let token = items.first, let user = viewModel.getCurrentUser() else {
                    return SettingsContentNode(tab: currentSettingsTab, token: nil, user: nil)
                }
                
                return SettingsContentNode(tab: currentSettingsTab, token: token, user: user)
            case .tokensHeader:
                let node = TokenHeaderNode()
                node.onGenerateToken = { [weak self] in
                    self?.handleCreateToken()
                }
                
                return node
            case .tokens:
                return TokenNode(token: self.items[indexPath.row])
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
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        guard TokenViewModel.Section(rawValue: indexPath.section) == .tokens else { return nil }
        let token = items[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            self?.handleDeleteToken(at: indexPath)
            completion(true)
        }
        let updateAction = UIContextualAction(style: .normal, title: "Update") { [weak self] _, _, completion in
            self?.handleUpdateToken(at: indexPath)
            completion(true)
        }

        let title = token.state == .active ? "Block" : "Activate"
        let blockAction = UIContextualAction(style: .normal, title: title) { [weak self] _, _, completion in
            self?.handleBlockToken(at: indexPath)
            completion(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        updateAction.backgroundColor = UIColor.systemBlue
        updateAction.image = UIImage(systemName: "pencil")
        blockAction.backgroundColor = UIColor.systemOrange
        blockAction.image = UIImage(systemName: token.state == .active ? "lock.fill" : "lock.open.fill")
        
        return UISwipeActionsConfiguration(
            actions: [deleteAction, updateAction, blockAction]
        )
    }
    
    // MARK: - Table View Height
    func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        let width = tableNode.bounds.width
        
        guard let section = TokenViewModel.Section(rawValue: indexPath.section) else {
            return ASSizeRangeMake(CGSize(width: width, height: 0), CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        }
        
        switch section {
        case .tabs:
            return ASSizeRangeMake(CGSize(width: width, height: 50), CGSize(width: width, height: 50))
        case .content:
            return ASSizeRangeMake(CGSize(width: width, height: 100), CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        case .tokensHeader:
            return ASSizeRangeMake(CGSize(width: width, height: 152), CGSize(width: width, height: 152))
        case .tokens:
            return ASSizeRangeMake(CGSize(width: width, height: 80), CGSize(width: width, height: 120))
        }
    }
}
