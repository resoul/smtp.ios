struct User {
    let uuid: String
    let email: String
    let firstName: String
    let lastName: String
    let createdAt: String
    let country: String?
    let state: String?
    let city: String?
    let zip: String?
    let companyName: String?
    let phoneNumber: String?
    let rateLimit: String?
    let SMTPSettings: SMTPSettings
    let permissionObjectCodes: [String]
}
