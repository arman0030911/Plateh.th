import SwiftUI

struct BankCardsView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: { appState.route = .none }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text("Banka Kartlarım")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                    }
                }
                .padding()

                Spacer()

                VStack(spacing: 16) {
                    Image(systemName: "creditcard")
                        .font(.system(size: 64))
                        .foregroundColor(Color("AppGray"))
                    Text("Henüz kart eklenmedi")
                        .foregroundColor(.white)
                        .font(.headline)
                    Text("Ödemelerinizi hızlandırmak için kart ekleyin")
                        .foregroundColor(Color("AppGray"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                    Button(action: {}) {
                        Text("Kart Ekle")
                            .foregroundColor(Color("AppBlack"))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("AppMint"))
                            .cornerRadius(12)
                            .padding(.horizontal, 32)
                    }
                }

                Spacer()
            }
            .background(Color("AppBlack").ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
}
