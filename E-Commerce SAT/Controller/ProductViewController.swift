//
//  ProductViewController.swift
//  E-Commerce SAT
//
//  Created by Milan Panchal on 10/04/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {

    // MARK: - Properties
    fileprivate let reuseIdentifier = "ProductCollectionViewCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 12.0, bottom: 20.0, right: 12.0)
    fileprivate let maxHeightForCell:CGFloat = 200
    fileprivate let itemsPerRow: CGFloat = 2.0

    var productEntityList:[ProductEntity] = []

    
    @IBOutlet weak private var productCollectionView: UICollectionView! {
        didSet {
            productCollectionView.backgroundColor = UIColor.themeColorBackground
            productCollectionView.alwaysBounceVertical = true
            productCollectionView.delegate = self
            productCollectionView.dataSource = self
        }
    }
    

    // MARK: - View controller life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.navigationItem.title = Constants.NavigationBarTitle.product
        
        if self.productEntityList.count == 0 {
            
            productEntityList = ProductEntity.fetch() ?? []
        }
    }

    // MARK: - User defined methods

}


extension ProductViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if productEntityList.count == 0 {
            collectionView.setEmptyMessage("No product found")
        } else {
            collectionView.restore()
        }
        return productEntityList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProductCollectionViewCell
        cell.setProduct(product: productEntityList[indexPath.item])
        return cell
    }

}

extension ProductViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: maxHeightForCell)
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
