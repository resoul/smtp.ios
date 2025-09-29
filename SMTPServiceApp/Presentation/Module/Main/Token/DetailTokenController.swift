import AsyncDisplayKit
import UIKit

final class DetailTokenController: ASDKViewController<ASDisplayNode> {
   private let token: Token
   private let containerNode = ASScrollNode()
   private let contentNode = ASDisplayNode()
   private let closeButtonNode = ASButtonNode()
   private let titleNode = ASTextNode()
   private let tokenDetailsNode = ASDisplayNode()
   private let copyButtonNode = ASButtonNode()
   private let backgroundOverlayNode = ASDisplayNode()

   init(token: Token) {
       self.token = token
       super.init(node: ASDisplayNode())

       setupNodes()
       setupLayout()
   }

   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }

   private func setupNodes() {
       node.backgroundColor = UIColor.black.withAlphaComponent(0.8)
       node.automaticallyManagesSubnodes = true

       // Background overlay for tap to dismiss
       backgroundOverlayNode.backgroundColor = UIColor.clear
       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissController))
       backgroundOverlayNode.view.addGestureRecognizer(tapGesture)

       // Container for the modal content
       contentNode.backgroundColor = UIColor.systemBackground
       contentNode.cornerRadius = 16
       contentNode.automaticallyManagesSubnodes = true

       // Close button
       closeButtonNode.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
