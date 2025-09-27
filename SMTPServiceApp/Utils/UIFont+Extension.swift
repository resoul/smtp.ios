import UIKit

extension UIFont {
    static func poppins(_ style: Fonts.Poppins, size: CGFloat) -> UIFont? {
        return UIFont(name: style.rawValue, size: size)
    }

    static func poppinsWithFallback(
        _ style: Fonts.Poppins,
        size: CGFloat,
        fallback: UIFont.Weight = .regular
    ) -> UIFont {
        return poppins(style, size: size) ?? UIFont.systemFont(ofSize: size, weight: fallback)
    }
}
