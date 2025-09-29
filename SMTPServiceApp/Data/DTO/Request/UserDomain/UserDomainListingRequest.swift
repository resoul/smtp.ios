struct UserDomainListingRequest: Codable {
    let page: Int
    let perPage: Int
    let orderBy: String?
    let orderDirection: String?
    
    init(
        page: Int,
        perPage: Int,
        orderBy: String = "updatedAt",
        orderDirection: String = "desc"
    ) {
        self.page = page
        self.perPage = perPage
        self.orderBy = orderBy
        self.orderDirection = orderDirection
    }
}
