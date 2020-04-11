//
//  CategoryViewModel.swift
//  E-Commerce SAT
//
//  Created by Milan Panchal on 09/04/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import Foundation

struct CategoryViewModel {

    private let category: CategoryEntity
    
    public init(_ category: CategoryEntity) {
      self.category = category
    }

    public var name: String? {
        return category.name
    }

}
