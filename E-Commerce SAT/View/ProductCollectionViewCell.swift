//
//  ProductCollectionViewCell.swift
//  E-Commerce SAT
//
//  Created by Milan Panchal on 10/04/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak private var productNameLbl: UILabel! {
        didSet {
            productNameLbl.textColor = UIColor.themeColorDarkBlack
            productNameLbl.font = UIFont.boldSystemFont(ofSize: 14)
            productNameLbl.numberOfLines = 0
        }
    }
    
    @IBOutlet weak private var colorAndSizeLbl: UILabel! {
        didSet {
            colorAndSizeLbl.textColor = UIColor.themeColorDarkBlack
            colorAndSizeLbl.font = UIFont.systemFont(ofSize: 12)
        }
    }

    @IBOutlet weak private var priceLbl: UILabel! {
        didSet {
            priceLbl.textColor = UIColor.themeColorRed
            priceLbl.font = UIFont.boldSystemFont(ofSize: 12)
            
        }
    }

        
    // MARK: - UICollectionViewCell methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCell()
    }

    // MARK: - User defined methods
    
    fileprivate func setupCell() {

        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = false
        
        self.addShadow()
    }
     
    fileprivate func addShadow() {
        self.layer.shadowOffset = CGSize(width: 1, height: 0)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.25
    }
    
    func setProduct(product: ProductEntity) {
        productNameLbl.text = product.name
        
        if let firstVariant = product.variants?.first {
            
            let currencyFormatter = NumberFormatter()
            currencyFormatter.usesGroupingSeparator = true
            currencyFormatter.numberStyle = .currency
            currencyFormatter.locale = Locale(identifier: "en_IN")

            let priceString = currencyFormatter.string(from: NSNumber(value: firstVariant.price))!
            priceLbl.text = priceString
            
            var colorSize = "Color: \(firstVariant.color ?? "NA")"
            
            if firstVariant.size != -1 {
                colorSize += " | Size: \(firstVariant.size)"
            }
            colorAndSizeLbl.text = colorSize
        }
    }
}
