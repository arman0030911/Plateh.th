import SwiftUI

struct FieldView: View {
    @Binding var text: String 
    var placeholder: String
    var isTextPrice: Bool = false
    var isTextField: Bool = true 

    private func formatPriceInput(_ value: String) {
        guard isTextPrice else { return }

        let formatted = value.bankFormattedAmountInput
        if text != formatted {
            text = formatted
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16){ 
            Text(placeholder)
                .font(.appBody(13))
                .foregroundStyle(AppTheme.mutedText)
            if isTextField { 
                TextField("", text: $text, prompt: Text(placeholder).foregroundColor(.appBlack.opacity(0.42)))
                    .font(.appBody(15))
                    .frame(height: 50)
                    .padding(.horizontal, 14)
                    .background(AppTheme.fieldSurface)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.controlRadius))
                    .keyboardType(isTextPrice ? .numberPad : .default)
                    .overlay { 
                        RoundedRectangle(cornerRadius: AppTheme.controlRadius)
                            .stroke(.appMint.opacity(0.28), lineWidth: 1)
                    }
                    .onAppear {
                        formatPriceInput(text)
                    }
                    .onChange(of: text) { newValue in
                        formatPriceInput(newValue)
                    }
            } else { 
                TextEditor(text: $text)
                    .font(.appBody(15))
                    .frame(height: 154)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .scrollContentBackground(.hidden)
                    .background(AppTheme.fieldSurface)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardRadius))
                    .overlay { 
                        RoundedRectangle(cornerRadius: AppTheme.cardRadius)
                            .stroke(.appMint.opacity(0.28), lineWidth: 1)
                    }
            }
        }
    }
}
