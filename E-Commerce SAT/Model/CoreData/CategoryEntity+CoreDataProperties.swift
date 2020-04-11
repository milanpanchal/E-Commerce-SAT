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

extension CategoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryEntity> {
        return NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var parentCategoryId: Int16
    @NSManaged public var products: Set<ProductEntity>?
    @NSManaged public var childCategories: [Int]

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
