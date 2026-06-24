import SwiftUI
import UIKit

/// Root Side Menu view with the Glass Banking visual treatment.
struct SideMenuView: View {
    @EnvironmentObject var appState: AppState
    @State private var dragOffset: CGFloat = 0

    private enum Metrics {
        static let iPhoneWidthFraction: CGFloat = 0.80
        static let iPadWidthFraction: CGFloat = 0.46
        static let panelRadius: CGFloat = 28
        static let horizontalPadding: CGFloat = 18
        static let rowSpacing: CGFloat = 8
    }

    private var widthFraction: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad
            ? Metrics.iPadWidthFraction
            : Metrics.iPhoneWidthFraction
    }

    var body: some View {
        GeometryReader { geo in
            let menuWidth = geo.size.width * widthFraction

            ZStack(alignment: .leading) {
                if appState.isSideMenuOpen {
                    Color.appBlack
                        .opacity(0.54)
                        .ignoresSafeArea()
                        .overlay {
                            Rectangle()
                                .fill(.ultraThinMaterial)
                                .opacity(0.12)
                                .ignoresSafeArea()
                        }
                        .transition(.opacity)
                        .onTapGesture {
                            closeMenu()
                        }
                }

                menuPanel(menuWidth: menuWidth, safeAreaInsets: geo.safeAreaInsets)
                    .offset(x: (appState.isSideMenuOpen ? 0 : -menuWidth) + dragOffset)
                    .gesture(dragGesture(menuWidth: menuWidth))
                    .animation(
                        .interactiveSpring(response: 0.28, dampingFraction: 0.85),
                        value: appState.isSideMenuOpen
                    )
            }
        }
        .accessibilityHidden(!appState.isSideMenuOpen)
    }

    @ViewBuilder
    private func menuPanel(menuWidth: CGFloat, safeAreaInsets: EdgeInsets) -> some View {
        Group {
            if #available(iOS 26.0, *) {
                GlassEffectContainer(spacing: 14) {
                    menuContent(safeAreaInsets: safeAreaInsets)
                }
            } else {
                menuContent(safeAreaInsets: safeAreaInsets)
            }
        }
        .frame(width: menuWidth)
        .background(panelBackground)
        .overlay(panelBorder)
        .clipShape(RoundedCorners(radius: Metrics.panelRadius, corners: [.topRight, .bottomRight]))
        .liquidGlassSurface(
            tint: Color.appMint.opacity(0.08),
            cornerRadius: Metrics.panelRadius,
            fallbackFill: Color.clear
        )
        .shadow(color: Color.black.opacity(0.42), radius: 28, x: 12, y: 0)
        .shadow(color: Color.appMint.opacity(0.14), radius: 24, x: 4, y: 0)
    }

    @ViewBuilder
    private func menuContent(safeAreaInsets: EdgeInsets) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            SideMenuProfileHeader(user: appState.userProfile)
                .environmentObject(appState)
                .padding(.horizontal, Metrics.horizontalPadding)
                .padding(.top, safeAreaInsets.top + 18)
                .padding(.bottom, 18)

            menuRows
                .padding(.horizontal, Metrics.horizontalPadding)

            Spacer(minLength: 24)

            footerView
                .padding(.horizontal, Metrics.horizontalPadding)
                .padding(.bottom, safeAreaInsets.bottom + 16)
        }
    }

    @ViewBuilder
    private var menuRows: some View {
        VStack(spacing: Metrics.rowSpacing) {
            menuRow(
                icon: "person.fill",
                title: "Profilim",
                route: .profile
            )
            menuRow(
                icon: "creditcard.fill",
                title: "Banka Kartlarım",
                route: .bankCards
            )
            menuRow(
                icon: "gearshape.fill",
                title: "Ayarlar",
                route: .settings
            )

            SideMenuRow(
                icon: "arrow.left.square.fill",
                title: "Güvenli Çıkış",
                tint: Color(red: 1.0, green: 0.45, blue: 0.45),
                isActive: false
            ) {
                handleLogout()
            }
            .padding(.top, 8)
        }
    }

    @ViewBuilder
    private var panelBackground: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)

            LinearGradient(
                gradient: Gradient(colors: [
                    Color.appBlack.opacity(0.72),
                    Color.appCard.opacity(0.48),
                    Color.appBlack.opacity(0.62)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Color.appMint
                .opacity(0.035)
        }
    }

    @ViewBuilder
    private var panelBorder: some View {
        HStack(spacing: 0) {
            Spacer()
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.appMint.opacity(0.48),
                            Color.white.opacity(0.10),
                            Color.appMint.opacity(0.24)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 1)
        }
        .allowsHitTesting(false)
    }

    @ViewBuilder
    private var footerView: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.appMint.opacity(0.13))
                    .frame(width: 38, height: 38)

                Image(systemName: "creditcard.and.123")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.appMint)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text("Plateh.th")
                    .font(.appBody(14))
                    .foregroundColor(.white)

                Text("v\(appVersion)")
                    .font(.appCaption(11))
                    .foregroundColor(AppTheme.mutedText)
            }

            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.055))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
        .liquidGlassSurface(
            tint: Color.appMint.opacity(0.07),
            cornerRadius: 18,
            fallbackFill: AppTheme.surface
        )
    }

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    @ViewBuilder
    private func menuRow(
        icon: String,
        title: String,
        route: AppRoute
    ) -> some View {
        let isActive = checkIfActive(route)
        SideMenuRow(
            icon: icon,
            title: title,
            tint: .white,
            isActive: isActive
        ) {
            withAnimation(.easeInOut(duration: 0.28)) {
                appState.route = route
                appState.isSideMenuOpen = false
            }
        }
    }

    private func checkIfActive(_ candidate: AppRoute) -> Bool {
        switch (appState.route, candidate) {
        case (.profile, .profile): return true
        case (.bankCards, .bankCards): return true
        case (.settings, .settings): return true
        default: return false
        }
    }

    private func handleLogout() {
        withAnimation(.easeInOut(duration: 0.28)) {
            appState.userProfile = nil
            appState.isSideMenuOpen = false
            appState.route = .none
        }
    }

    private func dragGesture(menuWidth: CGFloat) -> some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = min(max(value.translation.width, -menuWidth), menuWidth)
            }
            .onEnded { value in
                if value.translation.width < -80 {
                    closeMenu()
                } else {
                    withAnimation(
                        .interactiveSpring(response: 0.28, dampingFraction: 0.85)
                    ) {
                        dragOffset = 0
                    }
                }
            }
    }

    private func closeMenu() {
        withAnimation(.easeInOut(duration: 0.28)) {
            dragOffset = 0
            appState.isSideMenuOpen = false
        }
    }
}

fileprivate struct RoundedCorners: Shape {
    let radius: CGFloat
    let corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

private extension View {
    @ViewBuilder
    func liquidGlassSurface(tint: Color, cornerRadius: CGFloat, fallbackFill: Color) -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect(
                .regular.tint(tint),
                in: .rect(cornerRadius: cornerRadius)
            )
        } else {
            self.background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(fallbackFill)
            )
        }
    }
}
