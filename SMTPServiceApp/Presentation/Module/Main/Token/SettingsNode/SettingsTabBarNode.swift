import AsyncDisplayKit

final class SettingsTabBarNode: ASDisplayNode {
    private var buttons: [ASButtonNode] = []
    private let stackNode = ASStackLayoutSpec.horizontal()
    private let indicator = ASDisplayNode()

    private(set) var selectedIndex: Int = 0
    var onTabSelected: ((Int) -> Void)?

    init(titles: [String]) {
        super.init()
        automaticallyManagesSubnodes = true
        automaticallyRelayoutOnSafeAreaChanges = true

        // создаём кнопки
        buttons = titles.map { title in
            let button = ASButtonNode()
            button.backgroundColor = .clear
            button.setTitle(title,
                            with: UIFont.poppinsWithFallback(.regular, size: 16),
                            with: UIColor.hex("404040"),
                            for: .normal)
            return button
        }

        // назначаем обработчики
        for (index, button) in buttons.enumerated() {
            button.addTarget(self, action: #selector(tabTapped(_:)), forControlEvents: .touchUpInside)
            button.accessibilityValue = "\(index)" // используем для идентификации
        }

        // индикатор
        indicator.backgroundColor = UIColor.hex("3F51B5")
        indicator.style.height = .init(unit: .points, value: 3)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        stackNode.children = buttons
        stackNode.justifyContent = .start
        stackNode.spacing = 8
        stackNode.alignItems = .stretch

        let content = ASInsetLayoutSpec(insets: .zero, child: stackNode)

        return content
    }

    override func didLoad() {
        super.didLoad()
        layer.addSublayer(indicator.layer)
    }
    
    override func layout() {
        super.layout()
        updateIndicatorPosition(animated: false)
    }

    @objc private func tabTapped(_ sender: ASButtonNode) {
        guard let value = sender.accessibilityValue,
              let index = Int(value) else { return }

        selectedIndex = index
        updateIndicatorPosition(animated: true)
        onTabSelected?(index)
    }

    private func updateIndicatorPosition(animated: Bool) {
        guard selectedIndex < buttons.count else { return }
        let buttonView = buttons[selectedIndex].view

        let buttonFrame = buttonView.convert(buttonView.bounds, to: view)

        let indicatorFrame = CGRect(
            x: buttonFrame.minX,
            y: bounds.height - 2,
            width: buttonFrame.width,
            height: 2
        )

        if animated {
            UIView.animate(withDuration: 0.25,
                           delay: 0,
                           options: [.curveEaseInOut],
                           animations: {
                self.indicator.layer.frame = indicatorFrame
            })
        } else {
            indicator.layer.frame = indicatorFrame
        }
    }
}
