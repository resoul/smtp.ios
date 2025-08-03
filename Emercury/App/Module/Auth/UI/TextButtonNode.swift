import AsyncDisplayKit

final class TextButtonNode: ASButtonNode {
    private var onSubmit: (() -> Void)?
    
    init(
        text: String,
        textColor: UIColor = .white,
        textSize: CGFloat = 14,
        backgroundColor: UIColor = .clear,
        onSubmit: (() -> Void)? = nil
    ) {
        super.init()
        automaticallyManagesSubnodes = true
        contentEdgeInsets = .zero
        self.backgroundColor = backgroundColor
        setAttributedTitle(
            NSAttributedString(
                string: text,
                attributes: [
                    .font: UIFont(name: "Poppins-Regular", size: textSize) ?? UIFont.systemFont(ofSize: textSize),
                    .foregroundColor: textColor,
                    .underlineStyle: NSUnderlineStyle.single.rawValue
                ]
            ),
            for: .normal
        )
        self.onSubmit = onSubmit
        isUserInteractionEnabled = false
        addTarget(self, action: #selector(handleSubmit), forControlEvents: .touchUpInside)
    }
    
    @objc private func handleSubmit() {
        onSubmit?()
    }
}
