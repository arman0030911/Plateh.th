//
//  SetPaymentRepositoryIMPL.swift
//  Plateh.th
//
//  Created by Adis on 23.03.2026.
//

import Foundation

class SetPaymentRepositoryImpl: SetPaymentRepository {
    private let dataSource: SetPaymentDataSource 
    init (dataSource: SetPaymentDataSource) { 
        self.dataSource = dataSource 
        
    }
    
    func setPayment(payment: Payment) throws {
        try dataSource.setPayment(payment: payment )
    }
    
 
    
}
