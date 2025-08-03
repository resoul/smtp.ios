import AsyncDisplayKit

class AuthLoginNode: ASDisplayNode {
    private lazy var usernameField = TextInputFieldNode(
        labelText: "Username",
        placeholder: "Enter your username",
        validationRule: { text in
            return text.isEmpty ? "Username cannot be empty" : nil
        },
        onTextChanged: { [weak self] _ in
            self?.updateButtonState()
        }
    )

    private lazy var passwordField = PasswordInputFieldNode(
        labelText: "Password",
        placeholder: "••••••",
        validationRule: { text in
            return text.count < 6 ? "Password must be at least 6 characters" : nil
        },
        onTextChanged: { [weak self] _ in
            self?.updateButtonState()
        }
    )

    private let textNode = ASTextNode()
    private let orNode = ASTextNode()
    
    private lazy var submitButton = SubmitButtonNode(
        text: "Sign In",
        onSubmit: { [weak self] in
            self?.handleSubmit()
        }
    )
    
    private lazy var textButton = TextButtonNode(
        text: "Forgot Password",
        textColor: UIColor.hex("575988"),
        onSubmit: { [weak self] in
            self?.handleTextTap()
        }
    )
    
    override init() {
        super.init()
        backgroundColor = .white
        automaticallyManagesSubnodes = true
        
        textNode.attributedText = NSAttributedString(
            string: "Log in to your account",
            attributes: [
                .font: UIFont(name: "Poppins-Bold", size: 19) ?? UIFont.systemFont(ofSize: 19),
                .foregroundColor: UIColor.hex("444444")
            ]
        )
        
        orNode.attributedText = NSAttributedString(
            string: "or",
            attributes: [
                .font: UIFont(name: "Poppins-Bold", size: 19) ?? UIFont.systemFont(ofSize: 19),
                .foregroundColor: UIColor.hex("444444")
            ]
        )

        layoutSpecBlock = { [weak self] _, _ in
            guard let self = self else { return ASLayoutSpec() }
            
            let hStack = ASStackLayoutSpec.horizontal()
            hStack.style.alignSelf = .center
            hStack.children = [self.textNode]
            
            let orStack = ASStackLayoutSpec.horizontal()
            orStack.style.alignSelf = .center
            orStack.children = [self.orNode]
            
            let forgotPass = ASStackLayoutSpec.horizontal()
            forgotPass.style.alignSelf = .start
            forgotPass.children = [self.textButton]
            
            let verticalStack = ASStackLayoutSpec.vertical()
            verticalStack.spacing = 20
            verticalStack.alignItems = .stretch
            verticalStack.children = [hStack, self.usernameField, self.passwordField, forgotPass, self.submitButton]
            
            return ASInsetLayoutSpec(
                insets: UIEdgeInsets(top: 100, left: 20, bottom: 20, right: 20),
                child: verticalStack
            )
        }
    }
    
    @objc private func handleTextTap() {
        print("Tapped underline button")
    }
    
    private func updateButtonState() {
        let isUsernameValid = usernameField.textField.text?.isEmpty == false
        let isPasswordValid = (passwordField.textField.text?.count ?? 0) >= 6

//        if isUsernameValid && isPasswordValid {
//            submitButton.backgroundColor = .systemBlue
//            submitButton.isUserInteractionEnabled = true
//        } else {
//            submitButton.backgroundColor = .lightGray
//            submitButton.isUserInteractionEnabled = false
//        }
    }
    
    private func handleSubmit() {
        let isValid = usernameField.validate() && passwordField.validate()

        if isValid {
            print("✅ Success:")
            print("Username:", usernameField.textField.text ?? "")
            print("Password:", passwordField.textField.text ?? "")
        } else {
            print("❌ Form Errors")
        }
    }
}
