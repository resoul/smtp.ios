import UIKit

final class AppThemeSetup {
    static func setupCustomThemes() {
        let emSmtp = ThemeImpl(
            type: .custom,
            previewIntroPresentationData: PreviewIntroPresentationData(),
            authPresentationData: AuthPresentationData()
        )
        
        ThemeRegistry.register(theme: emSmtp, forKey: "em.smtp.theme.emercury")
    }
}
