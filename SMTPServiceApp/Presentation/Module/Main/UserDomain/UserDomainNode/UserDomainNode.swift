import AsyncDisplayKit
import FontManager
import Combine

final class UserDomainNode: DisplayNode {
    private let userDomain: UserDomain
    private var items: [ASDisplayNode] = []
    
    init(userDomain: UserDomain, onDelete: (() -> Void)? = nil, onTest: (() -> Void)? = nil) {
        self.userDomain = userDomain
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
                contentNode: {
                    UserDomainDNSValidationNode(
                        hostname: "*",
                        type: "TXT",
                        value: "v=spf1 include:srw1.em01.net ~all"
                    )
                },
                onSettingsButtonPressed: {
                    print("spf")
                }
            ),
            UserDomainValidationLineNode(
                headline: "DKIM settings from SMTP Relay",
                isValid: userDomain.dkimValid,
                contentNode: {
                    UserDomainDNSValidationNode(
                        hostname: "em1._domainkey.google.com",
                        type: "TXT",
                        value: "xxx"
                    )
                },
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
                isValid: userDomain.state != "DISABLED",
                onSettingsButtonPressed: {
                    print("admin")
                }
            )
        ]
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
