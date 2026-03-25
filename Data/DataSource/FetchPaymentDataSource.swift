//
//  FetchPaymentDataSource.swift
//  Plateh.th
//
//  Created by Adis on 16.03.2026.
//

import Foundation

protocol FetchPaymentDataSource {
    func fetchPayments(date: Date?, includeClosed: Bool, completion: @escaping (Result<[Payment], Error>) -> Void)
}
