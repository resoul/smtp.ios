import AsyncDisplayKit
import FontManager
import Combine

final class UserDomainDNSValidationNode: DisplayNode {
    private let hostname: String
    private let type: String
    private let value: String
    
    private lazy var headlineText = ASTextNode()
    private lazy var sublineText = ASTextNode()
    private lazy var hostnamelabel = ASTextNode()
    private lazy var hostnameText = ASTextNode()
    private lazy var typelabel = ASTextNode()
    private lazy var typeText = ASTextNode()
    private lazy var valuelabel = ASTextNode()
    private lazy var valueText = ASTextNode()
    private lazy var backgroundNode = ASDisplayNode()
    
    init(hostname: String, type: String, value: String) {
        self.hostname = hostname
        self.type = type
        self.value = value
        super.init()
        automaticallyManagesSubnodes = true
        setupNodes(themeManager.currentTheme)
    }
    
    override func applyTheme(_ theme: any Theme) {
        setupNodes(theme)
    }
    
    private func setupNodes(_ theme: Theme) {
        backgroundColor = theme.userDomainPresentationData.backgroundColor
        headlineText.attributedText = NSAttributedString(
            string: "Add this entry into your DNS records",
            attributes: [
                .font: UIFont.poppinsWithFallback(.bold, size: 16, fallback: .bold),
                .foregroundColor: theme.userDomainPresentationData.dnsHeadlineTextColor
            ]
        )
        sublineText.attributedText = NSAttributedString(
            string: "Please be aware that DNS changes can take up to 24 hours to propagate, based on your DNS service provider.",
            attributes: [
                .font: UIFont.poppinsWithFallback(.regular, size: 14, fallback: .regular),
                .foregroundColor: theme.userDomainPresentationData.dnsHeadlineTextColor
            ]
        )
        hostnamelabel.attributedText = NSAttributedString(
            string: "HOSTNAME",
            attributes: [
                .font: UIFont.poppinsWithFallback(.bold, size: 14, fallback: .bold),
                .foregroundColor: theme.userDomainPresentationData.dnsHeadlineTextColor
            ]
        )
        hostnameText.attributedText = NSAttributedString(
            string: hostname,
            attributes: [
                .font: UIFont.poppinsWithFallback(.regular, size: 13, fallback: .regular),
                .foregroundColor: theme.userDomainPresentationData.dnsHeadlineTextColor
            ]
        )
        typelabel.attributedText = NSAttributedString(
            string: "TYPE",
            attributes: [
                .font: UIFont.poppinsWithFallback(.bold, size: 14, fallback: .bold),
                .foregroundColor: theme.userDomainPresentationData.dnsHeadlineTextColor
            ]
        )
        typeText.attributedText = NSAttributedString(
            string: type,
            attributes: [
                .font: UIFont.poppinsWithFallback(.regular, size: 13, fallback: .regular),
                .foregroundColor: theme.userDomainPresentationData.dnsHeadlineTextColor
            ]
        )
        valuelabel.attributedText = NSAttributedString(
            string: "VALUE",
            attributes: [
                .font: UIFont.poppinsWithFallback(.bold, size: 14, fallback: .bold),
                .foregroundColor: theme.userDomainPresentationData.dnsHeadlineTextColor
            ]
        )
        valueText.attributedText = NSAttributedString(
            string: value,
            attributes: [
                .font: UIFont.poppinsWithFallback(.regular, size: 13, fallback: .regular),
                .foregroundColor: themeManager.currentTheme.userDomainPresentationData.dnsHeadlineTextColor
            ]
        )
        backgroundNode.backgroundColor = theme.userDomainPresentationData.dnsContentBackgroundColor
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let contentStack = ASStackLayoutSpec.vertical()
        contentStack.spacing = 8
        contentStack.children = [
            headlineText,
            sublineText,
            hostnamelabel,
            hostnameText,
            typelabel,
            typeText,
            valuelabel,
            valueText
        ]
        
        let insentContent = ASInsetLayoutSpec(
            insets: .init(top: 8, left: 8, bottom: 8, right: 8),
            child: contentStack
        )
        
        let backgroundLayout = ASBackgroundLayoutSpec(
            child: insentContent,
            background: backgroundNode
        )

        return ASInsetLayoutSpec(
            insets: .init(top: 15, left: 8, bottom: 15, right: 8),
            child: backgroundLayout
        )
    }
}
