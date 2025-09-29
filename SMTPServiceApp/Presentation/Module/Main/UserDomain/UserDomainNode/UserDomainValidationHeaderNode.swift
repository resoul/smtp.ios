import AsyncDisplayKit
import Combine

final class UserDomainValidationHeaderNode: DisplayNode {
    private let domainName: String
    private let state: String
    private let onDelete: (() -> Void)?
    private let onTest: (() -> Void)?
    
    private lazy var domainNameText = ASTextNode()
    private lazy var statusImageNode = VerifiedMarkNode()
    private lazy var testButton = ButtonInfoNode(text: "Test")
    private lazy var deleteButton: ASButtonNode = {
        let btn = ASButtonNode()
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        let img = UIImage(systemName: "trash", withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
        
        btn.setImage(img, for: .normal)
        btn.tintColor = themeManager.currentTheme.mainPresentationData.deleteIconColor

        return btn
    }()
    
    init(
        domainName: String,
        state: String,
        onDelete: (() -> Void)? = nil,
        onTest: (() -> Void)? = nil
    ) {
        self.domainName = domainName
        self.state = state
        self.onDelete = onDelete
        self.onTest = onTest
        super.init()
        automaticallyManagesSubnodes = true
        statusImageNode.setState(state)
        domainNameText.attributedText = NSAttributedString(
            string: domainName,
            attributes: [
                .font: UIFont.poppinsWithFallback(.bold, size: 17, fallback: .bold),
                .foregroundColor: themeManager.currentTheme.mainPresentationData.mainTextColor
            ]
        )
        testButton.addTarget(self, action: #selector(testTapped), forControlEvents: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteTapped), forControlEvents: .touchUpInside)
        style.height = ASDimension(unit: .points, value: 45)
    }
    
    @objc private func deleteTapped() { onDelete?() }
    @objc private func testTapped() { onTest?() }
    
    override func applyTheme(_ theme: any Theme) {
        domainNameText.attributedText = NSAttributedString(
            string: domainName,
            attributes: [
                .font: UIFont.poppinsWithFallback(.bold, size: 17, fallback: .bold),
                .foregroundColor: themeManager.currentTheme.mainPresentationData.mainTextColor
            ]
        )
        deleteButton.tintColor = themeManager.currentTheme.mainPresentationData.deleteIconColor
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        testButton.style.width = ASDimension(unit: .points, value: 55)
        testButton.style.height = ASDimension(unit: .points, value: 30)
        deleteButton.style.height = ASDimension(unit: .points, value: 24)
        deleteButton.style.width = ASDimension(unit: .points, value: 24)

        let domainLayout = ASStackLayoutSpec.horizontal()
        domainLayout.spacing = 8
        domainLayout.alignItems = .center
        domainLayout.justifyContent = .start
        domainLayout.children = [domainNameText, statusImageNode]
        
        let btnLayout = ASStackLayoutSpec.horizontal()
        btnLayout.spacing = 20
        btnLayout.alignItems = .center
        btnLayout.justifyContent = .spaceBetween
        btnLayout.children = [testButton, deleteButton]
        
        let layout = ASStackLayoutSpec.horizontal()
        layout.spacing = 4
        layout.alignItems = .center
        layout.justifyContent = .spaceBetween
        layout.children = [domainLayout, btnLayout]
        
        return ASInsetLayoutSpec(
            insets: .init(top: 0, left: 0, bottom: 0, right: 8),
            child: layout
        )
    }
}
