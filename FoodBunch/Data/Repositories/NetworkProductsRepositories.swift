//
//  NetworkProductsRepositories.swift
//  FoodBunch
//
//  Created by Furkan ic on 21.04.2025.
//

class NetworkProductsRepository: ProductRepositoryInterface {
    
    func retrieveProducts() async throws -> [Product] {
        try await (NetworkClient().send(APIEndpoints.retrieveProducts) as RetrieveProductsDTO).products
    }

    func retrieveProductDetail(id: String) async throws -> Product? {
        try await NetworkClient().send(APIEndpoints.retrieveProductDetail(id))
    }
}
