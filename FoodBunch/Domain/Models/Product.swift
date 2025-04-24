//
//  Product.swift
//  FoodBunch
//
//  Created by Furkan ic on 21.04.2025.
//


struct Product: Decodable {
    let product_id: String
    let name: String
    let price: Int
    let image: String
    let description: String?
}

struct RetrieveProductsDTO: Decodable {
    let products: [Product]
}
