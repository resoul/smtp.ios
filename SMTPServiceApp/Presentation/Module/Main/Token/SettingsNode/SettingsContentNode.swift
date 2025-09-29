import AsyncDisplayKit

final class SettingsContentNode: ASCellNode {
    private var tab: TokenViewModel.SettingsTab
    private let token: Token?
    private let user: User?
    private let hintText = ASTextNode()
    private var settingsNodes: [ASDisplayNode] = []
    
    init(tab: TokenViewModel.SettingsTab, token: Token?, user: User?) {
        self.tab = tab
        self.token = token
        self.user = user
        super.init()
        automaticallyManagesSubnodes = true
        selectionStyle = .none
        setupNodes()
    }
    
    private func setupNodes() {
        let description = tab == .smtp ? "Use the info below to set up your SMTP client to relay through Emercury SMTP." : "Use the info below to set up your SMTP HTTP API client."
        
        hintText.attributedText = NSAttributedString(
            string: description,
            attributes: [
                NSAttributedString.Key.font: UIFont.poppinsWithFallback(.regular, size: 14),
                NSAttributedString.Key.foregroundColor: UIColor.hex("071437")
            ]
        )

        switch tab {
        case .smtp:
            smtpContent()
        case .apiDetails:
            apiDetailsContent()
        }
    }
    
    private func smtpContent() {
        let settings = [
            ("Host:", "smtp.test.emercury.dev"),
            ("Port:", "587 (Alternative Port: 2525)"),
            ("Authentication:", "AUTH LOGIN"),
            ("Encryption:", "STARTTLS"),
            ("Username:", user?.email ?? ""),
            ("Password:", token?.token ?? "")
        ]

        settingsNodes = settings.map { createSettingRow(label: $0.0, value: $0.1) }
    }
    
    private func apiDetailsContent() {
        let settings = [
            ("Host:", "api.smtp.emercury.net"),
            ("X-Emercury-Token:", token?.token ?? "")
        ]

        settingsNodes = settings.map { createSettingRow(label: $0.0, value: $0.1) }
    }
    
    private func createSettingRow(label: String, value: String) -> ASDisplayNode {
        let rowNode = ASDisplayNode()
        rowNode.automaticallyManagesSubnodes = true
        
        var copyButton: ASButtonNode?
        var truncatedValue: String?
        if label == "Password:" || label == "X-Emercury-Token:" {
            copyButton = ASButtonNode()
            copyButton?.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
            copyButton?.addTarget(self, action: #selector(copyPassword), forControlEvents: .touchUpInside)
            copyButton?.style.preferredSize = CGSize(width: 24, height: 24)
            
            truncatedValue = value.count > 25 ? String(value.prefix(25)) + "..." : value
        }

        let labelNode = ASTextNode()
        labelNode.attributedText = NSAttributedString(
            string: label,
            attributes: [
                .font: UIFont.poppinsWithFallback(.medium, size: 14),
                .foregroundColor: UIColor.hex("99A1B7")
            ]
        )
        labelNode.style.width = ASDimension(unit: .points, value: 120)

        let valueNode = ASTextNode()
        valueNode.maximumNumberOfLines = 0
        valueNode.attributedText = NSAttributedString(
            string: truncatedValue ?? value,
            attributes: [
                NSAttributedString.Key.font: UIFont.poppinsWithFallback(.regular, size: 12),
                NSAttributedString.Key.foregroundColor: UIColor.hex("252F4A")
            ]
        )
        
        rowNode.layoutSpecBlock = { _, _ in
            var children: [ASLayoutElement] = [labelNode, valueNode]
            if let button = copyButton {
                children.append(button)
            }
            
            let horizontalStack = ASStackLayoutSpec(
                direction: .horizontal,
                spacing: 12,
                justifyContent: .start,
                alignItems: .center,
                children: children
            )

            return ASInsetLayoutSpec(
                insets: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0),
                child: horizontalStack
            )
        }

        return rowNode
    }
    
    @objc private func copyPassword() {
        UIPasteboard.general.string = token?.token ?? ""
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        var children: [ASLayoutElement] = []
        children.append(contentsOf: settingsNodes)
        
        let settingsStack = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 4,
            justifyContent: .start,
            alignItems: .stretch,
            children: children
        )

        return ASInsetLayoutSpec(
            insets: .init(top: 16, left: 16, bottom: 16, right: 16),
            child: ASStackLayoutSpec(
                direction: .vertical,
                spacing: 8,
                justifyContent: .start,
                alignItems: .stretch,
                children: [
                    hintText,
                    ASInsetLayoutSpec(
                        insets: .init(top: 6, left: 6, bottom: 6, right: 6),
                        child: settingsStack
                    )
                ]
            )
        )
    }
}
