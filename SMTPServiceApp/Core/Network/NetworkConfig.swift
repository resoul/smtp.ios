import Foundation

struct NetworkConfig {
    let baseURL: String
    let timeout: TimeInterval
    let enableLogging: Bool
    
    static let development = NetworkConfig(
        baseURL: "http://api.ems.em.localhost",
        timeout: 30.0,
        enableLogging: false
    )
    
    static let staging = NetworkConfig(
        baseURL: "http://staging-api.example.com",
        timeout: 30.0,
        enableLogging: true
    )
    
    static let production = NetworkConfig(
        baseURL: "http://api.example.com",
        timeout: 30.0,
        enableLogging: false
    )
}
