import SwiftUI

struct AddCardView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var vm = AddCardViewModel()

    var body: some View {
        VStack(spacing: 12) {
            TextField("Kart numarası", text: $vm.cardNumber)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)

            TextField("Kart sahibi", text: $vm.holderName)
                .textFieldStyle(.roundedBorder)

            HStack {
                TextField("AA", text: $vm.expiryMonth)
                    .textFieldStyle(.roundedBorder)
                TextField("YY", text: $vm.expiryYear)
                    .textFieldStyle(.roundedBorder)
            }

            SecureField("CVV", text: $vm.cvv)
                .textFieldStyle(.roundedBorder)

            if let err = vm.errorMessage {
                Text(err).foregroundColor(.red)
            }

            if vm.didSave {
                Text("Kart başarıyla kaydedildi").foregroundColor(.green)
            }

            Button("Kaydet") {
                vm.validateAndSave()
            }
            .buttonStyle(.borderedProminent)
            .disabled(vm.isSaving)

            Spacer()
        }
        .padding()
        .onChange(of: vm.didSave) { saved in
            if saved {
                // dismiss sheet after showing success
                dismiss()
            }
        }
    }
}
