//
//  FetchPaymentsUseCase.swift
//  Plateh.th
//
//  Created by Adis on 16.03.2026.
//

import Foundation

protocol FetchPaymentsUseCase: AnyObject {
    func execute(from date: Date?, includeClosed: Bool, completion: @escaping (Result<[Payment], Error>) -> Void)
}

class FetchPaymentsUseCaseImpl: FetchPaymentsUseCase {
    private let repository: FetchPaymentsRepository

    init(repository: FetchPaymentsRepository) {
        self.repository = repository
    }

    func execute(from date: Date?, includeClosed: Bool, completion: @escaping (Result<[Payment], Error>) -> Void) {
        repository.fetchPayments(from: date, includeClosed: includeClosed, completion: completion)
    }
}
