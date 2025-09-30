import UIKit

enum ToastStyle {
    case success
    case error
    case warning
    case info
    
    var backgroundColor: UIColor {
        switch self {
        case .success: return UIColor.systemGreen
        case .error: return UIColor.systemRed
        case .warning: return UIColor.systemOrange
        case .info: return UIColor.systemBlue
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .success: return UIImage(systemName: "checkmark.circle.fill")
        case .error: return UIImage(systemName: "xmark.circle.fill")
        case .warning: return UIImage(systemName: "exclamationmark.triangle.fill")
        case .info: return UIImage(systemName: "info.circle.fill")
        }
    }
}
