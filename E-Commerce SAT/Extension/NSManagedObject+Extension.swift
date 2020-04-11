//
//  NSManagedObject+Extension.swift
//  E-Commerce SAT
//
//  Created by Milan Panchal on 11/04/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import UIKit
import CoreData

extension NSManagedObject {

     /// Returns the entity name for the current class.
     
     static var entityName : String {
         return String(describing:self)
     }
     
     
     /// Returns the entity description for the current class.
     
     static var entityDescription : NSEntityDescription {
         return NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)!
     }

     
     /// Returns the current managed object context.
     
     static var managedObjectContext : NSManagedObjectContext {
         return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
     }
     
    class func countAll() -> Int {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            return try managedObjectContext.count(for: request)
        } catch {
            print(error.localizedDescription)
            return 0
        }
    }
    
    /// Delete all objects of the current entity.
    
    class func deleteAll() throws {
        
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            try managedObjectContext.execute(batchDeleteRequest)
            
        } catch let deleteAllError {
            print("Delete All Error for \(entityName): \(deleteAllError)")
        }
        
        do {
            try managedObjectContext.save()
        } catch let deleteError {
            print("Failed deleting \(deleteError)")
        }
    }

    /// Fetch all objects of the current entity.

    class func fetchAll<T:NSManagedObject>() throws -> [T]? {
        do {
            return try fetch(predicate: nil, sortDescriptor: nil)
        } catch let fetchAllError {
            print("Fetch All Error for \(entityName): \(fetchAllError)")
        }
        
        return nil
    }
    
    /// Fetch all objects of the current entity based on predicate.
    
    class func fetch<T:NSManagedObject>(predicate: NSPredicate?=nil, sortDescriptor: NSSortDescriptor?=nil) throws -> [T]? {

        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)

            // Add predicate if any
            if let predicate = predicate {
                request.predicate = predicate
            }
            
            // Add sortDescriptor if any
            if let sortDescriptor = sortDescriptor {
                request.sortDescriptors = [sortDescriptor]
            }

            let fetchData = try managedObjectContext.fetch(request)
            return fetchData as? [T]
        
                        
        } catch let fetchError {
            print("Fetch Error for \(entityName): \(fetchError)")
        }
        
        return nil
    }
    
    class func saveAllInventory(productInfo: ProductInfo) {
        
        let categoryList = productInfo.categories
        let rankingList = productInfo.rankings
                
        for categoryData in categoryList {

            let categoryEntity = CategoryEntity(context: managedObjectContext)
            categoryEntity.id = Int16(categoryData.id)
            categoryEntity.name = categoryData.name
            categoryEntity.childCategories = categoryData.childCategories
            
            // Setting products
            let productList = createProductEntity(products: categoryData.products, rankingList: rankingList)
            categoryEntity.addToProducts(NSSet(array: productList))
            
        }
        
        
        do {
           try managedObjectContext.save()
          } catch let saveError {
           print("Failed saving \(saveError)")
        }

    }

    private class func createProductVarientEntity(variants: [Category.Product.Variant]) -> [ProductVarientEntity] {
        var variantEntityList = [ProductVarientEntity]()
        
        for varient in variants {
            
            let varientEntity = ProductVarientEntity(context: managedObjectContext)
            varientEntity.id = Int16(varient.id)
            varientEntity.size = Int16(varient.size ?? -1)
            varientEntity.color = varient.color
            varientEntity.price = Int32(varient.price)
            
            variantEntityList.append(varientEntity)
            
        }
        
        return variantEntityList
    }

    private class func createProductEntity(products: [Category.Product], rankingList: [Ranking]) -> [ProductEntity] {
        var productList = [ProductEntity]()
        
        for product in products {
            
            let productEntity = ProductEntity(context: managedObjectContext)
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
            let productVarients = createProductVarientEntity(variants: product.variants)
            productEntity.addToVariants(NSSet(array: productVarients))

            // TODO: tax            
            
            productList.append(productEntity)
            
        }
        
        return productList
    }

}
