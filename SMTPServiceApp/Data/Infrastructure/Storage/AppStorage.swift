final class AppStorage {
    private enum Keys {
        static let app = "em.smtp.app.settings"
    }
    
    private let dataSource: DataSource
    
    init(dataSource: DataSource) {
        self.dataSource = dataSource
    }
    
    func save(_ settings: AppSettings) {
        dataSource.save(settings.toDTO(), forKey: Keys.app)
    }
    
    func get() -> AppSettings? {
        guard let settings = dataSource.load(AppSettingsDTO.self, forKey: Keys.app) else {
            return nil
        }
        
        return settings.toDomain()
    }
    
    func remove() {
        dataSource.remove(forKey: Keys.app)
    }
    
    func exists() -> Bool {
        return dataSource.exists(forKey: Keys.app)
    }
}
