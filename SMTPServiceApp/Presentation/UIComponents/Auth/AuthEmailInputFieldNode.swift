import Foundation

final class AuthEmailInputFieldNode: AuthInputFieldNode {
    init(labelText: String = String(localized: "em.smtp.t.email")) {
        super.init(labelText: labelText, isSecure: false)
        textField.keyboardType = .emailAddress
        textField.textContentType = .emailAddress
        textField.autocapitalizationType = .none
    }
}
