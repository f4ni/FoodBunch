//
//  DetailViewModel.swift
//  FoodBunch
//
//  Created by Furkan ic on 24.04.2025.
//

import Combine

final class DetailViewModel: DetailViewModelInterface {
    
    private let productsUseCase: ProductsUseCase
    private let productID: String?
    @Published var product: Product?
    var state: AppState = .idle
    
    init(
        productID: String? = nil,
        productsUseCase: ProductsUseCase = ProductsUseCase()
    ) {
        self.productsUseCase = productsUseCase
        self.productID = productID
        setupBindings()
    }
    
    private func setupBindings() {
        productsUseCase.$product
            .assign(to: &$product)
    }
    
    func retrieveProduct() {
        guard case .idle = state, let productID else { return }
        
        state = .loading
        Task { [weak self] in
            guard let self else { return }
            do {
                try self.productsUseCase.execute(for: .productDetail(id: productID))
                state = .idle
            } catch let error {
                state = .error(error)
                debugPrint(error)
            }
        }
    }
}
