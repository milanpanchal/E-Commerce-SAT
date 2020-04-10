//
//  CategoryCollectionViewCell.swift
//  E-Commerce SAT
//
//  Created by Milan Panchal on 09/04/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak private var categoryName: UILabel! {
        didSet {
            categoryName.textColor = UIColor.themeColorDarkBlack
            categoryName.textAlignment = .center
            categoryName.font = UIFont.systemFont(ofSize: 20)
            categoryName.numberOfLines = 0
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

    func setCategory(category: CategoryViewModel) {
        categoryName.text = category.name
    }
    
    func setCategory(category: CategoryEntity) {
        categoryName.text = category.name ?? ""
    }
}
