import Foundation

final class EmailInputFieldNode: InputFieldNode {
    init(labelText: String = "Email",
         placeholder: String = "example@mail.com",
         onTextChanged: ((String) -> Void)? = nil) {

        let emailValidation: (String) -> String? = { text in
            let emailRegEx = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
            let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return predicate.evaluate(with: text) ? nil : "Invalid email address"
        }

        super.init(labelText: labelText,
                   placeholder: placeholder,
                   isSecure: false,
                   validationRule: emailValidation,
                   onTextChanged: onTextChanged)
        
        configureTextField { tf in
            tf.keyboardType = .emailAddress
            tf.textContentType = .emailAddress
            tf.autocapitalizationType = .none
        }
    }
}
