import AsyncDisplayKit
import Combine
import FontManager

enum PasswordStrength: Int, CaseIterable {
    case veryWeak = 0
    case weak = 1
    case medium = 2
    case strong = 3
    case veryStrong = 4
    
    var title: String {
        switch self {
        case .veryWeak: return "Very Weak"
        case .weak: return "Weak"
        case .medium: return "Medium"
        case .strong: return "Strong"
        case .veryStrong: return "Very Strong"
        }
    }
    
    var color: UIColor {
        switch self {
        case .veryWeak: return .systemRed
        case .weak: return .systemOrange
        case .medium: return .systemYellow
        case .strong: return .systemBlue
        case .veryStrong: return .systemGreen
        }
    }
    
    var requirements: [String] {
        switch self {
        case .veryWeak, .weak:
            return [
                "At least 8 characters",
                "Mix of letters and numbers",
                "At least one uppercase letter"
            ]
        case .medium:
            return [
                "At least one special character",
                "Mix of uppercase and lowercase"
            ]
        case .strong, .veryStrong:
            return ["Password meets all security requirements"]
        }
    }
}

final class PasswordStrengthNode: ASDisplayNode {
    
    // MARK: - Properties
    private let themeManager: ThemeManager = .shared
    private var currentStrength: PasswordStrength = .veryWeak
    
    // MARK: - UI Elements
    private lazy var strengthLabel: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(
            string: "Password Strength",
            attributes: [
                .font: UIFont.poppinsWithFallback(.medium, size: 14),
                .foregroundColor: themeManager.currentTheme.authPresentationData.textColor
            ]
        )
        return node
    }()
    
    private lazy var strengthValueLabel: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(
            string: PasswordStrength.veryWeak.title,
            attributes: [
                .font: UIFont.poppinsWithFallback(.regular, size: 14),
                .foregroundColor: PasswordStrength.veryWeak.color,
            ]
        )
