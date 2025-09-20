import Foundation

private struct EmptyData: Codable {}

final class NetworkServiceImpl: NetworkService {
    private let baseURL: URL
    private let session: URLSession
    private let cookieStorage: CookieStorage
    private let config: NetworkConfig
    private weak var authEventHandler: AuthenticationEventHandler?
    
    init(
        config: NetworkConfig,
        cookieStorage: CookieStorage,
        authEventHandler: AuthenticationEventHandler? = nil
    ) {
        guard let url = URL(string: config.baseURL) else {
            fatalError("Invalid base URL")
        }
        
        self.baseURL = url
        self.cookieStorage = cookieStorage
        self.config = config
        self.authEventHandler = authEventHandler
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = config.timeout
        sessionConfig.timeoutIntervalForResource = config.timeout
        sessionConfig.httpShouldSetCookies = true
        sessionConfig.httpCookieAcceptPolicy = .always
        
        self.session = URLSession(configuration: sessionConfig)
    }
    
    func request<T: Codable>(
        endpoint: Endpoint,
        responseType: T.Type
    ) async throws -> T {
        let urlRequest = try buildURLRequest(for: endpoint)
        
        if config.enableLogging {
            logRequest(urlRequest)
        }
        
        let (data, response) = try await session.data(for: urlRequest)
        
        if config.enableLogging {
            logResponse(data: data, response: response)
        }
        
        try handleResponse(response)
        
        if let httpResponse = response as? HTTPURLResponse {
            handleCookies(from: httpResponse)
        }
        
        let apiResponse = try parseResponse(data: data, responseType: Response<T>.self)
        try handleAPIStatus(apiResponse.status)
        
        guard let responseData = apiResponse.data else {
            throw NetworkError.noData
        }
        
        return responseData
    }
    
    func requestWithoutResponse(endpoint: Endpoint) async throws {
        let urlRequest = try buildURLRequest(for: endpoint)
        
        if config.enableLogging {
            logRequest(urlRequest)
        }
        
        let (data, response) = try await session.data(for: urlRequest)
        
        if config.enableLogging {
            logResponse(data: data, response: response)
        }
        
        try handleResponse(response)
        
        if let httpResponse = response as? HTTPURLResponse {
            handleCookies(from: httpResponse)
        }
        
        let apiResponse = try parseResponse(data: data, responseType: Response<EmptyData>.self)
        try handleAPIStatus(apiResponse.status)
    }
    
    private func buildURLRequest(for endpoint: Endpoint) throws -> URLRequest {
        var url = baseURL.appendingPathComponent(endpoint.path)
        
        if let queryItems = endpoint.queryItems,
           var components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            components.queryItems = queryItems
            if let newURL = components.url {
                url = newURL
            }
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("gzip, deflate, br, zstd", forHTTPHeaderField: "Accept-Encoding")
        request.setValue("en-US,en;q=0.9", forHTTPHeaderField: "Accept-Language")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        request.setValue("no-cache", forHTTPHeaderField: "Pragma")
        request.setValue("\(baseURL.absoluteString)/", forHTTPHeaderField: "Referer")
        request.setValue("cors", forHTTPHeaderField: "Sec-Fetch-Mode")
        request.setValue("same-site", forHTTPHeaderField: "Sec-Fetch-Site")
        
        if let cookieValue = cookieStorage.get() {
            request.setValue(cookieValue, forHTTPHeaderField: "Cookie")
        }
        
        if let body = endpoint.body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = body
        }
        
        return request
    }
    
    private func logRequest(_ request: URLRequest) {
        print("🚀 REQUEST:")
        print("URL: \(request.url?.absoluteString ?? "N/A")")
        print("Method: \(request.httpMethod ?? "N/A")")
        print("Headers: \(request.allHTTPHeaderFields ?? [:])")
        if let body = request.httpBody {
            print("Body: \(String(data: body, encoding: .utf8) ?? "N/A")")
        }
        print("---")
    }
    
    private func logResponse(data: Data, response: URLResponse) {
        print("📥 RESPONSE:")
        if let httpResponse = response as? HTTPURLResponse {
            print("Status Code: \(httpResponse.statusCode)")
            print("Headers: \(httpResponse.allHeaderFields)")
        }
        print("Data: \(String(data: data, encoding: .utf8) ?? "N/A")")
        print("---")
    }
    
    private func handleResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }
        
        switch httpResponse.statusCode {
        case 200...299, 400:
            return
        case 401:
            // Notify app layer (if provided) so it can trigger logout flow.
            authEventHandler?.didReceiveAuthenticationError()
            throw NetworkError.authenticationError
        case 404:
            throw NetworkError.notFound
        case 429:
            throw NetworkError.tooManyRequests
        case 500...599:
            throw NetworkError.serverError("Server error with status code: \(httpResponse.statusCode)")
        default:
            throw NetworkError.unknown
        }
    }
    
    private func handleCookies(from response: HTTPURLResponse) {
        if let header = response.allHeaderFields["Set-Cookie"] as? String {
            cookieStorage.save(header)
        }
    }
    
    private func parseResponse<T: Codable>(data: Data, responseType: T.Type) throws -> T {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(responseType, from: data)
        } catch {
            print("Decoding error: \(error)")
            throw NetworkError.decodingError
        }
    }
    
    private func handleAPIStatus(_ status: ResponseStatus) throws {
        switch status.code {
        case StatusCodes.ok:
            return
        case StatusCodes.validationNotValid:
            let errors = status.details ?? []
            throw NetworkError.validationError(errors)
        case StatusCodes.accountNotActivated:
            throw NetworkError.accountNotActivated
        case StatusCodes.notFound:
            throw NetworkError.notFound
        case StatusCodes.sessionExpired:
            // Optional: treat server-side session expiration as authentication error too
            authEventHandler?.didReceiveAuthenticationError()
            throw NetworkError.authenticationError
        default:
            throw NetworkError.serverError(status.code)
        }
    }
}
