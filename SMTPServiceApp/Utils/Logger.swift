import Foundation
import OSLog

/// Centralized logging system using OSLog for structured, performant logging
///
/// This logger provides categorized logging with different severity levels and
/// automatic privacy handling for sensitive data.
///
/// Usage:
/// ```swift
/// Logger.network.info("Request completed", metadata: ["endpoint": "/api/login"])
/// Logger.auth.error("Login failed", error: error)
/// Logger.ui.debug("Button tapped", metadata: ["button": "submit"])
/// ```
final class Logger {
    
    // MARK: - Logger Categories
    
    /// Logger for network-related events
    static let network = Logger(subsystem: "NetworkService", category: "network")
    
    /// Logger for authentication events
    static let auth = Logger(subsystem: "AuthService", category: "auth")
    
    /// Logger for UI events
    static let ui = Logger(subsystem: "PresentationLayer", category: "ui")
    
    /// Logger for data/storage events
    static let data = Logger(subsystem: "DataLayer", category: "data")
    
    /// Logger for coordinator navigation events
    static let navigation = Logger(subsystem: "Coordinator", category: "navigation")
    
    /// Logger for business logic (UseCases)
    static let business = Logger(subsystem: "DomainLayer", category: "business")
    
    /// Logger for app lifecycle events
    static let lifecycle = Logger(subsystem: "AppDelegate", category: "lifecycle")
    
    // MARK: - Properties
    
    private let osLog: OSLog
    private let subsystem: String
    private let category: String
    
    // MARK: - Initialization
    
    /// Creates a new logger instance
    /// - Parameters:
    ///   - subsystem: The subsystem identifier (typically your app's bundle ID or component)
    ///   - category: The category for this logger
    private init(subsystem: String, category: String) {
        self.subsystem = "net.emercury.smtp.\(subsystem)"
        self.category = category
        self.osLog = OSLog(subsystem: self.subsystem, category: category)
    }
    
    // MARK: - Logging Methods
    
    /// Logs a debug message (only visible in debug builds)
    /// - Parameters:
    ///   - message: The message to log
    ///   - metadata: Optional key-value metadata
    ///   - file: Source file (auto-populated)
    ///   - function: Function name (auto-populated)
    ///   - line: Line number (auto-populated)
    func debug(
        _ message: String,
        metadata: [String: Any]? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(
            level: .debug,
            message: message,
            metadata: metadata,
            file: file,
            function: function,
            line: line
        )
    }
    
    /// Logs an informational message
    /// - Parameters:
    ///   - message: The message to log
    ///   - metadata: Optional key-value metadata
    ///   - file: Source file (auto-populated)
    ///   - function: Function name (auto-populated)
    ///   - line: Line number (auto-populated)
    func info(
        _ message: String,
        metadata: [String: Any]? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(
            level: .info,
            message: message,
            metadata: metadata,
            file: file,
            function: function,
            line: line
        )
    }
    
    /// Logs a warning message
    /// - Parameters:
    ///   - message: The message to log
    ///   - metadata: Optional key-value metadata
    ///   - file: Source file (auto-populated)
    ///   - function: Function name (auto-populated)
    ///   - line: Line number (auto-populated)
    func warning(
        _ message: String,
        metadata: [String: Any]? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(
            level: .default,
            message: message,
            metadata: metadata,
            file: file,
            function: function,
            line: line
        )
    }
    
    /// Logs an error message
    /// - Parameters:
    ///   - message: The message to log
    ///   - error: Optional error object
    ///   - metadata: Optional key-value metadata
    ///   - file: Source file (auto-populated)
    ///   - function: Function name (auto-populated)
    ///   - line: Line number (auto-populated)
    func error(
        _ message: String,
        error: Error? = nil,
        metadata: [String: Any]? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        var combinedMetadata = metadata ?? [:]
        if let error = error {
            combinedMetadata["error"] = String(describing: error)
            combinedMetadata["error_type"] = String(describing: type(of: error))
        }
        
        log(
            level: .error,
            message: message,
            metadata: combinedMetadata,
            file: file,
            function: function,
            line: line
        )
    }
    
