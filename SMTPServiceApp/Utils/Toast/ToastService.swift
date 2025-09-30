import Foundation

protocol ToastService {
    func show(message: String, style: ToastStyle, duration: TimeInterval, position: ToastPosition)
    func showSuccess(_ message: String)
    func showError(_ message: String)
    func showWarning(_ message: String)
    func showInfo(_ message: String)
}
