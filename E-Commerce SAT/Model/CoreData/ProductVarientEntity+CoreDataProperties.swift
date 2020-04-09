//
//  ProductVarientEntity+CoreDataProperties.swift
//  E-Commerce SAT
//
//  Created by Milan Panchal on 09/04/20.
//  Copyright © 2020 Heady. All rights reserved.
//
//

import Foundation
import CoreData


extension ProductVarientEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductVarientEntity> {
        return NSFetchRequest<ProductVarientEntity>(entityName: "ProductVarientEntity")
    }

    @NSManaged public var id: Int16
    @NSManaged public var color: String?
    @NSManaged public var size: Int16
    @NSManaged public var price: Int32

}
