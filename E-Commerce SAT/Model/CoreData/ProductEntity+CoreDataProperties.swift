//
//  ProductEntity+CoreDataProperties.swift
//  E-Commerce SAT
//
//  Created by Milan Panchal on 09/04/20.
//  Copyright © 2020 Heady. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

extension ProductEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductEntity> {
        return NSFetchRequest<ProductEntity>(entityName: "ProductEntity")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var dateAdded: Date?
    @NSManaged public var variants: Set<ProductVarientEntity>?
    @NSManaged public var tax: ProductTaxEntity?

    class func fetch(predicate: NSPredicate?=nil) -> [ProductEntity]? {
     
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("appDeletegate not found")
            return nil
        }

        let context = appDelegate.persistentContainer.viewContext

        do {
            let req:NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
            if let predicate = predicate {
                req.predicate = predicate
            }
            
            let fetchData = try context.fetch(req)
            return fetchData
            
        } catch let fetchError {
            print("Fetch Error: \(fetchError)")
        }
        
        return nil
    }

}

// MARK: Generated accessors for variants
extension ProductEntity {

    @objc(addVariantsObject:)
    @NSManaged public func addToVariants(_ value: ProductVarientEntity)

    @objc(removeVariantsObject:)
    @NSManaged public func removeFromVariants(_ value: ProductVarientEntity)

    @objc(addVariants:)
    @NSManaged public func addToVariants(_ values: NSSet)

    @objc(removeVariants:)
    @NSManaged public func removeFromVariants(_ values: NSSet)

}
