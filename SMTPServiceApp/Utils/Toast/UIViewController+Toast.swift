import UIKit

extension UIViewController {
    func showToast(message: String, style: ToastStyle = .info, duration: TimeInterval = 3.0) {
        ToastServiceImpl.shared.show(message: message, style: style, duration: duration)
    }
    
    func showSuccessToast(_ message: String) {
        ToastServiceImpl.shared.showSuccess(message)
    }
    
    func showErrorToast(_ message: String) {
        ToastServiceImpl.shared.showError(message)
    }
    
    func showWarningToast(_ message: String) {
        ToastServiceImpl.shared.showWarning(message)
    }
    
    func showInfoToast(_ message: String) {
        ToastServiceImpl.shared.showInfo(message)
    }
}
