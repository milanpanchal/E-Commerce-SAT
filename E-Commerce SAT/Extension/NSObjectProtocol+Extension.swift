//
//  NSObjectProtocol+Extension.swift
//  E-Commerce SAT
//
//  Created by Milan Panchal on 11/04/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import Foundation

extension NSObjectProtocol {

    var className: String {
        return String(describing: Self.self)
    }
    

    static var className: String {
        return String(describing: self)
    }

}
