import SwiftUI

struct PaymentStatus {
    let isPaid: Bool
    let isClosed: Bool
    let isShowPaymentButton: Bool
    let cardColor: Color
    let accentColor: Color
    let subtitleText: String
    let badgeTitle: String
    let badgeValue: String
    let detailsTitle: String
    let detailsStateText: String
    let detailsDateText: String

    init(payment: Payment, referenceDate: Date = .now) {
        let dueDate = Date.fromISO8601(payment.dueDate)
        let lastPayDate = payment.lastPayDate
        let closeDate = payment.closeDateValue
        let calendar = Calendar.current
        let isMonthlyPaidThisMonth = lastPayDate.map {
            calendar.isDate($0, equalTo: referenceDate, toGranularity: .month)
        } ?? false
        let dueDateText: String = {
            if let dueDate {
                return dueDate.shortTurkishDisplay
            }
            if let dueDay = payment.dueDay {
                return "\(dueDay). gün"
            }
            return "Tarih yok"
        }()

        isClosed = payment.isClosed

        switch payment.type {
        case .mounthly:
            isPaid = isClosed || isMonthlyPaidThisMonth
            detailsTitle = "Sonraki ödeme"
        case .oneTime:
            isPaid = payment.lastPayDate != nil || isClosed
            detailsTitle = "Ödeme durumu"
        }

        isShowPaymentButton = !isPaid
        cardColor = isPaid ? .appMint : .appRed
        accentColor = isPaid ? .appMint : .appYelow
        subtitleText = isPaid ? "Ödendi" : "Öde \(dueDateText)"

        if isClosed {
            badgeTitle = "Durum"
            badgeValue = "Tamamlandı"
        } else if isPaid {
            badgeTitle = payment.type == .mounthly ? "Bu ay" : "Durum"
            badgeValue = "Ödendi"
        } else {
            badgeTitle = "Öde"
            badgeValue = dueDateText
        }

        detailsStateText = isPaid ? "Ödendi" : "Bekliyor"

        if isClosed {
            detailsDateText = (closeDate ?? lastPayDate ?? dueDate ?? referenceDate).dayMonthString
        } else if isPaid {
            detailsDateText = (lastPayDate ?? dueDate ?? referenceDate).dayMonthString
        } else {
            detailsDateText = (dueDate ?? referenceDate).dayMonthString
        }
    }
}
