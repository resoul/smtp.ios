import AsyncDisplayKit
import Combine

final class UserDomainNode: DisplayNode {
    private let userDomain: UserDomain
    private let user: User?
    private var items: [ASDisplayNode] = []
    
    init(user: User?, userDomain: UserDomain, onDelete: (() -> Void)? = nil, onTest: (() -> Void)? = nil) {
        self.userDomain = userDomain
        self.user = user
        let header = UserDomainValidationHeaderNode(
            domainName: userDomain.domainName,
            state: userDomain.state,
            onDelete: onDelete,
            onTest: onTest
        )
        super.init()
        automaticallyManagesSubnodes = true
        items = [
            header,
            UserDomainValidationLineNode(
                headline: "SPF settings from SMTP Relay",
                isValid: userDomain.spfValid,
                contentNode: { self.getSPF() },
                onSettingsButtonPressed: {
                    print("spf")
                }
            ),
            UserDomainValidationLineNode(
                headline: "DKIM settings from SMTP Relay",
                isValid: userDomain.dkimValid,
                contentNode: { self.getDKIM() },
                onSettingsButtonPressed: {
                    print("dkim")
                }
            ),
            UserDomainValidationLineNode(
                headline: "Domain Validation settings from SMTP Relay",
                isValid: userDomain.ownerValid,
                contentNode: {
                    UserDomainDNSValidationNode(
                        hostname: userDomain.domainName,
                        type: "TXT",
                        value: userDomain.DNSSettings.ownerValidationToken
                    )
                },
                onSettingsButtonPressed: {
                    print("validation")
                }
            ),
            UserDomainValidationLineNode(
                headline: "FBL Verification",
                isValid: userDomain.fblValid,
                onSettingsButtonPressed: {
                    print("fbl")
                }
            ),
            UserDomainValidationLineNode(
                headline: "Admin Approval",
                isValid: userDomain.state != .disabled,
                onSettingsButtonPressed: {
                    print("admin")
                }
            )
        ]
    }
    
    private func getDKIM() -> UserDomainDNSValidationNode {
        guard let user = user else {
            return UserDomainDNSValidationNode(
                hostname: "em1._domainkey.",
                type: "TXT",
                value: "xxx"
            )
        }
        
        return UserDomainDNSValidationNode(
            hostname: "\(user.SMTPSettings.dkimHostPrefix).\(userDomain.domainName)",
            type: "TXT",
            value: user.SMTPSettings.dkimKey
        )
    }
    
    private func getSPF() -> UserDomainDNSValidationNode {
        guard let user = user else {
            return UserDomainDNSValidationNode(
                hostname: "*",
                type: "TXT",
                value: "v=spf1 include: ~all"
            )
        }
        
        return UserDomainDNSValidationNode(
            hostname: "*",
            type: "TXT",
            value: "v=spf1 include:\(user.SMTPSettings.spfDomain) ~all"
        )
    }
    
    override func applyTheme(_ theme: any Theme) {
        backgroundColor = theme.userDomainPresentationData.backgroundColor
        layer.borderWidth = 1
        layer.borderColor = theme.mainPresentationData.mainBorderColor
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let layout = ASStackLayoutSpec.vertical()
        layout.spacing = 11
        layout.children = items

        return ASInsetLayoutSpec(
            insets: .init(top: 8, left: 16, bottom: 8, right: 8),
            child: layout
        )
    }
}
