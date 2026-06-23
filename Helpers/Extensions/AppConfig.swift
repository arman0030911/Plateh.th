import Foundation

enum AppConfig {
    // MARK: - API Configuration
    
    static let depositAPIBaseURL = "http://localhost:8080/api"
    
    // MARK: - App Info
    
    static let appName = "Plateh.th"
    // Make this computed to avoid initializing from Bundle.main at type init time,
    // which can cause MainActor inference for the entire type.
    static var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    
    // MARK: - Feature Flags
    
    static let enableLogging = true
    static let enableAnalytics = false
}
