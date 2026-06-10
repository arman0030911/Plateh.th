import SwiftUI

extension Font {
    static func appDisplay(_ size: CGFloat) -> Font {
        .system(size: size, weight: .bold, design: .default)
    }

    static func appTitle(_ size: CGFloat) -> Font {
        .system(size: size, weight: .semibold, design: .default)
    }

    static func appBody(_ size: CGFloat) -> Font {
        .system(size: size, weight: .medium, design: .default)
    }

    static func appCaption(_ size: CGFloat) -> Font {
        .system(size: size, weight: .regular, design: .default)
    }
}
