import Foundation

extension Notification.Name {
    static let didReceiveAuthenticationError = Notification.Name("didReceiveAuthenticationError")
}

final class AuthEventRouter: AuthenticationEventHandler {
    private let cookieStorage: CookieStorage
    private let userStorage: UserStorage

    init(cookieStorage: CookieStorage, userStorage: UserStorage) {
        self.cookieStorage = cookieStorage
        self.userStorage = userStorage
    }

    func didReceiveAuthenticationError() {
        cookieStorage.remove()
        userStorage.removeUser()

        NotificationCenter.default.post(name: .didReceiveAuthenticationError, object: nil)
    }
}
