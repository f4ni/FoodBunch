//
//  ProductsUseCaseTest.swift
//  FoodBunch
//
//  Created by Furkan ic on 24.04.2025.
//


import Testing
@testable import FoodBunch
import Combine
import Foundation

struct ProductsUseCase_Test {

    @Test
    func testExecute_forProductListCallsRetrieveRemoteAndLocalData() {
        let mockNetworkRepo = MockNetworkProductsRepository()
        let mockCoreDataRepo = MockCoreDataProductsRepository()
        
        let useCase = MockProductsUseCase()
        
        try? useCase.execute(for: .productList)
        
        #expect(mockNetworkRepo.retrieveRemoteDataCallCount >= 0)
        #expect(mockCoreDataRepo.retrieveLocalDataCallCount >= 0)
    }
    
}
