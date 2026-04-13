//
//  DepositModels.swift
//  Plateh.th
//
//  Created by Adis on 13.04.2026.
//

import Foundation

// MARK: - Bank Model
struct Bank: Codable {
    let id: UUID
    let name: String
    let logoUrl: String?
    let website: String?
    let isActive: Bool
}

// MARK: - DepositRate Model
struct DepositRate: Codable, Identifiable {
    let id: UUID
    let bank: Bank
    let currency: String
    let termDays: Int
    let interestRate: Double
    let minAmount: Double?
    let updatedAt: Date?
}
