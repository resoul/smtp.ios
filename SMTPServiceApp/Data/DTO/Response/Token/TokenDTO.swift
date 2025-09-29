import UIKit

struct TokenDTO: Codable {
    let tokenName: String
    let token: String
    let state: String
    let createdAt: String
    let expiredAt: String?
    let updatedAt: String
}

extension TokenDTO {
    func toDomain() -> Token {
        return Token(
            tokenName: tokenName,
            token: token,
            state: TokenState(rawValue: state),
            createdAt: createdAt,
            expiredAt: expiredAt,
            updatedAt: updatedAt
        )
    }
}
