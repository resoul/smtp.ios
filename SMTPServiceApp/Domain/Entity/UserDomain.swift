import Foundation

struct UserDomain {
    let uuid: UUID
    let domainName: String
    let state: UserDomainState
    let createdAt: String
    let updatedAt: String
    let spfValid: Bool
    let dkimValid: Bool
    let ownerValid: Bool
    let fblValid: Bool
    let DNSSettings: DNSSettings
}
