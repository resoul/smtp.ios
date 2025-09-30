import UIKit

enum UserDomainState: String {
    case verified
    case unverified
    case incorrect
    case disabled

    init(rawValue: String) {
        switch rawValue.lowercased() {
        case "verified": self = .verified
        case "unverified": self = .unverified
        case "incorrect": self = .incorrect
        default: self = .disabled
        }
    }
}
