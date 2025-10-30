import Foundation

/// Represents a paginated response from the API
///
/// Usage:
/// ```swift
/// struct TokenListResponse: Codable {
///     let tokens: [Token]
///     let pagination: PaginationInfo
/// }
/// ```
struct PaginationInfo: Codable {
    let currentPage: Int
    let totalPages: Int
    let pageSize: Int
    let totalItems: Int
    let hasNextPage: Bool
    let hasPreviousPage: Bool
    
    var isFirstPage: Bool { currentPage == 1 }
    var isLastPage: Bool { currentPage == totalPages }
}

/// Manages pagination state for list-based features
///
/// This class handles loading pages, tracking state, and preventing duplicate requests.
///
/// Usage:
/// ```swift
/// let paginator = Paginator<Token> { page, pageSize in
///     try await repository.fetchTokens(page: page, pageSize: pageSize)
/// }
///
/// let tokens = try await paginator.loadNextPage()
/// ```
@MainActor
final class Paginator<Item> {
    
    // MARK: - Properties
    
    /// All loaded items across all pages
    private(set) var items: [Item] = []
    
    /// Current pagination state
    private(set) var state: PaginationState = .idle
    
    /// Current page information
    private(set) var paginationInfo: PaginationInfo?
    
    /// Page size for requests
    let pageSize: Int
    
    /// Fetch closure that loads a page of data
    private let fetchPage: (Int, Int) async throws -> PaginatedResponse<Item>
    
    // MARK: - Initialization
    
    /// Creates a new paginator
    /// - Parameters:
    ///   - pageSize: Number of items per page (default: 20)
    ///   - fetchPage: Async closure that fetches a page of data
    init(
        pageSize: Int = 20,
        fetchPage: @escaping (Int, Int) async throws -> PaginatedResponse<Item>
    ) {
        self.pageSize = pageSize
        self.fetchPage = fetchPage
    }
    
    // MARK: - Public Methods
    
    /// Loads the first page (or refreshes)
    /// - Returns: Array of items from the first page
    @discardableResult
    func loadFirstPage() async throws -> [Item] {
        guard state != .loading else {
            Logger.data.debug("Pagination: Ignoring loadFirstPage - already loading")
            return items
        }
        
        state = .loading
        items.removeAll()
        
        do {
            let response = try await fetchPage(1, pageSize)
            items = response.items
            paginationInfo = response.pagination
            
            state = response.pagination.hasNextPage ? .hasMore : .completed
            
            Logger.data.info("Pagination: Loaded first page", metadata: [
                "items_count": items.count,
                "has_more": response.pagination.hasNextPage
            ])
            
            return items
        } catch {
            state = .error(error)
            Logger.data.error("Pagination: Failed to load first page", error: error)
            throw error
        }
    }
    
    /// Loads the next page if available
    /// - Returns: Array of newly loaded items
    @discardableResult
    func loadNextPage() async throws -> [Item] {
        guard state == .hasMore else {
            Logger.data.debug("Pagination: No more pages to load")
            return []
        }
        
        guard let currentInfo = paginationInfo else {
            Logger.data.warning("Pagination: Cannot load next page - no pagination info")
            return []
        }
        
        state = .loading
        let nextPage = currentInfo.currentPage + 1
        
        do {
            let response = try await fetchPage(nextPage, pageSize)
            items.append(contentsOf: response.items)
            paginationInfo = response.pagination
            
            state = response.pagination.hasNextPage ? .hasMore : .completed
            
            Logger.data.info("Pagination: Loaded next page", metadata: [
                "page": nextPage,
                "new_items_count": response.items.count,
                "total_items": items.count,
                "has_more": response.pagination.hasNextPage
            ])
            
            return response.items
        } catch {
            state = .error(error)
            Logger.data.error("Pagination: Failed to load next page", error: error, metadata: [
                "page": nextPage
            ])
            throw error
        }
    }
    
    /// Checks if should load more items based on current scroll position
    /// - Parameter index: Current index being displayed
    /// - Returns: True if should trigger next page load
    func shouldLoadMore(currentIndex index: Int) -> Bool {
        // Load next page when user scrolls to 80% of current items
        let threshold = Int(Double(items.count) * 0.8)
        return index >= threshold && state == .hasMore
    }
    
    /// Resets the paginator to initial state
    func reset() {
        items.removeAll()
        paginationInfo = nil
        state = .idle
        Logger.data.debug("Pagination: Reset")
    }
    
    /// Returns whether the paginator is currently loading
    var isLoading: Bool {
        if case .loading = state {
            return true
        }
        return false
    }
    
    /// Returns whether there are more pages to load
    var hasMore: Bool {
        if case .hasMore = state {
            return true
        }
        return false
    }
}

// MARK: - Pagination State

enum PaginationState: Equatable {
    case idle
    case loading
    case hasMore
    case completed
    case error(Error)
    
    static func == (lhs: PaginationState, rhs: PaginationState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle),
             (.loading, .loading),
             (.hasMore, .hasMore),
             (.completed, .completed):
            return true
        case (.error, .error):
            return true
        default:
            return false
        }
    }
}

// MARK: - Paginated Response

/// Generic paginated response wrapper
struct PaginatedResponse<Item> {
    let items: [Item]
    let pagination: PaginationInfo
}

// MARK: - Page Request Parameters

/// Standard pagination request parameters
struct PaginationRequest: Codable {
    let page: Int
    let pageSize: Int
    
    var queryItems: [URLQueryItem] {
        [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "page_size", value: "\(pageSize)")
        ]
    }
}

// MARK: - AsyncDisplayKit Integration

#if canImport(AsyncDisplayKit)
import AsyncDisplayKit

extension Paginator {
    /// Checks if should load more based on ASCollectionNode context
    /// - Parameter context: The collection context
    /// - Returns: True if should trigger next page load
    func shouldLoadMore(context: ASBatchContext) -> Bool {
        return hasMore && !isLoading
    }
}
#endif
