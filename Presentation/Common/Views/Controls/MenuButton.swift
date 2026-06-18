import SwiftUI
import UIKit

/// Reusable hamburger / menu toggle button with unified styling and interactions.
struct MenuButton: View {
    @Binding var isOpen: Bool
    var size: CGFloat = 44
    var accent: Color = .appYelow

    @State private var pressed: Bool = false

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.28, dampingFraction: 0.7)) {
                isOpen.toggle()
            }
            // light haptic feedback
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isOpen ? accent : Color.clear)
                    .frame(width: size, height: size)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(accent.opacity(isOpen ? 0.0 : 0.22), lineWidth: 1)
                    )

                Image(systemName: isOpen ? "xmark" : "line.3.horizontal")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(isOpen ? .appBlack : accent)
                    .scaleEffect(pressed ? 0.96 : 1.0)
            }
        }
        .buttonStyle(.plain)
        .frame(width: size, height: size)
        .contentShape(Rectangle())
        .simultaneousGesture(DragGesture(minimumDistance: 0)
            .onChanged { _ in pressed = true }
            .onEnded { _ in pressed = false }
        )
        .accessibilityLabel(isOpen ? "Menüyü kapat" : "Menüyü aç")
        .accessibilityAddTraits(.isButton)
    }
}

struct MenuButton_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper(false) { binding in
            MenuButton(isOpen: binding)
                .padding()
                .background(Color.black)
        }
        .previewLayout(.sizeThatFits)
    }
}

// Small helper for previews to provide a Binding
fileprivate struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    var content: (Binding<Value>) -> Content

    init(_ initialValue: Value, content: @escaping (Binding<Value>) -> Content) {
        _value = State(wrappedValue: initialValue)
        self.content = content
    }

    var body: some View { content($value) }
}
