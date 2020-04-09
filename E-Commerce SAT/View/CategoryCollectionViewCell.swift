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
    
    @IBOutlet weak private var categoryName: UILabel!
        
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
    
    private func setupCell() {

        self.backgroundColor = UIColor.themeColorDarkBlack
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 7)
        
    }
     
    func setCategory(categoryVM: CategoryViewModel) {
        
        categoryName.textColor = UIColor.white
        categoryName.textAlignment = .center
        categoryName.font = UIFont.systemFont(ofSize: 20)
        categoryName.numberOfLines = 0
        categoryName.text = categoryVM.name
    }
}
