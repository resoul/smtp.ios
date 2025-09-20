struct UserDomainCNAMEDTO: Codable {
    let hostname: String
    let pointTo: String
}

extension UserDomainCNAMEDTO {
    func toDomain() -> UserDomainCNAME {
        return UserDomainCNAME(
            hostname: hostname,
            pointTo: pointTo
        )
    }
}
