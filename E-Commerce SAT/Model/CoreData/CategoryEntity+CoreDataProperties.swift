//
//  CategoryEntity+CoreDataProperties.swift
//  E-Commerce SAT
//
//  Created by Milan Panchal on 09/04/20.
//  Copyright © 2020 Heady. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

extension CategoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryEntity> {
        return NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var parentCategoryId: Int16
    @NSManaged public var products: Set<ProductEntity>?

    class func insetAll(categoryList: [Category]) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("appDeletegate not found")
            return
        }

        let context = appDelegate.persistentContainer.viewContext
        
        for categoryData in categoryList {

            let categoryEntity = CategoryEntity(context: context)
            categoryEntity.id = Int16(categoryData.id)
            categoryEntity.name = categoryData.name
            
            // Save products
            for product in categoryData.products {
                
                let productEntity = ProductEntity(context: context)
                productEntity.id = Int16(product.id)
                productEntity.name = product.name
                productEntity.dateAdded = product.dateAdded
                
                // Setting product variant
                for varient in product.variants {
                    
                    let varientEntity = ProductVarientEntity(context: context)
                    varientEntity.id = Int16(varient.id)
                    varientEntity.size = Int16(varient.size ?? -1)
                    varientEntity.color = varient.color
                    varientEntity.price = Int32(varient.price)
                    
                    productEntity.addToVariants(varientEntity)
                    
                }
                
                // TODO: tax
                
                categoryEntity.addToProducts(productEntity)
            }
            
            
        }
        
        
        do {
           try context.save()
          } catch let saveError {
           print("Failed saving \(saveError)")
        }

    }
    
    class func inset(categoryData: Category) {
        insetAll(categoryList: [categoryData])
    }
    
    class func fetch() -> [CategoryEntity]? {
     
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("appDeletegate not found")
            return nil
        }

        let context = appDelegate.persistentContainer.viewContext

        do {
            let categoryData = try context.fetch(CategoryEntity.fetchRequest()) as? [CategoryEntity]
            return categoryData
            
        } catch let fetchError {
            print("Fetch Error: \(fetchError)")
        }
        
        return nil
    }
    
    class func deleteAllData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("appDeletegate not found")
            return
        }

        let context = appDelegate.persistentContainer.viewContext

        do {
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: CategoryEntity.fetchRequest())
            try context.execute(batchDeleteRequest)

        } catch let deleteAllError {
            print("Delete All Error: \(deleteAllError)")
        }
        
    }
    
}

// MARK: Generated accessors for products
extension CategoryEntity {

    @objc(addProductsObject:)
    @NSManaged public func addToProducts(_ value: ProductEntity)

    @objc(removeProductsObject:)
    @NSManaged public func removeFromProducts(_ value: ProductEntity)

    @objc(addProducts:)
    @NSManaged public func addToProducts(_ values: NSSet)

    @objc(removeProducts:)
    @NSManaged public func removeFromProducts(_ values: NSSet)

}
