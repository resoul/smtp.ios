import UIKit

extension UITextField {
    
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }

    func setRightPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }

    func setRightPaddingPointsWithView(_ button: UIButton, width: CGFloat = 44) {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 44))
        button.frame = CGRect(x: 0, y: 0, width: width, height: 44)
        container.addSubview(button)
        
        self.rightView = container
        self.rightViewMode = .always
    }
}
