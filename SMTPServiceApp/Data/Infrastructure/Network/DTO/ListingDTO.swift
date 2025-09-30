struct ListingResponseDTO<T: Codable>: Codable {
    let items: [T]
    let pagination: PaginationResponseDTO
}
