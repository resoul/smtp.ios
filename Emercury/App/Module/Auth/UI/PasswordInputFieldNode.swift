import AsyncDisplayKit

final class PasswordInputFieldNode: ASDisplayNode, UITextFieldDelegate {

    private let labelNode = ASTextNode()
    private let textFieldNode: ASDisplayNode
    private let errorNode = ASTextNode()

    var textField: UITextField {
        return textFieldNode.view as! UITextField
    }

    private var validationRule: ((String) -> String?)?
    private var onTextChanged: ((String) -> Void)?

    init(labelText: String, placeholder: String,
         validationRule: ((String) -> String?)? = nil,
         onTextChanged: ((String) -> Void)? = nil) {

        self.textFieldNode = ASDisplayNode(viewBlock: {
            let tf = UITextField()
            tf.layer.cornerRadius = 0
            tf.layer.borderWidth = 1
            tf.layer.borderColor = UIColor.hex("c1c1c1").cgColor
            tf.font = UIFont(name: "Poppins-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
            tf.setLeftPaddingPoints(8)
            tf.setRightPaddingPoints(8)
            return tf
        })

        self.validationRule = validationRule
        self.onTextChanged = onTextChanged

        super.init()
        automaticallyManagesSubnodes = true

        labelNode.attributedText = NSAttributedString(
            string: labelText,
            attributes: [
                .font: UIFont(name: "Poppins-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.hex("444444")
            ]
        )

        let tf = self.textField
        tf.placeholder = placeholder
        tf.isSecureTextEntry = true
        tf.returnKeyType = .done
        tf.delegate = self
        tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)

        layoutSpecBlock = { [weak self] _, _ in
            return self?.layout() ?? ASLayoutSpec()
        }
    }

    // MARK: - Validation
    func validate() -> Bool {
        let text = textField.text ?? ""
        if let error = validationRule?(text) {
            showError(error)
            return false
        }
        clearError()
        return true
    }

    private func showError(_ message: String) {
        UIView.animate(withDuration: 0.25) {
            self.errorNode.attributedText = NSAttributedString(
                string: message,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 12),
                    .foregroundColor: UIColor.systemRed
                ]
            )
            self.setNeedsLayout()
        }
    }

    private func clearError() {
        if errorNode.attributedText != nil {
            UIView.animate(withDuration: 0.25) {
                self.errorNode.attributedText = nil
                self.setNeedsLayout()
            }
        }
    }

    @objc private func textDidChange() {
        onTextChanged?(textField.text ?? "")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    private func layout() -> ASLayoutSpec {
        textFieldNode.style.height = ASDimension(unit: .points, value: 44)

        let stack = ASStackLayoutSpec.vertical()
        stack.spacing = 6
        stack.children = [labelNode, textFieldNode, errorNode]

        return stack
    }
}
