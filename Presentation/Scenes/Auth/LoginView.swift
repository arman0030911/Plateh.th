import SwiftUI

struct LoginView: View {
    @StateObject var vm: LoginViewModel
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 16) {
            Text("Giriş Yap")
                .font(.title)

            TextField("Kullanıcı adı", text: $vm.username)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)

            SecureField("Şifre", text: $vm.password)
                .textFieldStyle(.roundedBorder)

            if let error = vm.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }

            Button {
                Task { await vm.login() }
            } label: {
                if vm.isLoading {
                    ProgressView()
                } else {
                    Text("Giriş")
                        .bold()
                }
            }
            .disabled(vm.isLoading)
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
        .onAppear {
            vm.errorMessage = nil
        }
    }
}
