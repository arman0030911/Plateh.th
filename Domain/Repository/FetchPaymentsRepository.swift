//
//  FetchPaymentsRepository.swift
//  Plateh.th
//
//  Created by Adis on 16.03.2026.
//

import Foundation

protocol FetchPaymentsRepository: AnyObject {
    func fetchPayments(from date: Date?, includeClosed: Bool, completion: @escaping (Result<[Payment], Error>) -> Void)
}
