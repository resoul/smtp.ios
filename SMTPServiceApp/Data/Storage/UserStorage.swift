final class UserStorage {
    private enum Keys {
        static let user = "em.smtp.user"
    }
    
    private let dataSource: DataSource
    
    init(dataSource: DataSource) {
        self.dataSource = dataSource
    }
    
    func saveUser(_ user: UserDTO) {
        dataSource.save(user, forKey: Keys.user)
    }
    
    func getUser() -> UserDTO? {
        return dataSource.load(UserDTO.self, forKey: Keys.user)
    }
    
    func removeUser() {
        dataSource.remove(forKey: Keys.user)
    }
    
    func hasUser() -> Bool {
        return dataSource.exists(forKey: Keys.user)
    }
}
