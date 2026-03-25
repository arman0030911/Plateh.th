//
//  SetPaymentDataSource.swift
//  Plateh.th
//
//  Created by Adis on 23.03.2026.
//

import Foundation

protocol SetPaymentDataSource: AnyObject{ 
    func setPayment(payment: Payment ) throws
}
