//
//  MockCoreDataProductsRepository.swift
//  FoodBunch
//
//  Created by Furkan ic on 24.04.2025.
//



import Testing
@testable import FoodBunch
import Combine
import Foundation

extension ProductRepositoryInterface where Self: MockCoreDataProductsRepository {
    var retrieveLocalDataCallCount: Int {
        0
    }
}

class MockCoreDataProductsRepository: ProductRepositoryInterface {
    var retrieveProductsCalled = false
    var retrieveProductDetailCalled = false
    var productDetailID: String?
    var savedProducts: [Product] = []
    var shouldThrowError = false

    func retrieveProducts() async throws -> [Product] {
        retrieveProductsCalled = true
        if shouldThrowError {
            throw NSError(domain: "CoreDataError", code: 101, userInfo: nil)
        }
        return [Product(product_id: "local1", name: "Mock Local Product", price: 15, image: "", description: "")]
    }

    func retrieveProductDetail(id: String) async throws -> Product? {
        retrieveProductDetailCalled = true
        productDetailID = id
        if shouldThrowError {
            throw NSError(domain: "CoreDataError", code: 102, userInfo: nil)
        }
        return Product(product_id: id, name: "Mock Local Detail", price: 35, image: "", description: "")
    }

    func saveProducts(_ products: [Product]) async throws {
        savedProducts.append(contentsOf: products)
        if shouldThrowError {
            throw NSError(domain: "CoreDataError", code: 103, userInfo: nil)
        }
    }
}
