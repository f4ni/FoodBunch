//
//  ProductListViewModel.swift
//  FoodBunch
//
//  Created by Furkan ic on 21.04.2025.
//

import Foundation
import Combine

final class ProductListViewModel: ProductListViewModelInterface {
    private let productsUseCase: ProductsUseCaseInterface
    
    @Published var products: [Product]?
    @Published var state: AppState = .idle
    private var cancellables: Set<AnyCancellable> = []
    
    init(productsUseCase: ProductsUseCaseInterface = ProductsUseCase()) {
        self.productsUseCase = productsUseCase
        setupBindings()
    }
    
    private func setupBindings() {
        (productsUseCase as? ProductsUseCase)?.$products
            .assign(to: &$products)
    }
    
    func retrieveProducts() {
        guard case .idle = state else { return }
        
        state = .loading
        Task { [weak self] in
            guard let self else { return }
            do {
                try self.productsUseCase.execute(for: .productList)
                state = .idle
            } catch let error {
                state = .error(error)
                debugPrint(error)
            }
        }
    }
}

enum AppState {
    case idle
    case loading
    case error(Error)
}
