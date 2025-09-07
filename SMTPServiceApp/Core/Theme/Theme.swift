import UIKit

protocol Theme {
    var type: ThemeType { get }
    var previewIntroPresentationData: PreviewIntroPresentationData { get }
    var authPresentationData: AuthPresentationData { get }
}

struct ThemeImpl: Theme {
    let type: ThemeType
    let previewIntroPresentationData: PreviewIntroPresentationData
    let authPresentationData: AuthPresentationData
    
    init(
        type: ThemeType,
        previewIntroPresentationData: PreviewIntroPresentationData,
        authPresentationData: AuthPresentationData
    ) {
        self.type = type
        self.previewIntroPresentationData = previewIntroPresentationData
        self.authPresentationData = authPresentationData
    }
    
    static let light = ThemeImpl(
        type: .light,
        previewIntroPresentationData: PreviewIntroPresentationData(),
        authPresentationData: AuthPresentationData()
    )
    
    static let dark = ThemeImpl(
        type: .dark,
        previewIntroPresentationData: PreviewIntroPresentationData(),
        authPresentationData: AuthPresentationData()
    )
    
    static func custom(
        authData: AuthPresentationData,
        registerWithKey key: String
    ) -> Theme {
        let theme = ThemeImpl(
            type: .custom,
            previewIntroPresentationData: PreviewIntroPresentationData(),
            authPresentationData: authData
        )
        ThemeRegistry.register(theme: theme, forKey: key)
        return theme
    }
}
