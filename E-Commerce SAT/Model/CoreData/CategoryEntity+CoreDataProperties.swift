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
    @NSManaged public var childCategories: [Int]

    class func insetAll(categoryList: [Category], rankingList:[Ranking]) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("appDeletegate not found")
            return
        }

        let context = appDelegate.persistentContainer.viewContext
        
        for categoryData in categoryList {

            let categoryEntity = CategoryEntity(context: context)
            categoryEntity.id = Int16(categoryData.id)
            categoryEntity.name = categoryData.name
            categoryEntity.childCategories = categoryData.childCategories
            
            // Save products
            for product in categoryData.products {
                
                let productEntity = ProductEntity(context: context)
                productEntity.id = Int16(product.id)
                productEntity.name = product.name
                productEntity.dateAdded = product.dateAdded
                
                // Setting product ratings i.e. orderCount, viewCount, shares
                for list in rankingList {
                    
                    if let firstProduct = (list.products.filter { $0.id == product.id}).first {
                        
                        if let orderCount = firstProduct.orderCount {
                            productEntity.orderCount = Int32(orderCount)
                        }

                        if let viewCount = firstProduct.viewCount {
                            productEntity.viewCount = Int32(viewCount)
                        }

                        if let shares = firstProduct.shares {
                            productEntity.shares = Int32(shares)
                        }

                    }
                    
                }
                
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
        
    class func fetch(predicate: NSPredicate?=nil) -> [CategoryEntity]? {
     
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("appDeletegate not found")
            return nil
        }

        let context = appDelegate.persistentContainer.viewContext

        do {
            let req:NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
            if let predicate = predicate {
                req.predicate = predicate
            }
            
            let categoryData = try context.fetch(req)
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
