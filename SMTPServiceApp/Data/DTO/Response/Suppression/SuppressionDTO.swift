import Foundation

struct SuppressionDTO: Codable {
    let suppressionId: Int
    let email: String
    let type: String
    let domainName: String?
    let createdAt: String
    let updatedAt: String
}

extension SuppressionDTO {
    func toDomain() -> Suppression {
        return Suppression(
            suppressionId: suppressionId,
            email: email,
            type: SuppressionType(rawValue: type),
            domainName: domainName ?? "*",
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
