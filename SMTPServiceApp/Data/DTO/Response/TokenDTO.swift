import Foundation

struct TokenDTO: Codable {
    let tokenName: String
    let token: String
    let state: String
    let createdAt: Date
    let expiredAt: Date?
    let updatedAt: Date
}

extension TokenDTO {
    func toDomain() -> Token {
        return Token(
            tokenName: tokenName,
            token: token,
            state: state,
            createdAt: createdAt,
            expiredAt: expiredAt,
            updatedAt: updatedAt
        )
    }
}
