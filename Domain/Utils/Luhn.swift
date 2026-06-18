import Foundation

public struct Luhn {
    public static func validate(_ number: String) -> Bool {
        let digits = number.compactMap { $0.wholeNumberValue }
        guard digits.count >= 12 else { return false }

        let sum = digits.reversed().enumerated().reduce(0) { acc, pair in
            let (idx, digit) = pair
            if idx % 2 == 1 {
                let d = digit * 2
                return acc + (d > 9 ? d - 9 : d)
            } else {
                return acc + digit
            }
        }
        return sum % 10 == 0
    }
}
