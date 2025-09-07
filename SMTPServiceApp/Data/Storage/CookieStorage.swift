final class CookieStorage {
    private enum Keys {
        static let cookie = "em.smtp.cookie"
    }
    
    private let dataSource: DataSource
    
    init(dataSource: DataSource) {
        self.dataSource = dataSource
    }
    
    func save(_ cookie: String) {
        let cookieValue = extractCookieValue(from: cookie)
        dataSource.saveString(cookieValue, forKey: Keys.cookie)
    }
    
    func get() -> String? {
        return dataSource.loadString(forKey: Keys.cookie)
    }
    
    func remove() {
        dataSource.remove(forKey: Keys.cookie)
    }
    
    func exists() -> Bool {
        return dataSource.exists(forKey: Keys.cookie)
    }
    
    private func extractCookieValue(from setCookieHeader: String) -> String {
        let components = setCookieHeader.split(separator: ";")
        if let firstComponent = components.first {
            return String(firstComponent.trimmingCharacters(in: .whitespaces))
        }
        return setCookieHeader
    }
}
