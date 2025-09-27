import AsyncDisplayKit
import Combine

protocol AuthInputFieldNodeDelegate: AnyObject {
    func inputFieldDidBeginEditing(_ inputField: AuthInputFieldNode)
    func inputFieldDidEndEditing(_ inputField: AuthInputFieldNode)
}

class AuthInputFieldNode: ASDisplayNode, UITextFieldDelegate {
    let textDidChange = PassthroughSubject<String, Never>()
    weak var inputDelegate: AuthInputFieldNodeDelegate?
    
    let labelNode: AuthLabelNode
    let textFieldNode: ASDisplayNode
    
    var textField: UITextField {
        return textFieldNode.view as! UITextField
    }

    init(labelText: String, isSecure: Bool = false) {
        textFieldNode = ASDisplayNode(viewBlock: {
            let tf = UITextField()
            tf.layer.cornerRadius = 0
            tf.layer.borderWidth = 1
            tf.layer.borderColor = UIColor.hex("c1c1c1").cgColor
            tf.textColor = UIColor.hex("4B5675")
            tf.font = UIFont.poppinsWithFallback(.regular, size: 16)
            tf.setLeftPaddingPoints(8)
            tf.setRightPaddingPoints(8)
            tf.isSecureTextEntry = isSecure
            tf.returnKeyType = .done
            
            return tf
        })
        
        labelNode = AuthLabelNode(text: labelText)
        
        super.init()
        automaticallyManagesSubnodes = true
        textField.delegate = self
        textField.addTarget(self, action: #selector(textDidChangeHandler), for: .editingChanged)

        layoutSpecBlock = { [weak self] _, _ in
            return self?.layout() ?? ASLayoutSpec()
        }
    }

    @objc
    private func textDidChangeHandler() {
        textDidChange.send(textField.text ?? "")
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        inputDelegate?.inputFieldDidBeginEditing(self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        inputDelegate?.inputFieldDidEndEditing(self)
    }
    
    // MARK: - Layout
    func layout() -> ASLayoutSpec {
        textFieldNode.style.height = ASDimension(unit: .points, value: 44)
        
        let stack = ASStackLayoutSpec.vertical()
        stack.spacing = 6
        stack.children = [labelNode, textFieldNode]
        
        return stack
    }
}
