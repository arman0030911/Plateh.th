import Foundation

enum AppConfig {
    // MARK: - API Configuration
    
    static let depositAPIBaseURL = "https://api.example.com/deposits"
    
    // MARK: - App Info
    
    static let appName = "Plateh.th"
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    
    // MARK: - Feature Flags
    
    static let enableLogging = true
    static let enableAnalytics = false
}
