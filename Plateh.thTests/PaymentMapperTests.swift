//
//  PaymentMapperTests.swift
//  Plateh.thTests
//
//  Created by Adis on 25.03.2026.
//



import Foundation
import CoreData
import XCTest
@testable import Plateh_th  // Имя твоего основного таргета

final class PaymentMapperTests: XCTestCase {
    
    private var dateFormatter: ISO8601DateFormatter!
    private var context: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        dateFormatter = ISO8601DateFormatter()
        
        // Создаем in-memory Core Data контекст для тестов (не сохраняет на диск)
        let container = NSPersistentContainer(name: "db") // имя твоей модели
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { _, error in
            XCTAssertNil(error)
        }
        context = container.viewContext
    }
    
    override func tearDown() {
        context = nil
        dateFormatter = nil
        super.tearDown()
    }
    
    // MARK: - toDomain Tests
    
    func testToDomainConvertsDateToString() {
        // Given (Дано)
        let entity = PaymentEntitly(context: context)
        entity.id = "test-123"
        entity.title = "Test Payment"
        entity.type = 0 // mounthly
        entity.paymentAmount = 100
        entity.totalAmount = 1000
        entity.isNotificationEnables = true
        
        let testDate = Date(timeIntervalSince1970: 1609459200) // 1 Jan 2021
        entity.createdAt = testDate
        entity.dueDate = testDate
        entity.lastPay = testDate
        
        // When (Когда)
        let domain = PaymentMapper.toDomain(from: entity)
        
        // Then (Тогда)
        XCTAssertEqual(domain.id, "test-123")
        XCTAssertEqual(domain.title, "Test Payment")
        
        // Проверяем конвертацию Date → String
        let expectedDateString = dateFormatter.string(from: testDate)
        XCTAssertEqual(domain.createdAt, expectedDateString)
        XCTAssertEqual(domain.dueDate, expectedDateString)
        XCTAssertEqual(domain.lastPay, expectedDateString)
    }
    
    func testToDomainHandlesNilDates() {
        // Given
        let entity = PaymentEntitly(context: context)
        entity.id = "test-456"
        entity.title = "No Date Payment"
        entity.createdAt = nil // Nil date
        entity.dueDate = nil
        entity.lastPay = nil
        
        // When
        let domain = PaymentMapper.toDomain(from: entity)
        
        // Then
        // Если createdAt nil, должен быть .now (или пустая строка, смотри логику маппера)
        XCTAssertFalse(domain.createdAt.isEmpty) 
        XCTAssertNil(domain.dueDate)
        XCTAssertNil(domain.lastPay)
    }
    
    // MARK: - toEntitie Tests
    
    func testToEntitieConvertsStringToDate() {
        // Given
        let dateString = "2021-01-01T00:00:00Z"
        let payment = Payment(
            id: "test-789",
            type: .oneTime,
            title: "String Date Test",
            description: "Test",
            paymentAmount: 50.0,
            totalAmount: 500.0,
            dueDay: 15,
            dueDate: dateString,
            isNotificationEnabled: false,
            createdAt: dateString,
            lastPay: dateString,
            storedRemainingAmount: 500.0,
            isClosedStored: false,
            closeDate: nil
        )
        
        // When
        let entity = PaymentMapper.toEntitie(from: payment, context: context)
        
        // Then
        XCTAssertEqual(entity.id, "test-789")
        XCTAssertNotNil(entity.createdAt)
        
        // Проверяем обратную конвертацию String → Date
        if let createdDate = entity.createdAt {
            let convertedBack = dateFormatter.string(from: createdDate)
            XCTAssertEqual(convertedBack, dateString)
        } else {
            XCTFail("createdAt should not be nil")
        }
    }
    
    func testToEntitieHandlesInvalidDateString() {
        // Given
        let invalidPayment = Payment(
            id: "test-000",
            type: .mounthly,
            title: "Invalid",
            description: "",
            paymentAmount: 0,
            totalAmount: 0,
            dueDay: nil,
            dueDate: "invalid-date-string", // Невалидная строка
            isNotificationEnabled: true,
            createdAt: "also-invalid",
            lastPay: nil,
            storedRemainingAmount: 0,
            isClosedStored: false,
            closeDate: nil
        )
        
        // When
        let entity = PaymentMapper.toEntitie(from: invalidPayment, context: context)
        
        // Then
        // При невалидной строке должен быть nil (или current date для createdAt)
        XCTAssertNil(entity.dueDate)
        XCTAssertNil(entity.lastPay)
        // createdAt не должен быть nil (там fallback на Date())
        XCTAssertNotNil(entity.createdAt)
    }
}
