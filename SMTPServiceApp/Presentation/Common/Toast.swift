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

enum ToastPosition {
    case top
    case center
    case bottom
}

protocol ToastService {
    func show(message: String, style: ToastStyle, duration: TimeInterval, position: ToastPosition)
    func showSuccess(_ message: String)
    func showError(_ message: String)
    func showWarning(_ message: String)
    func showInfo(_ message: String)
}

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

// MARK: - ToastView

final class ToastView: UIView {
    private let iconImageView = UIImageView()
    private let messageLabel = UILabel()
    private let stackView = UIStackView()
    
    init(message: String, style: ToastStyle) {
        super.init(frame: .zero)
        setupView(message: message, style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(message: String, style: ToastStyle) {
        backgroundColor = style.backgroundColor
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 8
        
        // Icon
        iconImageView.image = style.icon
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Message
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Stack
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(messageLabel)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
        
        // Add tap to dismiss
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}

// MARK: - UIViewController Extension

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