    /// Logs a critical/fault message
    /// - Parameters:
    ///   - message: The message to log
    ///   - error: Optional error object
    ///   - metadata: Optional key-value metadata
    ///   - file: Source file (auto-populated)
    ///   - function: Function name (auto-populated)
    ///   - line: Line number (auto-populated)
    func critical(
        _ message: String,
        error: Error? = nil,
        metadata: [String: Any]? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        var combinedMetadata = metadata ?? [:]
        if let error = error {
            combinedMetadata["error"] = String(describing: error)
            combinedMetadata["error_type"] = String(describing: type(of: error))
        }
        
        log(
            level: .fault,
            message: message,
            metadata: combinedMetadata,
            file: file,
            function: function,
            line: line
        )
    }
    
    // MARK: - Private Helpers
    
    private func log(
        level: OSLogType,
        message: String,
        metadata: [String: Any]?,
        file: String,
        function: String,
        line: Int
    ) {
        let fileName = (file as NSString).lastPathComponent
        let location = "[\(fileName):\(line)] \(function)"
        
        var fullMessage = "[\(category)] \(message)"
        
        if let metadata = metadata, !metadata.isEmpty {
            let metadataString = formatMetadata(metadata)
            fullMessage += " | \(metadataString)"
        }
        
        #if DEBUG
        fullMessage = "\(location) - \(fullMessage)"
        #endif
        
        os_log("%{public}@", log: osLog, type: level, fullMessage)
    }
    
    private func formatMetadata(_ metadata: [String: Any]) -> String {
        let pairs = metadata.map { key, value in
            "\(key)=\(redactSensitiveValue(key: key, value: value))"
        }
        return pairs.joined(separator: ", ")
    }
    
    /// Redacts sensitive information from logs
    private func redactSensitiveValue(key: String, value: Any) -> String {
        let sensitiveKeys = ["password", "token", "cookie", "secret", "key", "authorization"]
        let lowerKey = key.lowercased()
        
        if sensitiveKeys.contains(where: { lowerKey.contains($0) }) {
            return "[REDACTED]"
        }
        
        return String(describing: value)
    }
}

// MARK: - Performance Logging

extension Logger {
    /// Measures and logs execution time of a block
    /// - Parameters:
    ///   - label: Description of the operation
    ///   - block: The code block to measure
    /// - Returns: The result of the block
    func measure<T>(
        _ label: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        block: () throws -> T
    ) rethrows -> T {
        let start = CFAbsoluteTimeGetCurrent()
        defer {
            let duration = CFAbsoluteTimeGetCurrent() - start
            debug(
                "Performance: \(label)",
                metadata: ["duration_ms": String(format: "%.2f", duration * 1000)],
                file: file,
                function: function,
                line: line
            )
        }
        return try block()
    }
    
    /// Measures and logs execution time of an async block
    /// - Parameters:
    ///   - label: Description of the operation
    ///   - block: The async code block to measure
    /// - Returns: The result of the block
    func measureAsync<T>(
        _ label: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        block: () async throws -> T
    ) async rethrows -> T {
        let start = CFAbsoluteTimeGetCurrent()
        defer {
            let duration = CFAbsoluteTimeGetCurrent() - start
            debug(
                "Performance: \(label)",
                metadata: ["duration_ms": String(format: "%.2f", duration * 1000)],
                file: file,
                function: function,
                line: line
            )
        }
        return try await block()
    }
}

// MARK: - Convenience Methods

extension Logger {
    /// Logs the start of an operation
    func logStart(_ operation: String, metadata: [String: Any]? = nil) {
        info("Started: \(operation)", metadata: metadata)
    }
    
    /// Logs successful completion of an operation
    func logSuccess(_ operation: String, metadata: [String: Any]? = nil) {
        info("Completed: \(operation)", metadata: metadata)
    }
    
    /// Logs failure of an operation
    func logFailure(_ operation: String, error: Error, metadata: [String: Any]? = nil) {
        self.error("Failed: \(operation)", error: error, metadata: metadata)
    }
}
