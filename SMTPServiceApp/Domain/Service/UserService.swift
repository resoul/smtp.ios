import Combine

protocol UserService {
    var currentUser: User? { get }
    var userPublisher: AnyPublisher<User?, Never> { get }
    
    func setCurrentUser(_ user: User?)
    func getCurrentUser() -> User?
    func clearCurrentUser()
}
