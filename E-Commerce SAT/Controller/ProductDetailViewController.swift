//
//  ProductDetailViewController.swift
//  E-Commerce SAT
//
//  Created by Milan Panchal on 12/04/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {

    // MARK: - Properties

    
    var productEntity:ProductEntity?
    
    fileprivate var variants:[ProductVarientViewModel] = []
    fileprivate let reuseIdentifier = ProductDetailCollectionViewCell.className
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 12.0, bottom: 20.0, right: 12.0)

    @IBOutlet weak private var productDetailCollectionView: UICollectionView! {
        didSet {
            productDetailCollectionView.backgroundColor = UIColor.themeColorBackground
            productDetailCollectionView.alwaysBounceVertical = true
            productDetailCollectionView.delegate = self
            productDetailCollectionView.dataSource = self
        }
    }
    

    // MARK: - View controller life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.themeColorBackground
        self.navigationItem.title = Constants.NavigationBarTitle.productDetail
        
        if let productVarients = productEntity?.variants {
            let variantsVM = Array(productVarients).map( { return ProductVarientViewModel(name: productEntity?.name, varient: $0)})
            variants.append(contentsOf: variantsVM)
        }
        
                
    }
    
}


extension ProductDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return variants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProductDetailCollectionViewCell
        cell.setProductVarient(for: variants[indexPath.item])
        return cell
    }
        
}

extension ProductDetailViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthPerItem = collectionView.frame.width - (sectionInsets.left * 4)
        let heightPerItem = collectionView.frame.height - (sectionInsets.top * 2)

        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
