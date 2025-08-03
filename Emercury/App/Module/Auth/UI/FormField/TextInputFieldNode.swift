final class TextInputFieldNode: InputFieldNode {
    init(labelText: String, placeholder: String,
         validationRule: ((String) -> String?)? = nil,
         onTextChanged: ((String) -> Void)? = nil) {

        super.init(labelText: labelText,
                   placeholder: placeholder,
                   isSecure: false,
                   validationRule: validationRule,
                   onTextChanged: onTextChanged)
    }
}
