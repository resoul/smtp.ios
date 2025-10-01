struct SuppressionListingRequest: Codable {
    let page: Int
    let perPage: Int
    let dateFrom: String
    let dateTo: String
    let orderBy: String?
    let orderDirection: String?
    
    init(
        page: Int,
        perPage: Int,
        dateFrom: String,
        dateTo: String,
        orderBy: String = "updatedAt",
        orderDirection: String = "desc"
    ) {
        self.page = page
        self.perPage = perPage
        self.dateFrom = dateFrom
        self.dateTo = dateTo
        self.orderBy = orderBy
        self.orderDirection = orderDirection
    }
}
