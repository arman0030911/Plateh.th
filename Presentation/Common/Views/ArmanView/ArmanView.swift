import SwiftUI

struct ArmanView: View {
    @State private var path = NavigationPath()
    @State private var mockDate: Date? = nil
    @State private var radioSelected = false

    private let mockMonthlyPayment = Payment(
        id: "mock-monthly-1",
        type: .monthly,
        title: "Kredi kartı",
        description: "Aylık kredi kartı ekstresi ödemesi",
        paymentAmount: 5000,
        totalAmount: 60000,
        dueDay: 15,
        dueDate: ISO8601DateFormatter().string(from: Date()),
        isNotificationEnabled: true,
        createdAt: ISO8601DateFormatter().string(from: Date()),
        lastPay: nil,
        storedRemainingAmount: 45000,
        isClosedStored: false,
        closeDate: nil
    )

    private let mockMonthlyPaymentPaid = Payment(
        id: "mock-monthly-2",
        type: .monthly,
        title: "Kira",
        description: "Ev kirası",
        paymentAmount: 12000,
        totalAmount: 12000,
        dueDay: 1,
        dueDate: ISO8601DateFormatter().string(from: Date()),
        isNotificationEnabled: true,
        createdAt: ISO8601DateFormatter().string(from: Date()),
        lastPay: ISO8601DateFormatter().string(from: Date()),
        storedRemainingAmount: 0,
        isClosedStored: false,
        closeDate: nil
    )

    private let mockOneTimePayment = Payment(
        id: "mock-onetime-1",
        type: .oneTime,
        title: "Telefon borcu",
        description: "Arkadaşa telefon parası",
        paymentAmount: 15000,
        totalAmount: 15000,
        dueDay: nil,
        dueDate: nil,
        isNotificationEnabled: false,
        createdAt: ISO8601DateFormatter().string(from: Date()),
        lastPay: nil,
        storedRemainingAmount: nil,
        isClosedStored: false,
        closeDate: nil
    )

    private let mockClosedPayment = Payment(
        id: "mock-closed-1",
        type: .oneTime,
        title: "Ödendi tamam",
        description: "Bu borç kapatıldı",
        paymentAmount: 3000,
        totalAmount: 3000,
        dueDay: nil,
        dueDate: nil,
        isNotificationEnabled: false,
        createdAt: ISO8601DateFormatter().string(from: Date()),
        lastPay: ISO8601DateFormatter().string(from: Date()),
        storedRemainingAmount: nil,
        isClosedStored: true,
        closeDate: ISO8601DateFormatter().string(from: Date())
    )

    private let mockBank = Bank(
        id: UUID(),
        name: "Akbank",
        logoUrl: nil,
        website: nil,
        isActive: true
    )

    private var mockDepositRate: DepositRate {
        DepositRate(
            id: UUID(),
            bank: mockBank,
            currency: "TRY",
            termDays: 32,
            interestRate: 42.5,
            minAmount: 1000,
            updatedAt: Date()
        )
    }

    private var mockDepositRateUSD: DepositRate {
        DepositRate(
            id: UUID(),
            bank: Bank(
                id: UUID(),
                name: "Garanti BBVA",
                logoUrl: nil,
                website: nil,
                isActive: true
            ),
            currency: "USD",
            termDays: 90,
            interestRate: 12.75,
            minAmount: 500,
            updatedAt: Date()
        )
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                headerSection
                paymentCardsSection
                buttonsSection
                tagsSection
                stateSection
                depositSection
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
        }
        .background(.appBlack)
    }

    // MARK: - Section: Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("HeaderView")

            HeaderView(
                page: HeaderViewContent(
                    totalPrice: "₺45.000",
                    title: "Borçlar",
                    date: "Haziran 2026",
                    pageType: .main
                ),
                action: {},
                date: $mockDate
            )
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardRadius))
        }
    }

    // MARK: - Section: Payment Cards

    private var paymentCardsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("PaymentCards")

            PaymentCards(path: $path, action: {}, payment: mockMonthlyPayment)
            PaymentCards(path: $path, action: {}, payment: mockMonthlyPaymentPaid)
            PaymentCards(path: $path, action: {}, payment: mockOneTimePayment)
            PaymentCards(path: $path, action: {}, payment: mockClosedPayment)
        }
    }

    // MARK: - Section: Buttons

    private var buttonsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Buttons")

            HStack(spacing: 12) {
                FullButton(text: "Öde", fillColor: .black, textcolor: .appYelow, action: nil)
                SolidButton(
                    text: "Detaylar",
                    solidColor: .appYelow,
                    textColor: .appYelow,
                    action: nil
                )
            }

            HStack(spacing: 12) {
                SolidButton(
                    text: "Ödendi",
                    solidColor: .appMint,
                    textColor: .appMint,
                    isFull: true,
                    action: nil
                )
                SolidButton(
                    text: "Sil",
                    solidColor: .appRed,
                    backRoundColor: .clear,
                    textColor: .appRed,
                    action: nil
                )
            }

            HStack(spacing: 12) {
                RadioButtonView(isSelected: $radioSelected)
                Text("RadioButton")
                    .font(.appBody(14))
                    .foregroundStyle(.appYelow)
            }
        }
    }

    // MARK: - Section: Tags

    private var tagsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("InfoTags")

            HStack(spacing: 10) {
                InfoTagsView(text: "Kalan ₺4.000")
                InfoTagsView(text: "32 gün")
                InfoTagsView(text: "TRY")
            }
        }
    }

    // MARK: - Section: State Views

    private var stateSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("State Views")

            EmptyPaymentsView(
                title: "Ödeme bulunamadı",
                subtitle: "Henüz eklenmiş bir ödeme yok"
            )

            DepositStateView(
                title: "Yükleniyor",
                subtitle: "TRY için 32 gün verileri getiriliyor.",
                systemImage: "hourglass"
            )

            DepositStateView(
                title: "Veri alınamadı",
                subtitle: "Sunucuya ulaşılamadı.",
                systemImage: "wifi.exclamationmark",
                actionTitle: "Tekrar dene",
                action: {}
            )
        }
    }

    // MARK: - Section: Deposit

    private var depositSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("DepositRateCard")

            DepositRateCardView(rate: mockDepositRate, principalAmount: 100000)
            DepositRateCardView(rate: mockDepositRateUSD, principalAmount: 5000)

            sectionTitle("DepositFilterBar")

            DepositFilterBarView(
                selectedCurrency: .constant(.turkishLira),
                selectedTerm: .constant(.initial),
                resultCount: 8
            )
        }
    }

    // MARK: - Helpers

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.appCaption(13))
            .foregroundStyle(.appMint.opacity(0.6))
            .textCase(.uppercase)
            .padding(.top, 8)
    }
}

#Preview {
    ArmanView()
}
