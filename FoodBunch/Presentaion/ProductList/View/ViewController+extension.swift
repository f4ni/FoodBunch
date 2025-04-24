//
//  ViewController+extension.swift
//  FoodBunch
//
//  Created by Furkan ic on 23.04.2025.
//

import SwiftUI

let productlistCellIdentifier = "productlistcellidentifier"

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard (viewModel.products?.count ?? 0) > indexPath.item,
              let product = viewModel.products?[indexPath.item]
        else {
            return UICollectionViewCell()
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: productlistCellIdentifier, for: indexPath)
        cell.contentConfiguration = UIHostingConfiguration(
            content: {
                ProductListCellView(
                    name: product.name,
                    imageUrl: product.image,
                    price: "\(product.price)"
                )
        })

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard (viewModel.products?.count ?? 0) > indexPath.item,
              let product = viewModel.products?[indexPath.item]
        else { return }
        
        
        showDetail(for: product.product_id)
    }
}
