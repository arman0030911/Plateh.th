import SwiftUI

struct DepositView: View {
    // MARK: - State

    @State private var rates: [DepositRate] = []
    @State private var selectedCurrency: DepositCurrencyOption = .turkishLira
    @State private var selectedTerm: DepositTermOption = .initial
    @State private var enteredPrincipal = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var isShowCalculatorSheet = false

    // MARK: - Derived Values

    private var principalAmount: Double? {
        let value = enteredPrincipal.parsedAmountValue
        return value > 0 ? value : nil
    }

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .top) {
            HeaderView(
                page: HeaderViewContent(
                    totalPrice: headerAmountText,
                    title: "Faiz oranları",
                    date: headerSubtitle,
                    pageType: .deposit
                ),
                action: {
                    isShowCalculatorSheet = true
                },
                date: .constant(nil)
            )
            .zIndex(1)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 19) {
                    DepositFilterBarView(
                        selectedCurrency: $selectedCurrency,
                        selectedTerm: $selectedTerm,
                        resultCount: rates.count
                    )

                    if isLoading {
                        DepositStateView(
                            title: "Faiz oranları yükleniyor",
                            subtitle: "\(selectedCurrency.rawValue) için \(selectedTerm.shortTitle) verileri getiriliyor.",
                            systemImage: "hourglass"
                        )
                    } else if let errorMessage {
                        DepositStateView(
                            title: "Veri alınamadı",
                            subtitle: errorMessage,
                            systemImage: "wifi.exclamationmark",
                            actionTitle: "Tekrar dene",
                            action: {
                                Task { await loadRates() }
                            }
                        )
                    } else if rates.isEmpty {
                        DepositStateView(
                            title: "Faiz oranı bulunamadı",
                            subtitle: "\(selectedCurrency.rawValue) için \(selectedTerm.shortTitle) verisi şu anda yok.",
                            systemImage: "tray"
                        )
                    } else {
                        LazyVStack(spacing: 19) {
                            ForEach(rates) { rate in
                                DepositRateCardView(rate: rate, principalAmount: principalAmount)
                            }
                        }
                    }
                }
            }
            .padding(.top, 150)
            .padding(.bottom, 70)
        }
        .padding(.horizontal, 20)
        .background(.appBlack)
        .sheet(isPresented: $isShowCalculatorSheet) {
            AddDepositCalculationView(
                currentAmount: enteredPrincipal,
                currentTerm: selectedTerm
            ) { amount, term in
                enteredPrincipal = amount
                selectedTerm = term
            }
        }
        .task(id: "\(selectedCurrency.rawValue)-\(selectedTerm.days)") {
            await loadRates()
        }
        .ignoresSafeArea(edges: .bottom)
    }

    // MARK: - Actions

    private func loadRates() async {
        isLoading = true
        errorMessage = nil

        let currency = selectedCurrency.rawValue
        let term = selectedTerm.days

        do {
            rates = try await DepositService().fetchRates(currency: currency, term: term)
        } catch {
            errorMessage = "Sunucuya ulaşılamadı veya veri okunamadı."
            rates = []
        }
        isLoading = false
    }

    // MARK: - Helpers

    private var headerSubtitle: String {
        let countText = rates.isEmpty ? "Henüz sonuç yok" : "\(rates.count) banka"
        if let principalAmount {
            return "\(selectedCurrency.rawValue) • \(selectedTerm.shortTitle) • \(principalAmount.currencyText(symbol: selectedCurrency.symbol))"
        }
        return "\(selectedCurrency.rawValue) • \(selectedTerm.shortTitle) • \(countText)"
    }

    private var headerAmountText: String {
        guard let principalAmount else { return "Faiz" }
        return principalAmount.currencyText(symbol: selectedCurrency.symbol)
    }
}

#Preview {
    DepositView()
}
