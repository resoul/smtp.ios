import Combine
import Foundation

final class SettingsViewModel {
    private var cancellables = Set<AnyCancellable>()
    
    private let userService: UserService
    
    let currentUser = PassthroughSubject<User?, Never>()
    
    private(set) var user: User?

    init(userService: UserService) {
        self.userService = userService
        
        userService.userPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.updateUser(with: user)
            }
            .store(in: &cancellables)
    }

    private func updateUser(with user: User?) {
        self.user = user
        currentUser.send(user)
    }
}