//        updateStrengthValueLabel(.veryWeak)
        return node
    }()
    
    private lazy var strengthBars: [ASDisplayNode] = {
        return (0..<4).map { _ in
            let bar = ASDisplayNode()
            bar.backgroundColor = UIColor.systemGray5
            bar.cornerRadius = 2
            bar.style.height = ASDimension(unit: .points, value: 4)
            bar.style.flexGrow = 1
            return bar
        }
    }()
    
    private lazy var requirementsContainer: ASDisplayNode = {
        let node = ASDisplayNode()
        node.automaticallyManagesSubnodes = true
        return node
    }()
    
    private var requirementNodes: [RequirementNode] = []
    
    // MARK: - Initialization
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        setupRequirementNodes()
        layoutSpecBlock = { [weak self] _, _ in
            return self?.layoutSpec() ?? ASLayoutSpec()
        }
    }
    
    // MARK: - Public Methods
    func updatePassword(_ password: String) {
        let strength = calculatePasswordStrength(password)
        updateStrengthDisplay(strength)
        updateRequirements(password, strength: strength)
        currentStrength = strength
    }
    
    func hideRequirements() {
        requirementsContainer.isHidden = true
        setNeedsLayout()
    }
    
    func showRequirements() {
        requirementsContainer.isHidden = false
        setNeedsLayout()
    }
    
    // MARK: - Private Methods
    private func setupRequirementNodes() {
        let allRequirements = [
            "At least 8 characters",
            "At least one uppercase letter",
            "At least one lowercase letter",
            "At least one number",
            "At least one special character"
        ]
        
        requirementNodes = allRequirements.map { requirement in
            RequirementNode(text: requirement)
        }
        
        requirementsContainer.layoutSpecBlock = { [weak self] _, _ in
            guard let self = self else { return ASLayoutSpec() }
            
            let stack = ASStackLayoutSpec.vertical()
            stack.spacing = 6
            stack.children = self.requirementNodes
            
            return ASInsetLayoutSpec(
                insets: UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0),
                child: stack
            )
        }
    }
    
    private func calculatePasswordStrength(_ password: String) -> PasswordStrength {
        var score = 0
        
        // Length check
        if password.count >= 8 { score += 1 }
        if password.count >= 12 { score += 1 }
        
        // Character variety checks
        if password.range(of: "[A-Z]", options: .regularExpression) != nil { score += 1 }
        if password.range(of: "[a-z]", options: .regularExpression) != nil { score += 1 }
        if password.range(of: "[0-9]", options: .regularExpression) != nil { score += 1 }
        if password.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil { score += 1 }
        
        // Penalty for common patterns
        if isCommonPassword(password) { score -= 2 }
        if hasRepeatingChars(password) { score -= 1 }
        
        // Ensure score is within valid range
        score = max(0, min(score, 4))
        
        return PasswordStrength(rawValue: score) ?? .veryWeak
    }
    
    private func isCommonPassword(_ password: String) -> Bool {
        let commonPasswords = [
            "password", "123456", "123456789", "12345678",
            "qwerty", "abc123", "password123", "admin",
            "letmein", "welcome", "monkey", "dragon"
        ]
        return commonPasswords.contains(password.lowercased())
    }
    
    private func hasRepeatingChars(_ password: String) -> Bool {
        let chars = Array(password)
        guard chars.count > 1 else { return false }
        
        var consecutiveCount = 1
        
        for i in 1..<chars.count {
            if chars[i] == chars[i-1] {
                consecutiveCount += 1
                if consecutiveCount >= 3 { return true }
            } else {
                consecutiveCount = 1
            }
        }
        return false
    }
    
    private func updateStrengthDisplay(_ strength: PasswordStrength) {
        updateStrengthValueLabel(strength)
        updateStrengthBars(strength)
    }
    
    private func updateStrengthValueLabel(_ strength: PasswordStrength) {
        strengthValueLabel.attributedText = NSAttributedString(
            string: strength.title,
            attributes: [
                .font: UIFont.poppinsWithFallback(.regular, size: 14),
                .foregroundColor: strength.color
            ]
        )
    }
    
    private func updateStrengthBars(_ strength: PasswordStrength) {
        for (index, bar) in strengthBars.enumerated() {
            let shouldHighlight = index <= strength.rawValue
            
            UIView.animate(withDuration: 0.3) {
                bar.backgroundColor = shouldHighlight ? strength.color : UIColor.systemGray5
            }
        }
    }
    
    private func updateRequirements(_ password: String, strength: PasswordStrength) {
        let requirements = [
            password.count >= 8,
            password.range(of: "[A-Z]", options: .regularExpression) != nil,
            password.range(of: "[a-z]", options: .regularExpression) != nil,
            password.range(of: "[0-9]", options: .regularExpression) != nil,
            password.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil
        ]
        
        for (index, node) in requirementNodes.enumerated() {
            node.updateStatus(requirements[index])
        }
    }
    
    private func layoutSpec() -> ASLayoutSpec {
        // Header with strength label and value
        let headerStack = ASStackLayoutSpec.horizontal()
        headerStack.justifyContent = .spaceBetween
        headerStack.alignItems = .center
        headerStack.children = [strengthLabel, strengthValueLabel]
        
        // Strength bars
        let barsStack = ASStackLayoutSpec.horizontal()
        barsStack.spacing = 4
        barsStack.alignItems = .stretch
        barsStack.children = strengthBars
        
        // Main vertical stack
        let mainStack = ASStackLayoutSpec.vertical()
        mainStack.spacing = 8
        mainStack.children = [
            headerStack,
            barsStack,
            requirementsContainer
        ]
        
        return mainStack
    }
}

// MARK: - RequirementNode
private final class RequirementNode: ASDisplayNode {
    private let iconNode: ASImageNode
    private let textNode: ASTextNode
    private let text: String
    
    init(text: String) {
        self.text = text
        
        iconNode = ASImageNode()
        iconNode.image = UIImage(systemName: "circle")
        iconNode.tintColor = .systemGray4
        iconNode.style.preferredSize = CGSize(width: 12, height: 12)
        
        textNode = ASTextNode()
        textNode.attributedText = NSAttributedString(
            string: text,
            attributes: [
                .font: UIFont.poppinsWithFallback(.regular, size: 12),
                .foregroundColor: UIColor.systemGray
            ]
        )
        
        super.init()
        automaticallyManagesSubnodes = true
        
        layoutSpecBlock = { [weak self] _, _ in
            return self?.layoutSpec() ?? ASLayoutSpec()
        }
    }
    
    func updateStatus(_ isMet: Bool) {
        let imageName = isMet ? "checkmark.circle.fill" : "circle"
        let color = isMet ? UIColor.systemGreen : UIColor.systemGray4
        let textColor = isMet ? UIColor.systemGreen : UIColor.systemGray
        
        iconNode.image = UIImage(systemName: imageName)
        iconNode.tintColor = color
        
        textNode.attributedText = NSAttributedString(
            string: text,
            attributes: [
                .font: UIFont.poppinsWithFallback(.regular, size: 12),
                .foregroundColor: textColor
            ]
        )
    }
    
    private func layoutSpec() -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.horizontal()
        stack.spacing = 8
        stack.alignItems = .center
        stack.children = [iconNode, textNode]
        
        return stack
    }
}
