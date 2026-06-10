import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Button(action: { appState.route = .none }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Text("Profilim")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        Spacer()
                        Spacer().frame(width: 24)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)

                    // Avatar
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .strokeBorder(Color("AppMint"), lineWidth: 3)
                                .frame(width: 100, height: 100)

                            if let profile = appState.userProfile, let data = profile.avatarData, let ui = UIImage(data: data) {
                                Image(uiImage: ui)
                                    .resizable()
                                    .scaledToFill()
                                    .clipShape(Circle())
                                    .frame(width: 94, height: 94)
                            } else {
                                Circle()
                                    .fill(Color("AppMint"))
                                    .frame(width: 94, height: 94)
                                    .overlay(Image(systemName: "person.fill").foregroundColor(.black))
                            }
                        }

                        Button(action: {}) {
                            Text("Fotoğrafı değiştir")
                                .font(.caption)
                                .foregroundColor(Color("AppMint"))
                        }
                    }

                    // Stats card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack { Text("Toplam Borç").foregroundColor(Color("AppGray")); Spacer(); Text("0 ₺").bold().foregroundColor(.white) }
                        HStack { Text("Aylık Ödeme").foregroundColor(Color("AppGray")); Spacer(); Text("0 ₺").bold().foregroundColor(.white) }
                        HStack { Text("Tek Seferlik").foregroundColor(Color("AppGray")); Spacer(); Text("0 ₺").bold().foregroundColor(.white) }
                    }
                    .padding(16)
                    .background(Color("AppCard"))
                    .cornerRadius(16)
                    .padding(.horizontal, 20)

                    Spacer()
                }
            }
            .background(Color("AppBlack").ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
}
