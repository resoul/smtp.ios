import Foundation

struct UserDomain {
    let uuid: UUID
    let domainName: String
    let state: String
    let createdAt: Date
    let updatedAt: Date
    let spfValid: Bool
    let dkimValid: Bool
    let ownerValid: Bool
    let fblValid: Bool
    let DNSSettings: DNSSettings
}
