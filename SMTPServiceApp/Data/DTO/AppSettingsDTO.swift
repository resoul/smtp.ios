struct AppSettingsDTO: Codable {
    var mainCurrentTab: Int
}

extension AppSettingsDTO {
    func toDomain() -> AppSettings {
        return AppSettings(
            mainCurrentTab: mainCurrentTab
        )
    }
}
