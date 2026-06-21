import SwiftUI
import UIKit

/// Root Side Menu view — главный контейнер меню с полной интеграцией в дизайн-систему.
/// Использует AppTheme, AppFont и современные паттерны SwiftUI.
/// Компоненты вынесены в SideMenuProfileHeader и SideMenuRow.
struct SideMenuView: View {
    @EnvironmentObject var appState: AppState
    @State private var dragOffset: CGFloat = 0

    private var widthFraction: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 0.45 : 0.78
    }

    var body: some View {
        GeometryReader { geo in
            let menuWidth = geo.size.width * widthFraction

            ZStack(alignment: .leading) {
                // Полупрозрачный фон, затемняет контент за меню
                if appState.isSideMenuOpen {
                    Color.black
                        .opacity(0.36)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .onTapGesture {
                            closeMenu()
                        }
                }

                // Меню-контейнер
                VStack(alignment: .leading, spacing: 0) {
                    // Профильная шапка: аватарка, имя, email
                    SideMenuProfileHeader(user: appState.userProfile)
                        .environmentObject(appState)
                        .padding(.horizontal, AppTheme.screenPadding)
                        .padding(.top, geo.safeAreaInsets.top + 18)
                        .padding(.bottom, 12)

                    // Разделитель с корректным цветом из дизайн-системы
                    Divider()
                        .background(AppTheme.border)
                        .padding(.horizontal, AppTheme.screenPadding)

                    // Список пунктов меню
                    VStack(spacing: 8) {
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

                        // Выход (отдельная строка с красным акцентом)
                        SideMenuRow(
                            icon: "arrow.left.square.fill",
                            title: "Güvenli Çıkış",
                            tint: Color(red: 1.0, green: 0.5, blue: 0.5),
                            isActive: false
                        ) {
                            handleLogout()
                        }
                    }
                    .padding(.horizontal, AppTheme.screenPadding)
                    .padding(.top, 16)

                    Spacer()

                    // Версия приложения в подвале
                    HStack {
                        Text("v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")")
                            .font(.appCaption(11))
                            .foregroundColor(AppTheme.mutedText)
                        Spacer()
                    }
                    .padding(.horizontal, AppTheme.screenPadding)
                    .padding(.bottom, geo.safeAreaInsets.bottom + 14)
                }
                .frame(width: menuWidth)
                // Фон: AppBlack + тонкий мятный градиент для визуальной гармонии
                .background(
                    ZStack {
                        Color.appBlack

                        // Едва заметный градиент в стиле HeaderView
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.appBlack.opacity(0.0),
                                Color.appMint.opacity(0.03)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .blendMode(.overlay)
                    }
                )
                // Лёгкий материальный эффект для глубины (как bottom nav)
                .overlay(
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .opacity(0.04)
                        .allowsHitTesting(false)
                )
                // Скругление только правой стороны (меню "выезжает" со слева)
                .clipShape(RoundedCorners(radius: AppTheme.cardRadius, corners: [.topRight, .bottomRight]))
                // Тень для эффекта глубины
                .shadow(
                    color: Color.black.opacity(0.45),
                    radius: 18,
                    x: 6,
                    y: 0
                )
                // Позиция с поддержкой drag-жестов
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

    // MARK: - Private Methods

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

// MARK: - Helper Shape

/// Форма для скругления только определённых углов меню
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
