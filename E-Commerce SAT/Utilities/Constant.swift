//
//  Constant.swift
//  E-Commerce SAT
//
//  Created by Milan Panchal on 09/04/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import Foundation

struct Constants {

    struct API {
        static let baseUrl = "https://stark-spire-93433.herokuapp.com/json"
    }

    struct NavigationBarTitle {
        static let category = "Category"
        static let product = "Product"
    }

}


struct Platform {
    static let isSimulator: Bool = {
        #if arch(i386) || arch(x86_64)
            return true
        #else
            return false
        #endif
    }()
}
