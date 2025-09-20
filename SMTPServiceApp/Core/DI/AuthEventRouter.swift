import Foundation

final class AuthEventRouter: AuthenticationEventHandler {
    private let cookieStorage: CookieStorage
    private let userStorage: UserStorage

    init(cookieStorage: CookieStorage, userStorage: UserStorage) {
        self.cookieStorage = cookieStorage
        self.userStorage = userStorage
    }

    func didReceiveAuthenticationError() {
        // Clear any persisted auth state on authentication failures.
        cookieStorage.remove()
        userStorage.removeUser()

        // If you want to notify the app (e.g., to present login), you can post a notification here.
        // NotificationCenter.default.post(name: .didReceiveAuthenticationError, object: nil)
    }
}
