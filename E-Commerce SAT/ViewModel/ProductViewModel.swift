//
//  ProductViewModel.swift
//  E-Commerce SAT
//
//  Created by Milan Panchal on 11/04/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import Foundation

struct ProductViewModel {
    
    private let product: ProductEntity
    private let displayMode: ProductDisplayView
    
    public init(productEntity: ProductEntity, displayMode: ProductDisplayView) {
        self.product = productEntity
        self.displayMode = displayMode
    }
    
    public var name: String? {
        return product.name
    }
    
    public var colorSize: String {
        
        guard let firstVariant = product.variants?.first else {
            return ""
        }
        
        var colorSize = "Color: \(firstVariant.color ?? "NA")"
        
        if firstVariant.size != -1 {
            colorSize += " | Size: \(firstVariant.size)"
        }
        return colorSize
        
    }
    
    public var formattedPrice: String? {
        
        guard let firstVariant = product.variants?.first else {
            return nil
        }
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "en_IN")
        
        return currencyFormatter.string(from: NSNumber(value: firstVariant.price))
        
    }
    
    public var valueForCounts: String {
        
        switch displayMode {
        case .mostOrderedProducts:
            return "\(product.orderCount) Ordered"
        case .mostViewdProdcuts:
            return "\(product.viewCount) Viewed"
        case .mostSharedProducts:
            return "\(product.shares) Shared"
        default:
            return ""
        }
        
    }
    
}
