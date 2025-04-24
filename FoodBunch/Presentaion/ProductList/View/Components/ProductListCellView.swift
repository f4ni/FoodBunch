//
//  ProductListCellView.swift
//  FoodBunch
//
//  Created by Furkan ic on 23.04.2025.
//

import SwiftUI

struct ProductListCellView: View {
    
    let name: String
    let imageUrl: String
    let price: String
    
    var body: some View {
        VStack/*(spacing: 12)*/ {
            if let url = URL(string: imageUrl) {
                CAsyncImage(url: url)
                    .frame(width: 80, height: 80)
                    .clipShape(Rectangle())
            }
            Text(name)
                .font(.title3)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(price)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    ProductListCellView(name: "product13", imageUrl: "", price: "242")
}
