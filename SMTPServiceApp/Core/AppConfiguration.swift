struct AppConfiguration {
    var analyticsEnabled: Bool = true
    var offlineModeEnabled: Bool = false
    var debugModeEnabled: Bool = false
    var networkConfig: NetworkConfig = .development
    var previewIntoEnabled: Bool = true
}

enum AppEnvironment {
    case development
    case staging
    case production
}

final class AppConfigurationBuilder {
    private var config = AppConfiguration()
    
    func withAnalytics(enabled: Bool) -> AppConfigurationBuilder {
        config.analyticsEnabled = enabled
        return self
    }
    
    func withOfflineMode(enabled: Bool) -> AppConfigurationBuilder {
        config.offlineModeEnabled = enabled
        return self
    }
    
    func withDebugMode(enabled: Bool) -> AppConfigurationBuilder {
        config.debugModeEnabled = enabled
        return self
    }
    
    func withNetworkConfig(_ networkConfig: NetworkConfig) -> AppConfigurationBuilder {
        config.networkConfig = networkConfig
        return self
    }

    func withPreviewInto(enabled: Bool) -> AppConfigurationBuilder { // NEW
        config.previewIntoEnabled = enabled
        return self
    }
    
    func withEnvironment(_ environment: AppEnvironment) -> AppConfigurationBuilder {
        switch environment {
        case .development:
            config.networkConfig = .development
            config.debugModeEnabled = true
            config.analyticsEnabled = false
        case .staging:
            config.networkConfig = .staging
            config.debugModeEnabled = true
            config.analyticsEnabled = false
        case .production:
            config.networkConfig = .production
            config.debugModeEnabled = false
            config.analyticsEnabled = true
        // case .previewinto:
            // config.networkConfig = ... (if needed)
            // config.previewIntoEnabled = true
        }
        return self
    }
    
    func build() -> AppConfiguration {
        return config
    }
}
