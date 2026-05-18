import Foundation
import OSLog

enum AppLogger {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "Plateh.th",
        category: "Application"
    )

    static func error(_ error: Error, context: String) {
        logger.error("\(context, privacy: .public): \(error.localizedDescription, privacy: .public)")
    }

    static func message(_ text: String) {
        logger.log("\(text, privacy: .public)")
    }
}
