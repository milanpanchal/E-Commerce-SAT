//
//  ViewController.swift
//  E-Commerce SAT
//
//  Created by Milan Panchal on 09/04/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var productInfo: ProductInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NetworkManager.shared.fetchProductList() { [weak self] (productInfo) in
            self?.productInfo = productInfo
        }
    }

}

