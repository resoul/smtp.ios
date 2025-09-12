struct RegistrationRequest: Codable {
    let firstname: String
    let lastname: String
    let email: String
    let password: String
    let passwordConfirmation: String
}
