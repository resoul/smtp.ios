struct SMTPSettings {
    let hostName: String
    let smtpHostName: String
    let port: Int
    let alternativePort: Int
    let spfDomain: String
    let dkimKey: String
    let dkimHostPrefix: String
    let useTls: Bool
}
