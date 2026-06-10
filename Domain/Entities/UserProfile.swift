import Foundation

struct UserProfile: Identifiable, Equatable {
    let id: String
    var name: String
    var email: String
    var phone: String?
    var avatarData: Data? = nil
    var isLoggedIn: Bool = false
}
