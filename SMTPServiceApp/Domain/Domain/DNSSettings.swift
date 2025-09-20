struct DNSSettings {
    let dkimDomain: String
    let ownerValidationToken: String
    let spfCname: UserDomainCNAME
    let dkimSecondCname: UserDomainCNAME
    let dkimFirstCname: UserDomainCNAME
}
