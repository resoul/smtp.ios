import AsyncDisplayKit
import Combine
import FontManager
import DeviceManager

enum RequestResetPasswordNodeEvent {
    case submit
}

final class RequestResetPasswordNode: AuthNode, UIGestureRecognizerDelegate {
    let events = PassthroughSubject<RequestResetPasswordNodeEvent, Never>()
    private let passwordField = AuthPasswordInputFieldNode(labelText: String(localized: "em.smtp.t.auth.password"))
    private let retypePasswordField = AuthPasswordInputFieldNode(
        labelText: String(localized: "em.smtp.t.auth.retype_password")
    )
    
    var passwordTextPublisher: AnyPublisher<String, Never> {
        passwordField.textDidChange.eraseToAnyPublisher()
    }
    
    var retypePasswordTextPublisher: AnyPublisher<String, Never> {
        retypePasswordField.textDidChange.eraseToAnyPublisher()
    }
    
    func setButtonEnabled(_ isEnabled: Bool) {
        submitButton.setButtonEnabled(isEnabled)
    }
    
    //MARK: TODO: create TextNode
    private lazy var headlineText: ASTextNode = {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let text = ASTextNode()
        text.attributedText = NSAttributedString(
            string: String(localized: "em.smtp.t.auth.request_reset_password"),
            attributes: [
                .font: UIFont.poppinsWithFallback(.bold, size: 19, fallback: .bold),
                .foregroundColor: themeManager.currentTheme.authPresentationData.headlineColor,
                .paragraphStyle: paragraph
            ]
        )
        
        return text
    }()
    
    private lazy var submitButton: AuthSubmitButtonNode = {
        let btn = AuthSubmitButtonNode(text: String(localized: "em.smtp.t.auth.save"))
        btn.addTarget(self, action: #selector(handleSubmit), forControlEvents: .touchUpInside)
        
        return btn
    }()
    
    @objc
    private func handleSubmit() {
        events.send(.submit)
    }
    
    func setLoading(_ isLoading: Bool) {
        if isLoading {
            submitButton.setTitle(String(localized: "em.smtp.t.auth.is_loading"), with: UIFont.poppinsWithFallback(.bold, size: 16, fallback: .bold), with: .white, for: .normal)
            setButtonEnabled(false)
        } else {
            submitButton.setTitle(String(localized: "em.smtp.t.auth.save"), with: UIFont.poppinsWithFallback(.bold, size: 16, fallback: .bold), with: .white, for: .normal)
        }
    }
    
    private var tapGesture: UITapGestureRecognizer?
    
    override func setupUI() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture?.cancelsTouchesInView = false
        tapGesture?.delegate = self
        view.addGestureRecognizer(tapGesture!)
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: view)
        
        return !passwordField.frame.contains(touchPoint) && !retypePasswordField.frame.contains(touchPoint)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let layout = ASStackLayoutSpec.vertical()
        layout.spacing = 3
        layout.justifyContent = .spaceBetween
        layout.alignItems = .stretch
        layout.children = [
            getHeaderLayout(),
            getAuthFormLayout(elements: [
                self.headlineText,
                self.passwordField,
                self.retypePasswordField,
                self.submitButton
            ])
        ]
        
        return ASInsetLayoutSpec(
            insets: DeviceManager.shared.getSafeAreaInsets(),
            child: layout
        )
    }
}
