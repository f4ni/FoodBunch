//
//  MockProductsUseCaseInterface.swift
//  FoodBunch
//
//  Created by Furkan ic on 24.04.2025.
//


import Testing
@testable import FoodBunch
import Combine
import Foundation

final class MockProductsUseCase: ProductsUseCaseInterface {
    var networkRepository: ProductRepositoryInterface = NetworkProductsRepository()
    
    var coreDataRepository: ProductRepositoryInterface = CoreDataProductsRepositories()
    
    var products: [FoodBunch.Product]?
    
    var product: FoodBunch.Product?
    
    var executeCallCount = 0
    var executeDataType: FetchDataType?
    var shouldThroughError = false
    
    func execute(for type: FoodBunch.FetchDataType) throws {
        executeCallCount += 1
        executeDataType = type
        if shouldThroughError {
            throw NSError(domain: "MockError", code: 12, userInfo: nil)
        }
        
        switch type {
        case .productList:
            self.products = [Product(product_id: "1", name: "Mock Product", price: 10, image: "", description: "")]
        case .productDetail(let id):
            self.product = Product(product_id: id, name: "Mock Detail", price: 20, image: "", description: "")
        }
    }
}
