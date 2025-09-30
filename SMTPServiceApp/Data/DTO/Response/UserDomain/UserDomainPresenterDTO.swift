import Foundation

struct UserDomainPresenterDTO: Codable {
    let userDomain: UserDomainDTO
}

extension UserDomainPresenterDTO {
    func toDomain() -> UserDomain {
        return UserDomain(
            uuid: userDomain.uuid,
            domainName: userDomain.domainName,
            state: UserDomainState(rawValue: userDomain.state),
            createdAt: userDomain.createdAt,
            updatedAt: userDomain.updatedAt,
            spfValid: userDomain.spfValid,
            dkimValid: userDomain.dkimValid,
            ownerValid: userDomain.ownerValid,
            fblValid: userDomain.fblValid,
            DNSSettings: userDomain.DNSSettings.toDomain()
        )
    }
}
