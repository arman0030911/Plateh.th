//
//  Decimal.ext.swift
//  Plateh.th
//
//  Created by Adis on 19.03.2026.
//

import Foundation
extension Double  { 
    var formattedWithoutDecimals: String { 
        let formatter = NumberFormatter ()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.maximumFractionDigits = 0 



        return formatter.string(from: self as NSNumber) ?? ""
        
        
    }

    var currencyText: String {
        "₺\(formattedWithoutDecimals)"
    }
}

extension String {
    var digitsOnly: String {
        filter(\.isNumber)
    }

    var bankFormattedAmountInput: String {
        let digits = digitsOnly
        guard !digits.isEmpty else { return "" }

        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        formatter.maximumFractionDigits = 0

        let number = NSDecimalNumber(string: digits)
        return formatter.string(from: number) ?? digits
    }

    var parsedAmountValue: Double {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return 0 }

        let cleaned = trimmed
            .replacingOccurrences(of: "₺", with: "")
            .replacingOccurrences(of: "TL", with: "")
            .replacingOccurrences(of: " ", with: "")

        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.numberStyle = .decimal

        if let value = formatter.number(from: cleaned)?.doubleValue {
            return value
        }

        let normalized = cleaned
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: ",", with: ".")

        return Double(normalized) ?? 0
    }
}
