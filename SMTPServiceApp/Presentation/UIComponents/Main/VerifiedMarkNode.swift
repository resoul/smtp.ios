import AsyncDisplayKit

final class VerifiedMarkNode: ASImageNode {
    private var filledExclamationMark: Bool
    func setState(_ state: String) {
        if state == "verified" {
            image = UIImage(named: "success")
        } else {
            image = UIImage(
                named: filledExclamationMark ? "exclamationmark.filled" : "exclamationmark"
            )
        }
    }
    
    func setValidated(_ validated: Bool) {
        if validated {
            image = UIImage(named: "checked")
        } else {
            image = UIImage(
                named: filledExclamationMark ? "exclamationmark.filled" : "exclamationmark"
            )
        }
    }
    
    init(preferredSize: CGSize = CGSize(width: 20, height: 20), filledExclamationMark: Bool = true) {
        self.filledExclamationMark = filledExclamationMark
        super.init()
        style.preferredSize = preferredSize
        automaticallyManagesSubnodes = true
        contentMode = .scaleAspectFit
    }
}
