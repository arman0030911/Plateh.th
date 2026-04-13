//
//  DepositView.swift
//  Plateh.th
//
//  Created by Adis on 11.04.2026.
//


import SwiftUI

struct DepositView: View {
    var body: some View {
        List(fakeDeposits) { deposit in
            HStack {
                Text(deposit.bankName)
                    .font(.headline)
                Spacer()
                Text("%\(deposit.rate)")
                    .font(.title3)
                    .foregroundColor(.green)
                    .bold()
            }
            .padding(.vertical, 8)
        }
        .navigationTitle("Banka Faizleri")
    }
        
}

#Preview {
    DepositView()
}
