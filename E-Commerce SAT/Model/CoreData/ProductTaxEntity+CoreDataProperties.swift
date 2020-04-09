//
//  ProductTaxEntity+CoreDataProperties.swift
//  E-Commerce SAT
//
//  Created by Milan Panchal on 09/04/20.
//  Copyright © 2020 Heady. All rights reserved.
//
//

import Foundation
import CoreData


extension ProductTaxEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductTaxEntity> {
        return NSFetchRequest<ProductTaxEntity>(entityName: "ProductTaxEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var tax: Double

}
