struct AppSettings {
    var mainCurrentTab: Int
}

extension AppSettings {
    func toDTO() -> AppSettingsDTO {
        return AppSettingsDTO(
            mainCurrentTab: mainCurrentTab
        )
    }
}
