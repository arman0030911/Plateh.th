//
//  Deposit.swift
//  Plateh.th
//
//  Created by Adis on 11.04.2026.
//

import Foundation

struct Deposit: Identifiable {  // Добавь Identifiable
    let id = UUID()              // Добавь эту строку
    let bankName: String
    let rate: Double
}

let fakeDeposits = [
    Deposit(bankName: "Ziraat Bankası", rate: 45.5),
    Deposit(bankName: "Garanti BBVA", rate: 43.2),
    Deposit(bankName: "İş Bankası", rate: 44.0),
    Deposit(bankName: "Yapı Kredi", rate: 42.8)
]
