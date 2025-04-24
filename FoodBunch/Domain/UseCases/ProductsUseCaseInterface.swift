//
//  ProductsUseCaseInterface.swift
//  FoodBunch
//
//  Created by Furkan ic on 24.04.2025.
//


protocol ProductsUseCaseInterface {
    var networkRepository: ProductRepositoryInterface { get }
    var coreDataRepository: ProductRepositoryInterface { get }
    
    var products: [Product]? { get set }
    var product: Product? { get set }
    
    func execute(for type: FetchDataType) throws
}
