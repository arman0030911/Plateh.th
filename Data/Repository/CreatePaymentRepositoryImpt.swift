//
//  CreatePaymentRepository.swift
//  Plateh.th
//
//  Created by Adis on 14.03.2026.
//

import Foundation

class CreatePaymentRepositoryImpt: CreatePaymentRepository{ 
    private let dataSource: CreatePaymentDataSource 
    init(dataSource: CreatePaymentDataSource) {
        self.dataSource = dataSource
    }
    func createPayment(payment: Payment) throws {
        try dataSource.createNewPayment(payment: payment)
    }
}
