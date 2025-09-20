struct DNSSettingsDTO: Codable {
    let dkimDomain: String
    let ownerValidationToken: String
    let spfCname: UserDomainCNAMEDTO
    let dkimSecondCname: UserDomainCNAMEDTO
    let dkimFirstCname: UserDomainCNAMEDTO
}

extension DNSSettingsDTO {
    func toDomain() -> DNSSettings {
        return DNSSettings(
            dkimDomain: dkimDomain,
            ownerValidationToken: ownerValidationToken,
            spfCname: spfCname.toDomain(),
            dkimSecondCname: dkimSecondCname.toDomain(),
            dkimFirstCname: dkimFirstCname.toDomain()
        )
    }
}
