import UIKit

final class AppThemeSetup {
    static func setupCustomThemes() {
        let emSmtp = ThemeImpl(
            type: .custom,
            previewIntroPresentationData: PreviewIntroPresentationData(),
            authPresentationData: AuthPresentationData(),
            mainPresentationData: MainPresentationData(),
            userDomainPresentationData: UserDomainPresentationData()
        )
        
        ThemeRegistry.register(theme: emSmtp, forKey: "em.smtp.theme.emercury")
    }
}
