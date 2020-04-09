//
//  ProductInfoViewModel.swift
//  E-Commerce SAT
//
//  Created by Milan Panchal on 09/04/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import Foundation

class CategoryViewModel: NSObject {

    private let productInfo: ProductInfo
    
    public init(productInfo: ProductInfo) {
      self.productInfo = productInfo
    }

    public var name: String {
        return productInfo
    }

}
