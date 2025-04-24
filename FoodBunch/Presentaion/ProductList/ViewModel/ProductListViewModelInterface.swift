//
//  ProductListViewModelInterface.swift
//  FoodBunch
//
//  Created by Furkan ic on 24.04.2025.
//


protocol ProductListViewModelInterface {
    var products: [Product]? { get set}
    var state: AppState { get set }
    func retrieveProducts()
}