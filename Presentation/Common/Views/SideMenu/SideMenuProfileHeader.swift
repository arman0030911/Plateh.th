import SwiftUI

// MARK: - SideMenuProfileHeader

/// Премиальная шапка профиля для бокового меню.
/// Современный дизайн с градиентной аватаркой, иконкой редактирования и плавными анимациями.
/// Полностью интегрирована в дизайн-систему приложения (AppTheme, AppFont, AppColors).
struct SideMenuProfileHeader: View {
    // MARK: - Properties
    
    var user: UserProfile?
    @EnvironmentObject private var appState: AppState
    
    // MARK: - Constants
    
    private enum Metrics {
        static let avatarSize: CGFloat = 92
        static let avatarBorderWidth: CGFloat = 3.5
        static let editIconSize: CGFloat = 28
        static let verticalSpacing: CGFloat = 14
        static let horizontalPadding: CGFloat = 24
        static let verticalPadding: CGFloat = 20
        static let shadowRadius: CGFloat = 8
        static let shadowYOffset: CGFloat = 3
        static let tapScale: CGFloat = 0.96
        static let animationDuration: Double = 0.25
    }
    
    @State private var isPressed: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        Button(action: headerTapped) {
            VStack(spacing: Metrics.verticalSpacing) {
                // Avatar with gradient border and edit button
                avatarContainer
                
                // User name
                userNameView
                
                // User email or login prompt
                userEmailView
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, Metrics.horizontalPadding)
            .padding(.vertical, Metrics.verticalPadding)
            .background(backgroundGradient)
            .contentShape(Rectangle())
            .scaleEffect(isPressed ? Metrics.tapScale : 1.0)
            .animation(.easeInOut(duration: Metrics.animationDuration), value: isPressed)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(user == nil ? "Кирүү экранына өтүү" : "Профиль экранына өтүү")
        .accessibilityAddTraits(.isButton)
    }
    
    // MARK: - Avatar Container
    
    @ViewBuilder
    private var avatarContainer: some View {
        ZStack(alignment: .topTrailing) {
            // Gradient border circle
            Circle()
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.appMint,
                            Color.appMint.opacity(0.72)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: Metrics.avatarBorderWidth
                )
                .frame(width: Metrics.avatarSize, height: Metrics.avatarSize)
                .shadow(color: Color.appMint.opacity(0.24), radius: Metrics.shadowRadius, x: 0, y: Metrics.shadowYOffset)
            
            // Avatar content
            avatarContent
                .frame(width: Metrics.avatarSize - Metrics.avatarBorderWidth * 2, height: Metrics.avatarSize - Metrics.avatarBorderWidth * 2)
                .clipShape(Circle())
            
            // Edit button
            if user != nil {
                editButton
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
            placeholderAvatar
        }
    }
    
    @ViewBuilder
    private var placeholderAvatar: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.appMint.opacity(0.18),
                            Color.appMint.opacity(0.08)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .frame(width: Metrics.avatarSize * 0.45, height: Metrics.avatarSize * 0.45)
                .foregroundColor(Color.appMint)
        }
    }
    
    @ViewBuilder
    private var editButton: some View {
        Button(action: editProfileTapped) {
            ZStack {
                Circle()
                    .fill(Color.appBlack)
                    .frame(width: Metrics.editIconSize, height: Metrics.editIconSize)
                
                Image(systemName: "pencil.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: Metrics.editIconSize * 0.75, height: Metrics.editIconSize * 0.75)
                    .foregroundColor(Color.appMint)
            }
            .offset(x: 4, y: -4)
        }
        .accessibilityLabel("Профильди өзгөртүү")
        .accessibilityHint("Профиль маалыматтарын жаңыртуу")
    }
    
    // MARK: - Text Views
    
    @ViewBuilder
    private var userNameView: some View {
        Text(user?.name ?? "Кирүү")
            .font(.appTitle(22))
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .lineLimit(1)
            .truncationMode(.tail)
            .minimumScaleFactor(0.8)
            .accessibilityTraits(.header)
    }
    
    @ViewBuilder
    private var userEmailView: some View {
        Text(user?.email ?? "Аккаунтуңузга кириңиз")
            .font(.appCaption(14))
            .foregroundColor(AppTheme.mutedText)
            .lineLimit(1)
            .truncationMode(.tail)
            .minimumScaleFactor(0.75)
    }
    
    // MARK: - Background
    
    @ViewBuilder
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.appBlack,
                Color.appCard.opacity(0.65)
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    // MARK: - Accessibility
    
    private var accessibilityLabel: Text {
        if let user = user {
            return Text("\(user.name), \(user.email)")
        } else {
            return Text("Кирүү, аккаунтуңузга жетүү")
        }
    }
    
    // MARK: - Actions
    
    private func headerTapped() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
            isPressed = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                isPressed = false
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            appState.isSideMenuOpen = false
            appState.route = (user == nil) ? .login : .profile
        }
    }
    
    private func editProfileTapped() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
            isPressed = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                isPressed = false
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            appState.isSideMenuOpen = false
            appState.route = .profile
        }
    }
}

// MARK: - Preview

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
}

#Preview("Not Logged In") {
    SideMenuProfileHeader(user: nil)
        .environmentObject(AppState.shared)
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
}
