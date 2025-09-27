import AsyncDisplayKit
import Combine

enum ForgotPasswordNodeEvent {
    case registration
    case login
    case submit
}

final class ForgotPasswordNode: AuthNode, UIGestureRecognizerDelegate {
    let events = PassthroughSubject<ForgotPasswordNodeEvent, Never>()
    
    var emailTextPublisher: AnyPublisher<String, Never> {
        emailField.textDidChange.eraseToAnyPublisher()
    }
    
    func setLoginButtonEnabled(_ isEnabled: Bool) {
        submitButton.setButtonEnabled(isEnabled)
    }
    
    private lazy var submitButton: AuthSubmitButtonNode = {
        let btn = AuthSubmitButtonNode(
            text: "Reset"
        )
        
        btn.addTarget(self, action: #selector(handleResetTap), forControlEvents: .touchUpInside)
        
        return btn
    }()
    
    func setLoading(_ isLoading: Bool) {
        if isLoading {
            submitButton.setTitle("Logging in...", with: UIFont.poppinsWithFallback(.bold, size: 16, fallback: .bold), with: .white, for: .normal)
            submitButton.isEnabled = false
        } else {
            submitButton.setTitle("Reset", with: UIFont.poppinsWithFallback(.bold, size: 16, fallback: .bold), with: .white, for: .normal)
        }
    }
    
    //MARK: TODO: create TextNode
    private lazy var needAccountText: ASTextNode = {
        let text = ASTextNode()
        text.attributedText = NSAttributedString(
            string: "Need an account ",
            attributes: [
                .font: UIFont.poppinsWithFallback(.regular, size: 16),
                .foregroundColor: themeManager.currentTheme.authPresentationData.textColor
            ]
        )
        
        return text
    }()
    
    private lazy var registrationTextButton: AuthTextButtonNode = {
        let btn = AuthTextButtonNode(
            text: "Register Here",
            textColor: themeManager.currentTheme.authPresentationData.textLinkColor,
            textSize: 15,
            isUnderlined: false
        )
        
        btn.addTarget(self, action: #selector(handleRegistrationTap), forControlEvents: .touchUpInside)
        
        return btn
    }()
    
    private lazy var loginTextButton: AuthTextButtonNode = {
        let btn = AuthTextButtonNode(
            text: "Already have an account?",
            textColor: themeManager.currentTheme.authPresentationData.textLinkColor,
            textSize: 15,
            isUnderlined: false
        )
        
        btn.addTarget(self, action: #selector(handleLoginTap), forControlEvents: .touchUpInside)
        
        return btn
    }()
    
    private lazy var resetPasswordText: ASTextNode = {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let text = ASTextNode()
        text.attributedText = NSAttributedString(
            string: "Reset Password",
            attributes: [
                .font: UIFont.poppinsWithFallback(.bold, size: 19, fallback: .bold),
                .foregroundColor: themeManager.currentTheme.authPresentationData.headlineColor,
                .paragraphStyle: paragraph
            ]
        )
        
        return text
    }()
    
    private lazy var emailField = AuthEmailInputFieldNode()
    private lazy var placeholderText: ASTextNode = {
        let text = ASTextNode()
        text.attributedText = NSAttributedString(
            string: "Please enter your email and we will send you instructions to reset your password",
            attributes: [
                .font: UIFont.poppinsWithFallback(.regular, size: 17),
                .foregroundColor: themeManager.currentTheme.authPresentationData.headlineColor
            ]
        )
        
        return text
    }()
    
    @objc
    private func handleResetTap() {
        events.send(.submit)
    }
    
    @objc
    private func handleRegistrationTap() {
        events.send(.registration)
    }
    
    @objc
    private func handleLoginTap() {
        events.send(.login)
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

        return !emailField.frame.contains(touchPoint)
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let registerLayout = ASStackLayoutSpec.horizontal()
        registerLayout.alignItems = .start
        registerLayout.children = [needAccountText, registrationTextButton]
        registerLayout.style.alignSelf = .start
        
        let layout = ASStackLayoutSpec.vertical()
        layout.spacing = 3
        layout.justifyContent = .spaceBetween
        layout.alignItems = .stretch
        layout.children = [
            getHeaderLayout(),
            getAuthFormLayout(elements: [
                self.resetPasswordText,
                self.placeholderText,
                self.emailField,
                registerLayout,
                ASStackLayoutSpec(
                    direction: .vertical,
                    spacing: 0,
                    justifyContent: .start,
                    alignItems: .start,
                    children: [loginTextButton]
                ),
                self.submitButton
            ])
        ]
        
        return ASInsetLayoutSpec(
            insets: DeviceManager.shared.getSafeAreaInsets(),
            child: layout
        )
    }
}
