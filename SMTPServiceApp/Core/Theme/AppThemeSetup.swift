import Foundation

final class AppThemeSetup {
    static func setupCustomThemes() {
        let emSmtp = ThemeImpl(
            type: .custom,
            previewIntroPresentationData: PreviewIntroPresentationData(),
            authPresentationData: AuthPresentationData(
                backgroundColor: .black,
                formBackgroundColor: .black,
                headlineColor: .black,
                textColor: .black,
                textLinkColor: .black
            )
        )
        
        ThemeRegistry.register(theme: emSmtp, forKey: "em.smtp")
    }
}
