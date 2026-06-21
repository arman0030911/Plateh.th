import SwiftUI

/// Профильная шапка меню: интегрирована в дизайн-систему.
/// Большая аватарка (88pt), имя жирным, email — меньше.
/// Нажатие ведёт в профиль (если залогинен) или на экран логина.
struct SideMenuProfileHeader: View {
    var user: UserProfile?
    @EnvironmentObject private var appState: AppState

    private let avatarSize: CGFloat = 88

    var body: some View {
        Button(action: headerTapped) {
            VStack(spacing: 10) {
                // Аватарка: 88pt круг с тонкой обводкой и тенью
                avatar
                    .frame(width: avatarSize, height: avatarSize)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(
                            Color.white.opacity(0.04),
                            lineWidth: 1
                        )
                    )
                    .shadow(
                        color: Color.black.opacity(0.35),
                        radius: 6,
                        x: 0,
                        y: 2
                    )

                // Имя: система типографики AppFont
                Text(user?.name ?? "Giriş yapın")
                    .font(.appTitle(20))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                // Email: серый текст для иерархии
                Text(user?.email ?? "Hesabınıza giriş yapın")
                    .font(.appCaption(13))
                    .foregroundColor(AppTheme.mutedText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .contentShape(Rectangle()) // Увеличивает область нажатия
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint("Профиль экранына гет")
    }

    // MARK: - Private Views

    @ViewBuilder
    private var avatar: some View {
        if let profile = user, let data = profile.avatarData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
        } else {
            // Заглушка: AppMint фон с иконкой человека (как в дизайн-системе)
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.appMint,
                                Color.appMint.opacity(0.88)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: avatarSize * 0.42,
                        height: avatarSize * 0.42
                    )
                    .foregroundColor(Color.appBlack)
            }
        }
    }

    // MARK: - Private Methods

    private var accessibilityLabel: Text {
        if let user = user {
            return Text("\(user.name), \(user.email)")
        } else {
            return Text("Giriş yapın, hesabınıza erişin")
        }
    }

    private func headerTapped() {
        withAnimation(.easeInOut(duration: 0.28)) {
            appState.isSideMenuOpen = false
            appState.route = (user == nil) ? .login : .profile
        }
    }
}

// MARK: - Preview

struct SideMenuProfileHeader_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SideMenuProfileHeader(
                user: UserProfile(
                    id: "1",
                    name: "Arman",
                    email: "arman@example.com",
                    phone: nil,
                    avatarData: nil,
                    isLoggedIn: true
                )
            )
            .background(Color.appBlack)
            .previewLayout(.sizeThatFits)
            .environmentObject(AppState.shared)

            SideMenuProfileHeader(user: nil)
                .background(Color.appBlack)
                .previewLayout(.sizeThatFits)
                .environmentObject(AppState.shared)
        }
    }
}
