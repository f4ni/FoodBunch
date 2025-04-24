//
//  CoreDataProductsRepositories.swift
//  FoodBunch
//
//  Created by Furkan ic on 21.04.2025.
//

import Combine
import CoreData
import UIKit

class CoreDataProductsRepositories: ProductRepositoryInterface {
    
    private let context: NSManagedObjectContext
    @Published var products: [Product] = []
    
    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        self.context = context
    }
    
    func retrieveProducts() async throws -> [Product] {

        try await retrieveProductEntities()
            .map({ProductEntityTransformer().transform(from: $0)})
    }
    
    func retrieveProductDetail(id: String) async throws -> Product? {
        try await retrieveProducts().first(where: {$0.product_id == id})
    }
    
    func saveProducts(_ products: [Product]) async throws {
        for product in products {
            if let existingEntity = try? await retrieveProductEntities(productID: product.product_id).first {
                ProductEntityTransformer().transform(from: product, into: existingEntity)
            } else {
                let newEntity = ProductEntity(context: context)
                ProductEntityTransformer().transform(from: product, into: newEntity)
            }
            
            try context.save()
        }
    }
    
    func retrieveProductEntities(productID: String? = nil) async throws -> [ProductEntity] {
        let fetchRequest: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        if let productID = productID {
            fetchRequest.predicate = NSPredicate(format: "id == %@", productID)
        }
        return try context.fetch(fetchRequest)
    }
}

struct ProductEntityTransformer {
    func transform(from entity: ProductEntity) -> Product {
        Product(
            product_id: entity.id ?? "",
            name: entity.name ?? "",
            price: Int(entity.price),
            image: entity.image ?? "",
            description: entity.desc
        )
    }
    
    func transform(from product: Product, into entity: ProductEntity) {
        entity.id = product.product_id
        entity.name = product.name
        entity.price = Int16(Int32(product.price))
        entity.image = product.image
    }
}
