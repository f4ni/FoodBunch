//
//  MockNetworkProductsRepository.swift
//  FoodBunch
//
//  Created by Furkan ic on 24.04.2025.
//


import Testing
@testable import FoodBunch
import Combine
import Foundation

extension ProductRepositoryInterface where Self: MockNetworkProductsRepository {
    var retrieveRemoteDataCallCount: Int {
        0
    }
}

class MockNetworkProductsRepository: ProductRepositoryInterface {

    
    var retrieveProductsCalled = false
    var retrieveProductDetailCalled = false
    var productDetailID: String?
    var shouldThrowError = false

    func retrieveProducts() async throws -> [Product] {
        retrieveProductsCalled = true
        if shouldThrowError {
            throw NSError(domain: "NetworkError", code: 404, userInfo: nil)
        }
        return [Product(product_id: "mock1", name: "Mock Network Product", price: 25, image: "", description: "")]
    }

    func retrieveProductDetail(id: String) async throws -> Product? {
        retrieveProductDetailCalled = true
        productDetailID = id
        if shouldThrowError {
            throw NSError(domain: "NetworkError", code: 500, userInfo: nil)
        }
        return Product(product_id: id, name: "Mock Network Detail", price: 30, image: "", description: "")
    }
    
    func saveProducts(_ products: [FoodBunch.Product]) async throws {
        
    }
}
