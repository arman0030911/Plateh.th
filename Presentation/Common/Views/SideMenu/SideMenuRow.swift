import SwiftUI

/// Однострочный элемент меню — интегрирован в дизайн-систему.
/// Поддерживает активное состояние с AppMint акцентом (как payment cards).
/// Правильные отступы, типографика, иконки согласно AppTheme и AppFont.
struct SideMenuRow: View {
    let icon: String
    let title: String
    var tint: Color = .white
    var isActive: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                // Иконка: при active — AppMint фон + AppBlack иконка
                // При неактивном — серая иконка
                ZStack {
                    if isActive {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.appMint)
                            .frame(width: 44, height: 44)

                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color.appBlack)
                    } else {
                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(AppTheme.subtleText)
                            .frame(width: 44, height: 44)
                    }
                }

                // Текст: AppFont для консистентности
                Text(title)
                    .font(.appBody(16))
                    .foregroundColor(isActive ? Color.appMint : tint)
                    .lineLimit(1)

                Spacer()
            }
            .padding(.horizontal, 6)
            .frame(height: 58) // Стандартная высота iOS touch target
            .padding(.horizontal, 12)
            .background(isActive ? Color.appMint.opacity(0.08) : Color.clear)
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
        // Accessibility
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(title))
        .accessibilityAddTraits(isActive ? .isSelected : .isButton)
    }
}

// MARK: - Preview

struct SideMenuRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
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
                    tint: Color(red: 1.0, green: 0.5, blue: 0.5),
                    isActive: false,
                    action: {}
                )
            }
            .padding(20)
            .background(Color.appBlack)
            .previewLayout(.sizeThatFits)
        }
    }
}