//        closeButtonNode.imageNode.imageModificationBlock = { image in
//            return image.withTintColor(UIColor.systemGray2)
//        }
       closeButtonNode.addTarget(self, action: #selector(dismissController), forControlEvents: .touchUpInside)
       closeButtonNode.style.preferredSize = CGSize(width: 32, height: 32)

       // Title
       titleNode.attributedText = NSAttributedString(
           string: "Token Details",
           attributes: [
               NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .bold),
               NSAttributedString.Key.foregroundColor: UIColor.label
           ]
       )

       setupTokenDetails()
   }

   private func setupTokenDetails() {
       tokenDetailsNode.automaticallyManagesSubnodes = true

       let nameNode = createDetailRow(title: "Name", value: token.tokenName)
       let valueNode = createDetailRow(title: "Token Value", value: token.token, isCopyable: true)
       let statusNode = createDetailRow(title: "Status", value: token.state.rawValue)

       let formatter = DateFormatter()
       formatter.dateStyle = .full
       formatter.timeStyle = .medium
//       let createdDateString = formatter.string(from: token.createdAt)
//       let createdNode = createDetailRow(title: "Created", value: createdDateString)

       tokenDetailsNode.layoutSpecBlock = { _, _ in
           return ASStackLayoutSpec(
               direction: .vertical,
               spacing: 24,
               justifyContent: .start,
               alignItems: .stretch,
               children: [nameNode, valueNode, statusNode]
           )
       }
   }

   private func createDetailRow(title: String, value: String, isCopyable: Bool = false) -> ASDisplayNode {
       let rowNode = ASDisplayNode()
       rowNode.automaticallyManagesSubnodes = true

       let titleNode = ASTextNode()
       titleNode.attributedText = NSAttributedString(
           string: title,
           attributes: [
               NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold),
               NSAttributedString.Key.foregroundColor: UIColor.label
           ]
       )

       let valueNode = ASTextNode()
       valueNode.attributedText = NSAttributedString(
           string: value,
           attributes: [
               NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
               NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel
           ]
       )

       if title == "Status" {
           valueNode.attributedText = NSAttributedString(
               string: value,
               attributes: [
                   NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium),
                   NSAttributedString.Key.foregroundColor: UIColor.green
               ]
           )
       }

       var children: [ASLayoutElement] = [titleNode, valueNode]

       if isCopyable {
           let copyButton = ASButtonNode()
           copyButton.setTitle("Copy", with: UIFont.systemFont(ofSize: 14, weight: .medium),
                             with: UIColor.systemBlue, for: .normal)
           copyButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
           copyButton.cornerRadius = 6
           copyButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
           copyButton.addTarget(self, action: #selector(copyTokenValue), forControlEvents: .touchUpInside)

           let buttonWrapper = ASStackLayoutSpec(
               direction: .horizontal,
               spacing: 8,
               justifyContent: .spaceBetween,
               alignItems: .center,
               children: [valueNode, copyButton]
           )

           children = [titleNode, buttonWrapper]
       }

       rowNode.layoutSpecBlock = { _, _ in
           let mainStack = ASStackLayoutSpec(
               direction: .vertical,
               spacing: 8,
               justifyContent: .start,
               alignItems: .stretch,
               children: children
           )

           let backgroundNode = ASDisplayNode()
           backgroundNode.backgroundColor = UIColor.secondarySystemGroupedBackground
           backgroundNode.cornerRadius = 8

           let backgroundSpec = ASBackgroundLayoutSpec(child: mainStack, background: backgroundNode)

           return ASInsetLayoutSpec(
               insets: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16),
               child: backgroundSpec
           )
       }

       return rowNode
   }

   private func setupLayout() {
       contentNode.layoutSpecBlock = { [weak self] _, constrainedSize in
           guard let self = self else { return ASLayoutSpec() }

           let headerStack = ASStackLayoutSpec(
               direction: .horizontal,
               spacing: 16,
               justifyContent: .spaceBetween,
               alignItems: .center,
               children: [self.titleNode, self.closeButtonNode]
           )

           let contentStack = ASStackLayoutSpec(
               direction: .vertical,
               spacing: 24,
               justifyContent: .start,
               alignItems: .stretch,
               children: [headerStack, self.tokenDetailsNode]
           )

           return ASInsetLayoutSpec(
               insets: UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24),
               child: contentStack
           )
       }

       node.layoutSpecBlock = { [weak self] _, constrainedSize in
           guard let self = self else { return ASLayoutSpec() }

           // Position the modal in the center
           let centerSpec = ASCenterLayoutSpec(
               centeringOptions: .XY,
               sizingOptions: [],
               child: self.contentNode
           )

           // Set max width for the modal
           self.contentNode.style.maxWidth = ASDimension(unit: .points, value: min(constrainedSize.max.width - 48, 400))
           self.contentNode.style.minHeight = ASDimension(unit: .points, value: 300)

           return ASOverlayLayoutSpec(child: self.backgroundOverlayNode, overlay: centerSpec)
       }
   }

   @objc private func dismissController() {
       dismiss(animated: true)
   }

   @objc private func copyTokenValue() {
       UIPasteboard.general.string = token.tokenName

       // Provide haptic feedback
       let generator = UIImpactFeedbackGenerator(style: .light)
       generator.impactOccurred()

       // Show a brief success indicator
       showCopySuccessIndicator()
   }

   private func showCopySuccessIndicator() {
       let successLabel = UILabel()
       successLabel.text = "Copied!"
       successLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
       successLabel.textColor = UIColor.systemBackground
       successLabel.backgroundColor = UIColor.label
       successLabel.textAlignment = .center
       successLabel.layer.cornerRadius = 4
       successLabel.clipsToBounds = true
       successLabel.alpha = 0

       view.addSubview(successLabel)
       successLabel.translatesAutoresizingMaskIntoConstraints = false
       NSLayoutConstraint.activate([
           successLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
           successLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
           successLabel.widthAnchor.constraint(equalToConstant: 80),
           successLabel.heightAnchor.constraint(equalToConstant: 32)
       ])

       UIView.animate(withDuration: 0.3, animations: {
           successLabel.alpha = 1
       }) { _ in
           UIView.animate(withDuration: 0.3, delay: 1.0, animations: {
               successLabel.alpha = 0
           }) { _ in
               successLabel.removeFromSuperview()
           }
       }
   }

   override func viewDidLoad() {
       super.viewDidLoad()

       // Add some entrance animation
       contentNode.transform = CATransform3DMakeScale(0.8, 0.8, 1.0)
       contentNode.alpha = 0

       UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
           self.contentNode.transform = CATransform3DIdentity
           self.contentNode.alpha = 1
       }
   }
}
