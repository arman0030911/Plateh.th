import SwiftUI

struct SideMenuView: View {
    @EnvironmentObject var appState: AppState

    private let widthFraction: CGFloat = 0.75

    var body: some View {
        GeometryReader { geo in
            let menuWidth = geo.size.width * widthFraction

            ZStack(alignment: .leading) {
                if appState.isSideMenuOpen {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                appState.isSideMenuOpen = false
                            }
                        }
                }

                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 12) {
                        if let profile = appState.userProfile {
                            if let data = profile.avatarData, let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                            } else {
                                ZStack {
                                    Circle()
                                        .fill(Color("AppMint"))
                                        .frame(width: 60, height: 60)
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.black)
                                        .font(.system(size: 28))
                                }
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(profile.name)
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(.white)
                                Text(profile.email)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color("AppGray"))
                            }
                        } else {
                            ZStack {
                                Circle()
                                    .fill(Color("AppMint"))
                                    .frame(width: 60, height: 60)
                                Image(systemName: "person.crop.circle.badge.plus")
                                    .foregroundColor(.black)
                                    .font(.system(size: 28))
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Giriş yapın")
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(.white)
                                Text("")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color("AppGray"))
                            }
                        }
                    }
                    .padding(.top, 40)
                    .padding(.horizontal, 20)

                    Divider()

                    VStack(alignment: .leading, spacing: 0) {
                        SideMenuRow(icon: "person.fill", title: "Profilim") {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                appState.isSideMenuOpen = false
                                appState.route = .profile
                            }
                        }

                        SideMenuRow(icon: "creditcard.fill", title: "Banka Kartlarım") {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                appState.isSideMenuOpen = false
                                appState.route = .bankCards
                            }
                        }

                        SideMenuRow(icon: "gearshape.fill", title: "Ayarlar") {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                appState.isSideMenuOpen = false
                                appState.route = .settings
                            }
                        }

                        SideMenuRow(icon: "arrow.left.square.fill", title: "Güvenli Çıkış", tint: Color("Danger")) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                appState.userProfile = nil
                                appState.isSideMenuOpen = false
                                appState.route = .none
                            }
                        }
                    }
                    .padding(.top, 8)

                    Spacer()

                    HStack {
                        Text("v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")")
                            .font(.caption)
                            .foregroundColor(Color("AppGray"))
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        Spacer()
                    }
                }
                .frame(width: menuWidth)
                .background(Color("AppBlack"))
                .offset(x: appState.isSideMenuOpen ? 0 : -menuWidth)
                .shadow(color: Color.black.opacity(0.5), radius: 10, x: 6, y: 0)
                .animation(.easeInOut(duration: 0.3), value: appState.isSideMenuOpen)
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.width < -50 {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    appState.isSideMenuOpen = false
                                }
                            }
                        }
                )
            }
        }
    }
}

struct SideMenuRow: View {
    var icon: String
    var title: String
    var tint: Color = .white
    var action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .frame(width: 28, height: 28)
                    .foregroundColor(tint)
                Text(title)
                    .foregroundColor(tint)
                    .font(.system(size: 16, weight: .regular))
                Spacer()
            }
            .padding(.horizontal, 16)
            .frame(height: 56)
        }
        .buttonStyle(.plain)
    }
}
