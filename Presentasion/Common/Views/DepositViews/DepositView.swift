//
//  DepositView.swift
//  Plateh.th
//
//  Created by Adis on 13.04.2026.
//

import SwiftUI

struct DepositView: View {
    @State private var rates: [DepositRate] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView("Yükleniyor...")
                } else if let errorMessage {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                        Text(errorMessage)
                            .multilineTextAlignment(.center)
                        Button("Tekrar Dene") {
                            Task { await loadRates() }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                } else if rates.isEmpty {
                    ContentUnavailableView(
                        "Faiz Oranı Bulunamadı",
                        systemImage: "doc.text.magnifyingglass",
                        description: Text("TRY 32 günlük veri yok")
                    )
                } else {
                    List(rates) { rate in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(rate.bank.name)
                                    .font(.headline)
                                Text("\(rate.termDays) gün • \(rate.currency)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                if let minAmount = rate.minAmount {
                                    Text("Min \(minAmount.formattedWithoutDecimals) ₺")
                                        .font(.caption2)
                                }
                            }
                            Spacer()
                            Text(String(format: "%.2f%%", rate.interestRate))
                                .font(.title2)
                                .foregroundColor(.green)
                                .bold()
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Banka Faizleri")
            .task {
                await loadRates()
            }
        }
    }
    
    private func loadRates() async {
        isLoading = true
        errorMessage = nil
        do {
            rates = try await DepositService().fetchRates(currency: "TRY", term: 32)
        } catch {
            errorMessage = "Veri yüklenemedi: \(error.localizedDescription)"
            rates = []
        }
        isLoading = false
    }
}

#Preview {
    DepositView()
}
