import AsyncDisplayKit

final class CreateTokenController: ASDKViewController<ASDisplayNode> {
    private let containerNode = ASDisplayNode()
    private let titleNode = ASTextNode()
    private var nameTextField = UITextField()
    private let textFieldNode = ASDisplayNode(viewBlock: { UITextField() })
    private let createButtonNode = CreateButtonNode(text: "Create Token")
    private let cancelButtonNode = ASButtonNode()
    
    private let viewModel: TokenViewModel
    var onTokenCreated: (() -> Void)?
    
    init(viewModel: TokenViewModel) {
        self.viewModel = viewModel
        super.init(node: ASDisplayNode())
        node.automaticallyManagesSubnodes = true
        node.layoutSpecBlock = { [weak self] _, _ in
            return self?.layoutSpec() ?? ASLayoutSpec()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNodes()
        setupTextField()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameTextField.becomeFirstResponder()
    }
    
    private func setupNodes() {
        node.backgroundColor = .systemBackground
        
        titleNode.attributedText = NSAttributedString(
            string: "Generate New Token",
            attributes: [
                .font: UIFont.systemFont(ofSize: 24, weight: .bold),
                .foregroundColor: UIColor.label
            ]
        )
        
        cancelButtonNode.setTitle("Cancel", with: UIFont.systemFont(ofSize: 16), with: .secondaryLabel, for: .normal)
        cancelButtonNode.addTarget(self, action: #selector(cancelTapped), forControlEvents: .touchUpInside)
        
        createButtonNode.onTap = { [weak self] in
            self?.createToken()
        }
    }
    
    private func setupTextField() {
        guard let textField = textFieldNode.view as? UITextField else { return }
        nameTextField = textField
        
        textField.placeholder = "Token name"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        textField.delegate = self
    }
    
    private func layoutSpec() -> ASLayoutSpec {
        titleNode.style.flexShrink = 1.0
        
        let headerStack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 16,
            justifyContent: .spaceBetween,
            alignItems: .center,
            children: [titleNode, cancelButtonNode]
        )
        
        textFieldNode.style.height = ASDimension(unit: .points, value: 44)
        
        createButtonNode.style.height = ASDimension(unit: .points, value: 50)
        
        let mainStack = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 24,
            justifyContent: .start,
            alignItems: .stretch,
            children: [headerStack, textFieldNode, createButtonNode]
        )
        
        return ASInsetLayoutSpec(
            insets: UIEdgeInsets(top: 24, left: 16, bottom: 32, right: 16),
            child: mainStack
        )
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    private func createToken() {
        guard let name = nameTextField.text, !name.isEmpty else {
            showError(message: "Please enter a token name")
            return
        }
        
        Task {
            try await viewModel.create(tokenName: name)
            dismiss(animated: true)
        }
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension CreateTokenController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        createToken()
        return true
    }
}
