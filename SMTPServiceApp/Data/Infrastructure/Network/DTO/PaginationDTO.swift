struct PaginationResponseDTO: Codable {
    let page: Int
    let perPage: Int
    let itemsOnCurrentPage: Int
    let totalItems: Int
}

extension PaginationResponseDTO {
    func toDomain() -> PaginationResponse {
        return PaginationResponse(
            page: page,
            perPage: perPage,
            itemsOnCurrentPage: itemsOnCurrentPage,
            totalItems: totalItems
        )
    }
}
