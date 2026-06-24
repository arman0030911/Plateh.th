import SwiftUI

/// Compact glass-style side menu row with an active mint indicator.
struct SideMenuRow: View {
    let icon: String
    let title: String
    var tint: Color = .white
    var isActive: Bool = false
    var action: () -> Void

    private enum Metrics {
        static let rowHeight: CGFloat = 54
        static let iconSize: CGFloat = 36
        static let cornerRadius: CGFloat = 16
        static let indicatorWidth: CGFloat = 3
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                activeIndicator

                iconView

                Text(title)
                    .font(.appBody(15))
                    .foregroundColor(isActive ? Color.appMint : tint.opacity(0.92))
                    .lineLimit(1)
                    .minimumScaleFactor(0.82)

                Spacer(minLength: 8)
            }
            .padding(.trailing, 14)
            .frame(height: Metrics.rowHeight)
            .background(rowBackground)
            .contentShape(RoundedRectangle(cornerRadius: Metrics.cornerRadius))
            .liquidGlassRow(
                tint: isActive ? Color.appMint.opacity(0.16) : tint.opacity(0.045),
                cornerRadius: Metrics.cornerRadius
            )
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(title))
        .accessibilityAddTraits(isActive ? [.isButton, .isSelected] : .isButton)
    }

    @ViewBuilder
    private var activeIndicator: some View {
        RoundedRectangle(cornerRadius: Metrics.indicatorWidth)
            .fill(isActive ? Color.appMint : Color.clear)
            .frame(width: Metrics.indicatorWidth, height: 26)
            .padding(.leading, 1)
    }

    @ViewBuilder
    private var iconView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 11)
                .fill(iconBackground)
                .frame(width: Metrics.iconSize, height: Metrics.iconSize)

            Image(systemName: icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(iconColor)
        }
    }

    @ViewBuilder
    private var rowBackground: some View {
        RoundedRectangle(cornerRadius: Metrics.cornerRadius)
            .fill(isActive ? Color.appMint.opacity(0.11) : Color.white.opacity(0.035))
            .overlay(
                RoundedRectangle(cornerRadius: Metrics.cornerRadius)
                    .stroke(
                        isActive ? Color.appMint.opacity(0.22) : Color.white.opacity(0.055),
                        lineWidth: 1
                    )
            )
    }

    private var iconBackground: Color {
        if isActive {
            return Color.appMint
        }

        return tint.opacity(0.12)
    }

    private var iconColor: Color {
        if isActive {
            return Color.appBlack
        }

        return tint.opacity(0.92)
    }
}

struct SideMenuRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 12) {
            SideMenuRow(
                icon: "person.fill",
                title: "Profilim",
                isActive: true,
                action: {}
            )

            SideMenuRow(
                icon: "creditcard.fill",
                title: "Banka Kartlarım",
                isActive: false,
                action: {}
            )

            SideMenuRow(
                icon: "gearshape.fill",
                title: "Ayarlar",
                isActive: false,
                action: {}
            )

            SideMenuRow(
                icon: "arrow.left.square.fill",
                title: "Güvenli Çıkış",
                tint: Color(red: 1.0, green: 0.45, blue: 0.45),
                isActive: false,
                action: {}
            )
        }
        .padding(20)
        .background(Color.appBlack)
        .previewLayout(.sizeThatFits)
    }
}

private extension View {
    @ViewBuilder
    func liquidGlassRow(tint: Color, cornerRadius: CGFloat) -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect(
                .regular.tint(tint).interactive(),
                in: .rect(cornerRadius: cornerRadius)
            )
        } else {
            self
        }
    }
}
