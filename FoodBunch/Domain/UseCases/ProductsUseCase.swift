//
//  ProductsUseCase.swift
//  FoodBunch
//
//  Created by Furkan ic on 21.04.2025.
//

import Combine

enum FetchDataType {
    case productList
    case productDetail(id: String)
}

final class ProductsUseCase: ProductsUseCaseInterface {
    var networkRepository: ProductRepositoryInterface
    var coreDataRepository: ProductRepositoryInterface
    
    @Published var products: [Product]?
    @Published var product: Product?
    
    init(
        networkRepository: ProductRepositoryInterface = NetworkProductsRepository(),
    coreDataRepository: ProductRepositoryInterface = CoreDataProductsRepositories()
    ) {
        self.networkRepository = networkRepository
        self.coreDataRepository = coreDataRepository
    }
    
    func execute(for type: FetchDataType) throws {
        
        Task(priority: .background) {
            try retrieveRemoteData(for: type)
        }
        try retrieveLocalData(for: type)

    }
    
    private func retrieveLocalData(for type: FetchDataType) throws {
        Task { [weak self] in
            switch type {
            case .productList:
                self?.products = try await self?.coreDataRepository.retrieveProducts()
            case .productDetail(id: let id):
                self?.product = try await self?.coreDataRepository.retrieveProductDetail(id: id)
            }
        }
    }
        
    private func retrieveRemoteData(for type: FetchDataType) throws {
        switch type {
        case .productList:
            Task { [weak self] in
                guard let self else { return }
                
                self.products = try await self.networkRepository.retrieveProducts()
                try await self.updateLocalData(for: type, with: self.products)
            }
        case .productDetail(let id):
            Task { [weak self] in
                guard let self
                else {
                    return
                }
                self.product = try await self.networkRepository.retrieveProductDetail(id: id)
                try await self.updateLocalData(for: type, with: self.product)
            }
        }
    }
    
    private func updateLocalData<T>(for type: FetchDataType, with value: T) async throws {
        switch type {
        case .productList:
            if let value = value as? [Product] {
                try await coreDataRepository.saveProducts(value)
            }
        case .productDetail:
            if let product = value as? Product {
                try await coreDataRepository.saveProducts([product])
            }
        }
    }
}
