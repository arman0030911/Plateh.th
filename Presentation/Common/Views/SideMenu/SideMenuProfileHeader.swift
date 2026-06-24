import SwiftUI

/// Horizontal account capsule for the Glass Banking side menu.
struct SideMenuProfileHeader: View {
    var user: UserProfile?
    @EnvironmentObject private var appState: AppState
    @State private var isPressed: Bool = false

    private enum Metrics {
        static let avatarSize: CGFloat = 62
        static let avatarBorderWidth: CGFloat = 2
        static let editButtonSize: CGFloat = 34
        static let cornerRadius: CGFloat = 22
        static let tapScale: CGFloat = 0.98
        static let animationDuration: Double = 0.20
    }

    var body: some View {
        HStack(spacing: 14) {
            avatarView

            VStack(alignment: .leading, spacing: 5) {
                Text(user?.name ?? "Giriş yapın")
                    .font(.appTitle(17))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .minimumScaleFactor(0.78)
                    .accessibilityAddTraits(.isHeader)

                Text(user?.email ?? "Hesabınıza giriş yapın")
                    .font(.appCaption(12))
                    .foregroundColor(AppTheme.mutedText)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .minimumScaleFactor(0.75)
            }

            Spacer(minLength: 8)

            editActionView
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(capsuleBackground)
        .contentShape(RoundedRectangle(cornerRadius: Metrics.cornerRadius))
        .scaleEffect(isPressed ? Metrics.tapScale : 1.0)
        .animation(.easeInOut(duration: Metrics.animationDuration), value: isPressed)
        .onTapGesture(perform: headerTapped)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(user == nil ? "Giriş ekranına git" : "Profil ekranına git")
        .accessibilityAddTraits(.isButton)
    }

    @ViewBuilder
    private var avatarView: some View {
        ZStack(alignment: .bottomTrailing) {
            Circle()
                .fill(Color.appMint.opacity(0.12))
                .frame(width: Metrics.avatarSize, height: Metrics.avatarSize)
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.appMint.opacity(0.92),
                                    Color.white.opacity(0.18)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: Metrics.avatarBorderWidth
                        )
                )
                .shadow(color: Color.appMint.opacity(0.18), radius: 10, x: 0, y: 6)

            avatarContent
                .frame(
                    width: Metrics.avatarSize - Metrics.avatarBorderWidth * 2,
                    height: Metrics.avatarSize - Metrics.avatarBorderWidth * 2
                )
                .clipShape(Circle())

            if user != nil {
                Circle()
                    .fill(Color.appMint)
                    .frame(width: 13, height: 13)
                    .overlay(
                        Circle()
                            .stroke(Color.appBlack.opacity(0.85), lineWidth: 2)
                    )
                    .offset(x: -2, y: -2)
            }
        }
    }

    @ViewBuilder
    private var avatarContent: some View {
        if let profile = user, let data = profile.avatarData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
        } else {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.appMint.opacity(0.24),
                                Color.white.opacity(0.06)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                Image(systemName: user == nil ? "person.crop.circle.badge.plus" : "person.fill")
                    .font(.system(size: user == nil ? 25 : 23, weight: .semibold))
                    .foregroundColor(Color.appMint)
            }
        }
    }

    @ViewBuilder
    private var editActionView: some View {
        Button(action: editProfileTapped) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.07))
                    .frame(width: Metrics.editButtonSize, height: Metrics.editButtonSize)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )

                Image(systemName: user == nil ? "arrow.right" : "pencil")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color.appMint)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(user == nil ? "Giriş yap" : "Profili düzenle")
        .accessibilityHint(user == nil ? "Giriş ekranına git" : "Profil bilgilerini güncelle")
    }

    @ViewBuilder
    private var capsuleBackground: some View {
        RoundedRectangle(cornerRadius: Metrics.cornerRadius)
            .fill(AppTheme.elevatedSurface)
            .background(
                RoundedRectangle(cornerRadius: Metrics.cornerRadius)
                    .fill(.ultraThinMaterial)
                    .opacity(0.45)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Metrics.cornerRadius)
                    .stroke(Color.appMint.opacity(0.16), lineWidth: 1)
            )
    }

    private var accessibilityLabel: Text {
        if let user = user {
            return Text("\(user.name), \(user.email)")
        } else {
            return Text("Giriş yapın, hesabınıza erişin")
        }
    }

    private func headerTapped() {
        animatePress {
            appState.isSideMenuOpen = false
            appState.route = (user == nil) ? .login : .profile
        }
    }

    private func editProfileTapped() {
        animatePress {
            appState.isSideMenuOpen = false
            appState.route = user == nil ? .login : .profile
        }
    }

    private func animatePress(completion: @escaping () -> Void) {
        withAnimation(.spring(response: 0.28, dampingFraction: 0.88)) {
            isPressed = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            withAnimation(.spring(response: 0.28, dampingFraction: 0.88)) {
                isPressed = false
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
            completion()
        }
    }
}

#Preview("Logged In") {
    SideMenuProfileHeader(
        user: UserProfile(
            id: "1",
            name: "Арман",
            email: "arman@plateh.th",
            phone: "+996 700 123 456",
            avatarData: nil,
            isLoggedIn: true
        )
    )
    .environmentObject(AppState.shared)
    .padding()
    .background(Color.appBlack)
}

#Preview("Not Logged In") {
    SideMenuProfileHeader(user: nil)
        .environmentObject(AppState.shared)
        .padding()
        .background(Color.appBlack)
}

#Preview("With Avatar") {
    let sampleImage = UIImage(systemName: "person.crop.circle.fill")!
    let pngData = sampleImage.pngData()!

    return SideMenuProfileHeader(
        user: UserProfile(
            id: "2",
            name: "Айгерим",
            email: "aigerim@plateh.th",
            phone: nil,
            avatarData: pngData,
            isLoggedIn: true
        )
    )
    .environmentObject(AppState.shared)
    .padding()
    .background(Color.appBlack)
}
