import AsyncDisplayKit

final class SubmitButtonNode: ASButtonNode {
    private var onSubmit: (() -> Void)?
    
    init(
        text: String,
        textColor: UIColor = .white,
        textSize: CGFloat = 16,
        backgroundColor: UIColor = UIColor.hex("F8555A"),
        onSubmit: (() -> Void)? = nil
    ) {
        super.init()
        automaticallyManagesSubnodes = true
        self.backgroundColor = backgroundColor
        setTitle(
            text,
            with: UIFont(name: "Poppins-Bold", size: textSize) ?? UIFont.systemFont(ofSize: textSize),
            with: textColor,
            for: .normal
        )
        self.onSubmit = onSubmit
        addTarget(self, action: #selector(handleSubmit), forControlEvents: .touchUpInside)
        style.height = ASDimension(unit: .points, value: 50)
    }
    
    @objc private func handleSubmit() {
        onSubmit?()
    }
}
