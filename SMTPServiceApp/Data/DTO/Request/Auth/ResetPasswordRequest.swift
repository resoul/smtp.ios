struct ResetPasswordRequest: Codable {
    let resetToken: String
    let password: String
    let passwordConfirmation: String
}
