import Foundation

struct UserDTO: Codable {
    let uuid: String
    let email: String
    let firstName: String
    let lastName: String
    let createdAt: Date
    let country: String?
    let state: String?
    let city: String?
    let zip: String?
    let companyName: String?
    let phoneNumber: String?
    let rateLimit: String?
    let SMTPSettings: SMTPSettingsDTO
    let permissionObjectCodes: [String]
}

extension UserDTO {
    func toDomain() -> User {
        return User(
            uuid: uuid,
            email: email,
            firstName: firstName,
            lastName: lastName,
            createdAt: createdAt,
            country: country,
            state: state,
            city: city,
            zip: zip,
            companyName: companyName,
            phoneNumber: phoneNumber,
            rateLimit: rateLimit,
            SMTPSettings: SMTPSettings.toDomain(),
            permissionObjectCodes: permissionObjectCodes
        )
    }
}
