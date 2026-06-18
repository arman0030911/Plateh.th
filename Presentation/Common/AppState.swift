import Foundation
import SwiftUI
import Combine

enum AppRoute: Hashable {
    case none
    case profile
    case bankCards
    case settings
    case login
    case details(paymentId: String)
}

@MainActor
final class AppState: ObservableObject {
    static let shared = AppState()

    @Published var isSideMenuOpen: Bool = false
    @Published var route: AppRoute = .none
    @Published var userProfile: UserProfile? = nil
}
