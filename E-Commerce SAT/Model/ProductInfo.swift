//
//  ProductInfo.swift
//  E-Commerce SAT
//
//  Created by Milan Panchal on 09/04/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import Foundation

struct ProductInfo: Codable {
    let categories: [Category]
    let rankings: [Ranking]
}

struct Category: Codable {
    let id: Int
    let name: String
    let products: [Product]
    let childCategories: [Int]
    
}

struct Product: Codable {
    let id: Int
    let name: String
    let dateAdded: Date?
    let variants: [Variant]
    // let tax: Tax?
}

struct Variant: Codable {
    let id: Int
    let color: String
    let size: Int?
    let price: Int
}

/* struct Tax: Codable {
       let name: String
       let value: Double
   } */


struct Ranking: Codable {
    let ranking: String
    let products: [Product]
    
    struct Product: Codable {
        let id: Int
        let viewCount: Int?
        let orderCount: Int?
        let shares: Int?
    }

}
