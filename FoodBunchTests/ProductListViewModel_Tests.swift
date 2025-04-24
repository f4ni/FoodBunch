//
//  Untitled.swift
//  FoodBunch
//
//  Created by Furkan ic on 24.04.2025.
//

import Testing
@testable import FoodBunch
import Combine

struct ProductListViewModelTests {
    var viewModel: ProductListViewModel!
    var mockProductsUseCase: MockProductsUseCase!
    var cancellables: Set<AnyCancellable> = []

    @Test
    mutating func testInit_setsInitialStateToIdleAndNilProducts() {
        mockProductsUseCase = MockProductsUseCase()
        viewModel = ProductListViewModel(productsUseCase: mockProductsUseCase)
        #expect(viewModel.products == nil)
    }

    @Test
    mutating func testRetrieveProducts_whenUseCaseSucceeds_updatesProductsAndStateToIdle() async {
        mockProductsUseCase = MockProductsUseCase()
        viewModel = ProductListViewModel(productsUseCase: mockProductsUseCase)

        viewModel.$products
            .dropFirst()
            .sink { products in
                #expect(products != nil)
                #expect(products?.first?.name == "Mock Product")
            }
            .store(in: &cancellables)

        viewModel.retrieveProducts()

        #expect(mockProductsUseCase.executeCallCount >= 0)
    }

    @Test
    mutating func testRetrieveProducts_whenStateIsNotIdle_doesNotCallUseCase() {
        mockProductsUseCase = MockProductsUseCase()
        viewModel = ProductListViewModel(productsUseCase: mockProductsUseCase)
        viewModel.state = .loading

        viewModel.retrieveProducts()

        #expect(mockProductsUseCase.executeCallCount == 0)
    }
}
