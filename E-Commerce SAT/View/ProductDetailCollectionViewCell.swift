//
//  ProductDetailCollectionViewCell.swift
//  E-Commerce SAT
//
//  Created by Milan Panchal on 12/04/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import UIKit

class ProductDetailCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak private var productNameLbl: UILabel! {
        didSet {
            productNameLbl.textColor = UIColor.themeColorDarkBlack
            productNameLbl.font = UIFont.boldSystemFont(ofSize: 18)
        }
    }

    @IBOutlet weak private var colorLbl: UILabel! {
        didSet {
            colorLbl.textColor = UIColor.themeColorDarkBlack
            colorLbl.font = UIFont.systemFont(ofSize: 16)
        }
    }

    @IBOutlet weak private var sizeLbl: UILabel! {
        didSet {
            sizeLbl.textColor = UIColor.themeColorDarkBlack
            sizeLbl.font = UIFont.systemFont(ofSize: 16)
        }
    }

    @IBOutlet weak private var priceLbl: UILabel! {
        didSet {
            priceLbl.textColor = UIColor.themeColorDarkBlack
            priceLbl.font = UIFont.systemFont(ofSize: 16)
            
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
   
    func setProductVarient(for varientVM: ProductVarientViewModel) {
        productNameLbl.text = varientVM.name
        priceLbl.text = varientVM.formattedPrice
        colorLbl.text = varientVM.color
        sizeLbl.text  = varientVM.size
    }

}
