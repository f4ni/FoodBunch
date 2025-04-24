//
//  DetailViewModelInterface.swift
//  FoodBunch
//
//  Created by Furkan ic on 24.04.2025.
//


protocol DetailViewModelInterface {
    var product: Product? { get set}
    var state: AppState { get set }
    func retrieveProduct()
}
