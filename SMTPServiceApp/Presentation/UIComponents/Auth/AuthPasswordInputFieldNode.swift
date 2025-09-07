import AsyncDisplayKit

final class AuthPasswordInputFieldNode: AuthInputFieldNode {
    private let toggleButton = UIButton(type: .system)
    
    init(labelText: String) {
        super.init(labelText: labelText, isSecure: true)
        setupToggleButton()
        textFieldNode.style.height = ASDimension(unit: .points, value: 44)
    }
    
    private func setupToggleButton() {
        toggleButton.setImage(UIImage(systemName: "eye"), for: .normal)
        toggleButton.tintColor = .gray
        toggleButton.addTarget(self, action: #selector(toggleSecureEntry), for: .touchUpInside)
        
        textField.setRightPaddingPointsWithView(toggleButton, width: 44)
    }
    
    @objc
    private func toggleSecureEntry() {
        textField.isSecureTextEntry.toggle()
        let imageName = textField.isSecureTextEntry ? "eye" : "eye.slash"
        toggleButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
