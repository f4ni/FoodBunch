//
//  ProductRepositoryInterface.swift
//  FoodBunch
//
//  Created by Furkan ic on 22.04.2025.
//

protocol ProductRepositoryInterface {
    func retrieveProducts() async throws -> [Product]
    func retrieveProductDetail(id: String) async throws -> Product?
    
    func saveProducts(_ products: [Product]) async throws
}

extension ProductRepositoryInterface where Self: NetworkProductsRepository {
    func saveProducts(_ products: [Product]) async throws {}
}
