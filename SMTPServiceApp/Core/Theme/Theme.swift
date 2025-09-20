import UIKit

protocol Theme {
    var type: ThemeType { get }
    var previewIntroPresentationData: PreviewIntroPresentationData { get }
    var authPresentationData: AuthPresentationData { get }
    var mainPresentationData: MainPresentationData { get }
    var userDomainPresentationData: UserDomainPresentationData { get }
}

struct ThemeImpl: Theme {
    let type: ThemeType
    let previewIntroPresentationData: PreviewIntroPresentationData
    let authPresentationData: AuthPresentationData
    let mainPresentationData: MainPresentationData
    let userDomainPresentationData: UserDomainPresentationData
    
    init(
        type: ThemeType,
        previewIntroPresentationData: PreviewIntroPresentationData,
        authPresentationData: AuthPresentationData,
        mainPresentationData: MainPresentationData,
        userDomainPresentationData: UserDomainPresentationData
    ) {
        self.type = type
        self.previewIntroPresentationData = previewIntroPresentationData
        self.authPresentationData = authPresentationData
        self.mainPresentationData = mainPresentationData
        self.userDomainPresentationData = userDomainPresentationData
    }
    
    static let light = ThemeImpl(
        type: .light,
        previewIntroPresentationData: PreviewIntroPresentationData(),
        authPresentationData: AuthPresentationData(),
        mainPresentationData: MainPresentationData(),
        userDomainPresentationData: UserDomainPresentationData()
    )
    
    static let dark = ThemeImpl(
        type: .dark,
        previewIntroPresentationData: PreviewIntroPresentationData(),
        authPresentationData: AuthPresentationData(),
        mainPresentationData: MainPresentationData(),
        userDomainPresentationData: UserDomainPresentationData()
    )
    
    static func custom(
        authData: AuthPresentationData,
        registerWithKey key: String
    ) -> Theme {
        let theme = ThemeImpl(
            type: .custom,
            previewIntroPresentationData: PreviewIntroPresentationData(),
            authPresentationData: authData,
            mainPresentationData: MainPresentationData(),
            userDomainPresentationData: UserDomainPresentationData()
        )
        ThemeRegistry.register(theme: theme, forKey: key)
        return theme
    }
}
