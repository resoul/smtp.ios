import UIKit

final class ToastServiceImpl: ToastService {
    static let shared = ToastServiceImpl()
    
    private var currentToast: ToastView?
    
    private init() {}
    
    func show(
        message: String,
        style: ToastStyle = .info,
        duration: TimeInterval = 3.0,
        position: ToastPosition = .bottom
    ) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Remove current toast if exists
            self.currentToast?.removeFromSuperview()
            
            guard let window = UIApplication.shared
                .connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive })?
                .windows
                .first(where: { $0.isKeyWindow }) else {
                    return
            }
            
            let toast = ToastView(message: message, style: style)
            self.currentToast = toast
            
            window.addSubview(toast)
            toast.translatesAutoresizingMaskIntoConstraints = false
            
            let constraints = self.getConstraints(for: toast, in: window, position: position)
            NSLayoutConstraint.activate(constraints)
            
            // Animation
            toast.alpha = 0
            toast.transform = CGAffineTransform(translationX: 0, y: position == .top ? -50 : 50)
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
                toast.alpha = 1
                toast.transform = .identity
            } completion: { _ in
                UIView.animate(withDuration: 0.3, delay: duration, options: .curveEaseInOut) {
                    toast.alpha = 0
                    toast.transform = CGAffineTransform(translationX: 0, y: position == .top ? -50 : 50)
                } completion: { _ in
                    toast.removeFromSuperview()
                    if self.currentToast === toast {
                        self.currentToast = nil
                    }
                }
            }
        }
    }
    
    func showSuccess(_ message: String) {
        show(message: message, style: .success)
    }
    
    func showError(_ message: String) {
        show(message: message, style: .error)
    }
    
    func showWarning(_ message: String) {
        show(message: message, style: .warning)
    }
    
    func showInfo(_ message: String) {
        show(message: message, style: .info)
    }
    
    private func getConstraints(
        for toast: ToastView,
        in window: UIWindow,
        position: ToastPosition
    ) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = [
            toast.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 16),
            toast.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -16)
        ]
        
        switch position {
        case .top:
            constraints.append(
                toast.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: 16)
            )
        case .center:
            constraints.append(
                toast.centerYAnchor.constraint(equalTo: window.centerYAnchor)
            )
        case .bottom:
            constraints.append(
                toast.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor, constant: -16)
            )
        }
        
        return constraints
    }
}
