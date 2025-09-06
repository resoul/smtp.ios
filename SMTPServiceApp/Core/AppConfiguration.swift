struct AppConfiguration {
    var analyticsEnabled: Bool = true
    var offlineModeEnabled: Bool = false
    var debugModeEnabled: Bool = false
}

enum AppEnvironment {
    case development
    case staging
    case production
}

final class AppConfigurationBuilder {
    private var config = AppConfiguration()
    
    //MARK: - TODO Network Config
    func withEnvironment(_ environment: AppEnvironment) -> AppConfigurationBuilder {
        switch environment {
        case .development:
            config.debugModeEnabled = true
            config.analyticsEnabled = false
        case .staging:
            config.debugModeEnabled = true
            config.analyticsEnabled = false
        case .production:
            config.debugModeEnabled = false
            config.analyticsEnabled = true
        }
        return self
    }
    
    func build() -> AppConfiguration {
        return config
    }
}
