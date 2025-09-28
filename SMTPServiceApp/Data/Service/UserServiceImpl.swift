import Combine

final class UserServiceImpl: UserService {
    @Published private(set) var currentUser: User?
    private let userStorage: UserStorage
    
    var userPublisher: AnyPublisher<User?, Never> {
        $currentUser.eraseToAnyPublisher()
    }
    
    init(userStorage: UserStorage) {
        self.userStorage = userStorage
        loadCurrentUser()
    }
    
    func setCurrentUser(_ user: User?) {
        currentUser = user
    }
    
    func getCurrentUser() -> User? {
        return currentUser
    }
    
    func clearCurrentUser() {
        currentUser = nil
    }
    
    private func loadCurrentUser() {
        if let userDTO = userStorage.getUser() {
            currentUser = userDTO.toDomain()
        }
    }
}
