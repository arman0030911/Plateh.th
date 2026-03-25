

import Foundation
import CoreData

class FetchPaymentsManager: FetchPaymentDataSource {
    let context = PersistentContainer.shared.persistentContainer.viewContext
    
    func fetchPayments(date: Date?, includeClosed: Bool, completion: @escaping (Result<[Payment], Error>) -> Void) {
        context.perform { [weak self] in
            guard let self = self else { return }
            
            let req = PaymentEntitly.fetchRequest()
            var predicates: [NSPredicate] = []
            
            if let date {
                let predicate = NSPredicate(format: "lastPay >= %@ AND lastPay <= %@",
                    date.startOfMonth as NSDate,
                    date.endOfMonth as NSDate)
                predicates.append(predicate)
            }

            if !includeClosed {
                predicates.append(NSPredicate(format: "isClosed == NO"))
            }

            if predicates.count == 1 {
                req.predicate = predicates[0]
            } else if predicates.count > 1 {
                req.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            }
            
            req.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
            
            do {
                let payments = try self.context.fetch(req)
                let domainPayments = payments.map { PaymentMapper.toDomain(from: $0) }
                completion(.success(domainPayments))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
