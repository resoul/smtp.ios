import UIKit

enum SuppressionType: String, CaseIterable {
    case complaint
    case unsubscribe
    case hardBounce

    init(rawValue: String) {
        switch rawValue.lowercased() {
        case "complaint": self = .complaint
        case "unsubscribe": self = .unsubscribe
        default: self = .hardBounce
        }
    }
}
