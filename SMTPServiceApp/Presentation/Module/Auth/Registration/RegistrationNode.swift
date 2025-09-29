import AsyncDisplayKit
import Combine

enum RegistrationNodeEvent {
    case submit
    case login
}

class RegistrationNode: AuthNode, UIGestureRecognizerDelegate {
    let events = PassthroughSubject<RegistrationNodeEvent, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var passwordStrengthNode = PasswordStrengthNode()
    private lazy var emailField = AuthEmailInputFieldNode()
    private lazy var firstNameField = AuthInputFieldNode(labelText: "First Name")
    private lazy var lastNameField = AuthInputFieldNode(labelText: "Last Name")
    private lazy var passwordField = AuthPasswordInputFieldNode(labelText: "Password")
    private lazy var retypePasswordField = AuthPasswordInputFieldNode(labelText: "Retype password")
    
    private lazy var registrationText: ASTextNode = {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let text = ASTextNode()
        text.attributedText = NSAttributedString(
            string: "Sign up with your email address",
            attributes: [
                .font: UIFont.poppinsWithFallback(.bold, size: 19, fallback: .bold),
                .foregroundColor: themeManager.currentTheme.authPresentationData.headlineColor,
                .paragraphStyle: paragraph
            ]
        )
        
        return text
    }()
    
    private lazy var loginTextButton: AuthTextButtonNode = {
        let btn = AuthTextButtonNode(
            text: "Already have an account?",
            textColor: themeManager.currentTheme.authPresentationData.textLinkColor,
            textSize: 15,
            isUnderlined: false
        )
        
        btn.style.alignSelf = .start
        btn.addTarget(self, action: #selector(handleLoginTap), forControlEvents: .touchUpInside)
        
        return btn
    }()
    
    private lazy var submitButton: AuthSubmitButtonNode = {
        let btn = AuthSubmitButtonNode(
            text: "Sign Up"
        )
        
        btn.addTarget(self, action: #selector(handleSubmitTap), forControlEvents: .touchUpInside)
        
        return btn
    }()
    
    var emailTextPublisher: AnyPublisher<String, Never> {
        emailField.textDidChange.eraseToAnyPublisher()
    }
    
    var firstNameTextPublisher: AnyPublisher<String, Never> {
        firstNameField.textDidChange.eraseToAnyPublisher()
    }
    
    var lastNameTextPublisher: AnyPublisher<String, Never> {
        lastNameField.textDidChange.eraseToAnyPublisher()
    }
    
    var passwordTextPublisher: AnyPublisher<String, Never> {
        passwordField.textDidChange.eraseToAnyPublisher()
    }
    
    var retypePasswordTextPublisher: AnyPublisher<String, Never> {
        retypePasswordField.textDidChange.eraseToAnyPublisher()
    }
    
    override func applyTheme(_ theme: Theme) {
        backgroundColor = theme.authPresentationData.backgroundColor
    }

    @objc
    private func handleSubmitTap() {
        events.send(.submit)
    }
    
    @objc
    private func handleLoginTap() {
        events.send(.login)
    }
    
    func setRegistrationButtonEnabled(_ isEnabled: Bool) {
        submitButton.setButtonEnabled(isEnabled)
    }
    
    private lazy var loadingIndicator: ASDisplayNode = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        let node = ASDisplayNode(viewBlock: { activityIndicator })
        node.style.preferredSize = CGSize(width: 20, height: 20)
        return node
    }()
    
    func setLoading(_ isLoading: Bool) {
        if isLoading {
            submitButton.setTitle("Logging in...", with: UIFont.poppinsWithFallback(.bold, size: 16, fallback: .bold), with: .white, for: .normal)
            submitButton.isEnabled = false
            if let activityIndicator = loadingIndicator.view as? UIActivityIndicatorView {
                activityIndicator.startAnimating()
            }
        } else {
            submitButton.setTitle("Sign Up", with: UIFont.poppinsWithFallback(.bold, size: 16, fallback: .bold), with: .white, for: .normal)
            if let activityIndicator = loadingIndicator.view as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
            }
        }
    }
    
    private var tapGesture: UITapGestureRecognizer?
    
    override init() {
        super.init()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture?.cancelsTouchesInView = false
        tapGesture?.delegate = self
        view.addGestureRecognizer(tapGesture!)
        
        passwordField.textDidChange
            .sink { [weak self] password in
                self?.passwordStrengthNode.updatePassword(password)
            }
            .store(in: &cancellables)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: view)
        
        let emailFrame = emailField.frame
        let firstFrame = firstNameField.frame
        let lastFrame = lastNameField.frame
        let passwordFrame = passwordField.frame
        let retypePasswordFrame = retypePasswordField.frame
        
        return !passwordFrame.contains(touchPoint)
        && !retypePasswordFrame.contains(touchPoint)
        && !lastFrame.contains(touchPoint)
        && !firstFrame.contains(touchPoint)
        && !emailFrame.contains(touchPoint)
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let layout = ASStackLayoutSpec.vertical()
        layout.spacing = 3
        layout.justifyContent = .spaceBetween
        layout.alignItems = .stretch
        layout.children = [
            getHeaderLayout(),
            getAuthFormLayout(elements: [
                self.registrationText,
                self.emailField,
                self.firstNameField,
                self.lastNameField,
                self.passwordField,
                self.retypePasswordField,
                ASStackLayoutSpec(
                    direction: .vertical,
                    spacing: 0,
                    justifyContent: .start,
                    alignItems: .start,
                    children: [loginTextButton]
                ),
                self.passwordStrengthNode,
                self.submitButton
            ])
        ]
        
        let scrollNode = ASScrollNode()
        scrollNode.automaticallyManagesContentSize = true
        scrollNode.automaticallyManagesSubnodes = true
        scrollNode.layoutSpecBlock = { _, _ in
            return ASInsetLayoutSpec(
                insets: .zero,
                child: layout
            )
        }
        
        return ASInsetLayoutSpec(
            insets: DeviceManager.shared.getSafeAreaInsets(),
            child: scrollNode
        )
    }
}
