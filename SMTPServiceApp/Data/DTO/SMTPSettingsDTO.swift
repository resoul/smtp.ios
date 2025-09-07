struct SMTPSettingsDTO: Codable {
    let hostName: String
    let smtpHostName: String
    let port: Int
    let alternativePort: Int
    let spfDomain: String
    let dkimKey: String
    let dkimHostPrefix: String
    let useTls: Bool
}

extension SMTPSettingsDTO {
    func toDomain() -> SMTPSettings {
        return SMTPSettings(
            hostName: hostName,
            smtpHostName: smtpHostName,
            port: port,
            alternativePort: alternativePort,
            spfDomain: spfDomain,
            dkimKey: dkimKey,
            dkimHostPrefix: dkimHostPrefix,
            useTls: useTls
        )
    }
}
