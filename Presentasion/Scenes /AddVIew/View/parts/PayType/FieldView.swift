//
//  FieldView.swift
//  Plateh.th
//
//  Created by Adis on 10.03.2026.
//
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
                .foregroundStyle(.appMint)
            if isTextField { 
                TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(.appBlack.opacity(0.45)))
                    .font(.appBody(15))
                    .frame(height: 50)
                    .padding(.horizontal, 14)
                    .background(.white.opacity(0.95))
                    .clipShape(Capsule())
                    .keyboardType(isTextPrice ? .numberPad : .default)
                    .overlay { 
                        Capsule()
                            .stroke(.appMint.opacity(0.25), lineWidth: 1)
                    }
                    .onAppear {
                        formatPriceInput(text)
                    }
                    .onChange(of: text) { _, newValue in
                        formatPriceInput(newValue)
                    }
            } else { 
                TextEditor(text: $text)
                    .font(.appBody(15))
                    .frame(height: 154)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .scrollContentBackground(.hidden)
                    .background(.white.opacity(0.95))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay { 
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.appMint.opacity(0.25), lineWidth: 1)
                    }
                
            }
        }
    }
}
