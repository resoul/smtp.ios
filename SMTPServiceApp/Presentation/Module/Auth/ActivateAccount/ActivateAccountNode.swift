import AsyncDisplayKit
import Combine

enum ActivateAccountEvent {
    case resend
}

final class ActivateAccountNode: AuthNode {
    let events = PassthroughSubject<ActivateAccountEvent, Never>()
    
    //MARK: TODO: create TextNode
    private lazy var headlineText: ASTextNode = {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let text = ASTextNode()
        text.attributedText = NSAttributedString(
            string: "Activate your account",
            attributes: [
                .font: UIFont.poppinsWithFallback(.bold, size: 19, fallback: .bold),
                .foregroundColor: themeManager.currentTheme.authPresentationData.headlineColor,
                .paragraphStyle: paragraph
            ]
        )
        
        return text
    }()
    
    private lazy var resendTextButton: AuthTextButtonNode = {
        let btn = AuthTextButtonNode(
            text: "Resend email",
            textColor: themeManager.currentTheme.authPresentationData.textLinkColor,
            textSize: 15,
            isUnderlined: false,
            alignment: .left
        )
        
        btn.addTarget(self, action: #selector(handleResendTap), forControlEvents: .touchUpInside)
        
        return btn
    }()
    
    private lazy var resendText: ASTextNode = {
        let text = ASTextNode()
        text.attributedText = NSAttributedString(
            string: "An email with the activation link has been sent to your inbox. Please click the link to activate your account.",
            attributes: [
                .font: UIFont.poppinsWithFallback(.regular, size: 16),
                .foregroundColor: themeManager.currentTheme.authPresentationData.textColor
            ]
        )
        
        return text
    }()
    
    private lazy var resendInactiveText: ASTextNode = {
        let text = ASTextNode()
        text.attributedText = NSAttributedString(
            string: "If you don't click the link, your account will remain inactive.",
            attributes: [
                .font: UIFont.poppinsWithFallback(.regular, size: 16),
                .foregroundColor: themeManager.currentTheme.authPresentationData.textColor
            ]
        )
        
        return text
    }()
    
    private lazy var resendNotReceiveText: ASTextNode = {
        let text = ASTextNode()
        text.attributedText = NSAttributedString(
            string: "Didn't receive the email within a few minutes? Try 'Resend email' link below.",
            attributes: [
                .font: UIFont.poppinsWithFallback(.regular, size: 16),
                .foregroundColor: themeManager.currentTheme.authPresentationData.textColor
            ]
        )
        
        return text
    }()
    
    @objc
    private func handleResendTap() {
        events.send(.resend)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let resendLayout = ASStackLayoutSpec.vertical()
        resendLayout.alignItems = .start
        resendLayout.children = [self.resendTextButton]
        
        let layout = ASStackLayoutSpec.vertical()
        layout.spacing = 3
        layout.justifyContent = .spaceBetween
        layout.alignItems = .stretch
        layout.children = [
            getHeaderLayout(),
            getAuthFormLayout(elements: [
                self.headlineText,
                self.resendText,
                self.resendInactiveText,
                self.resendNotReceiveText,
                ASInsetLayoutSpec(
                    insets: UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0),
                    child: resendLayout
                )
            ])
        ]
        
        return ASInsetLayoutSpec(
            insets: DeviceManager.shared.getSafeAreaInsets(),
            child: layout
        )
    }
}
