final class PasswordInputFieldNode: InputFieldNode {
    init(labelText: String, placeholder: String,
         validationRule: ((String) -> String?)? = nil,
         onTextChanged: ((String) -> Void)? = nil) {

        super.init(labelText: labelText,
                   placeholder: placeholder,
                   isSecure: true,
                   validationRule: validationRule,
                   onTextChanged: onTextChanged)
    }
}
