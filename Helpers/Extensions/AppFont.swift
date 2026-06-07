import SwiftUI

extension Font {
    static func appDisplay(_ size: CGFloat) -> Font {
        .system(size: size, weight: .bold, design: .rounded)
    }

    static func appTitle(_ size: CGFloat) -> Font {
        .system(size: size, weight: .semibold, design: .rounded)
    }

    static func appBody(_ size: CGFloat) -> Font {
        .system(size: size, weight: .medium, design: .rounded)
    }

    static func appCaption(_ size: CGFloat) -> Font {
        .system(size: size, weight: .regular, design: .rounded)
    }
}
