import Foundation
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    func login() async {
        guard !username.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Kullanıcı adı ve şifre gerekli"
            return
        }

        isLoading = true
        errorMessage = nil

        // Simulate network/auth delay
        try? await Task.sleep(nanoseconds: 400 * 1_000_000)

        // Mock success: create a simple UserProfile and assign to AppState
        let profile = UserProfile(id: UUID().uuidString, name: username, email: "\(username)@example.com", avatarData: nil)
        AppState.shared.userProfile = profile

        isLoading = false
    }
}
