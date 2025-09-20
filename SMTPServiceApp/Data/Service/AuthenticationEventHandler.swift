import Foundation

protocol AuthenticationEventHandler: AnyObject {
    func didReceiveAuthenticationError()
}
