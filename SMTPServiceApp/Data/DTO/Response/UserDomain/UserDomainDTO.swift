import Foundation

struct UserDomainDTO: Codable {
    let uuid: UUID
    let domainName: String
    let state: String
    let createdAt: String
    let updatedAt: String
    let spfValid: Bool
    let dkimValid: Bool
    let ownerValid: Bool
    let fblValid: Bool
    let DNSSettings: DNSSettingsDTO
}

extension UserDomainDTO {
    func toDomain() -> UserDomain {
        return UserDomain(
            uuid: uuid,
            domainName: domainName,
            state: state,
            createdAt: createdAt,
            updatedAt: updatedAt,
            spfValid: spfValid,
            dkimValid: dkimValid,
            ownerValid: ownerValid,
            fblValid: fblValid,
            DNSSettings: DNSSettings.toDomain()
        )
    }
}
