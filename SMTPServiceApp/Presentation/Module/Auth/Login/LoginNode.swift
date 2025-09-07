import AsyncDisplayKit
import Combine
import FontManager
import DeviceManager

enum LoginNodeEvent {
    case registration
    case login
    case forgotPassword
}

final class LoginNode: AuthNode, UIGestureRecognizerDelegate {
    let events = PassthroughSubject<LoginNodeEvent, Never>()
    //MARK: TODO: create TextNode
    private lazy var needAccountText: ASTextNode = {
        let text = ASTextNode()
        text.attributedText = NSAttributedString(
            string: "Need An Account - ",
            attributes: [
                .font: UIFont.poppinsWithFallback(.regular, size: 16),
                .foregroundColor: themeManager.currentTheme.authPresentationData.textColor
            ]
        )
        
        return text
    }()
    
    private lazy var loginText: ASTextNode = {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let text = ASTextNode()
        text.attributedText = NSAttributedString(
            string: "Log in to your SMTP account",
            attributes: [
                .font: UIFont.poppinsWithFallback(.bold, size: 19, fallback: .bold),
                .foregroundColor: themeManager.currentTheme.authPresentationData.headlineColor,
                .paragraphStyle: paragraph
            ]
        )
        
        return text
    }()
    
    private lazy var registrationTextButton: AuthTextButtonNode = {
        let btn = AuthTextButtonNode(
            text: "Register Here",
            textColor: themeManager.currentTheme.authPresentationData.textLinkColor,
            textSize: 15
        )
        
        btn.addTarget(self, action: #selector(handleRegistrationTap), forControlEvents: .touchUpInside)
        
        return btn
    }()
    
    private lazy var forgotPasswordTextButton: AuthTextButtonNode = {
        let btn = AuthTextButtonNode(
            text: "Forgot Password",
            textColor: themeManager.currentTheme.authPresentationData.textLinkColor,
            textSize: 15,
            isUnderlined: false,
            alignment: .left
        )
        
        btn.style.alignSelf = .start
        btn.addTarget(self, action: #selector(handleForgotPasswordTap), forControlEvents: .touchUpInside)
        
        return btn
    }()
    
    private lazy var submitButton: AuthSubmitButtonNode = {
        let btn = AuthSubmitButtonNode(
            text: "Login"
        )
        
        btn.addTarget(self, action: #selector(handleLoginTap), forControlEvents: .touchUpInside)
        
        return btn
    }()

    var emailTextPublisher: AnyPublisher<String, Never> {
        usernameField.textDidChange.eraseToAnyPublisher()
    }
    
    var passwordTextPublisher: AnyPublisher<String, Never> {
        passwordField.textDidChange.eraseToAnyPublisher()
    }
    
    private lazy var usernameField = AuthEmailInputFieldNode()
    private lazy var passwordField = AuthPasswordInputFieldNode(
        labelText: "Password"
    )
    
    func setLoginButtonEnabled(_ isEnabled: Bool) {
        submitButton.setButtonEnabled(isEnabled)
    }
    
    func setLoading(_ isLoading: Bool) {
        if isLoading {
            submitButton.setTitle("Logging in...", with: UIFont.poppinsWithFallback(.bold, size: 16, fallback: .bold), with: .white, for: .normal)
            submitButton.isEnabled = false
        } else {
            submitButton.setTitle("Login", with: UIFont.poppinsWithFallback(.bold, size: 16, fallback: .bold), with: .white, for: .normal)
        }
    }
    
    @objc
    private func handleRegistrationTap() {
        events.send(.registration)
    }
    
    @objc
    private func handleLoginTap() {
        events.send(.login)
    }
    
    @objc
    private func handleForgotPasswordTap() {
        events.send(.forgotPassword)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let footer = ASStackLayoutSpec.horizontal()
        footer.spacing = 4
        footer.alignItems = .center
        footer.children = [needAccountText, registrationTextButton]
        footer.style.alignSelf = .center
        
        let layout = ASStackLayoutSpec.vertical()
        layout.spacing = 3
        layout.justifyContent = .spaceBetween
        layout.alignItems = .stretch
        layout.children = [
            getHeaderLayout(),
            getAuthFormLayout(elements: [
                self.loginText,
                self.usernameField,
                self.passwordField,
                self.forgotPasswordTextButton,
                self.submitButton
            ]),
            footer
        ]
        
        return ASInsetLayoutSpec(
            insets: DeviceManager.shared.getSafeAreaInsets(),
            child: layout
        )
    }
    
    private var tapGesture: UITapGestureRecognizer?
    override init() {
        super.init()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture?.cancelsTouchesInView = false
        tapGesture?.delegate = self
        view.addGestureRecognizer(tapGesture!)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: view)
        let usernameFrame = usernameField.frame
        let inputFrame = passwordField.frame
        
        return !inputFrame.contains(touchPoint) && !usernameFrame.contains(touchPoint)
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
