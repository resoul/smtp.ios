import Combine

final class UserServiceImpl: UserService {
    private var current: User?
    private let userStorage: UserStorage

    init(userStorage: UserStorage) {
        self.userStorage = userStorage
        setCurrentUser()
    }
    
    func getCurrentUser() -> User? {
        current
    }
    
    private func setCurrentUser() {
        if let userDTO = userStorage.getUser() {
            current = userDTO.toDomain()
        }
    }
}
