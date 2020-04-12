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
    fileprivate let reuseIdentifier = ProductCollectionViewCell.className
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 12.0, bottom: 20.0, right: 12.0)
    fileprivate let maxHeightForCell:CGFloat = 220
    fileprivate let itemsPerRow: CGFloat = 2.0
    
    var productEntityList:[ProductEntity] = []
    var navigationTitle: String?
    var productDisplayView: ProductDisplayView = .allProducts
    
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

        if productEntityList.count == 0 {
            setupProductView(productDisplayView: .mostViewdProdcuts)
        } else {
            setupProductView(productDisplayView: .categoryProducts)
        }
    }
    
    // MARK: - User defined methods
    
    fileprivate func setupProductView(productDisplayView: ProductDisplayView) {
        
        self.productDisplayView = productDisplayView
        
        var predicate: NSPredicate? = nil
        var sortDescriptor: NSSortDescriptor? = nil
        
        switch productDisplayView {
            
        case .mostViewdProdcuts:
            navigationTitle = Constants.NavigationBarTitle.mostViewdProduct
            predicate = NSPredicate(format: "viewCount > 0")
            sortDescriptor = NSSortDescriptor(key: "viewCount", ascending: false)
            
        case.mostOrderedProducts:
            navigationTitle = Constants.NavigationBarTitle.mostOrderedProduct
            predicate = NSPredicate(format: "orderCount > 0")
            sortDescriptor = NSSortDescriptor(key: "orderCount", ascending: false)
            
        case .mostSharedProducts:
            navigationTitle = Constants.NavigationBarTitle.mostSharedProduct
            predicate = NSPredicate(format: "shares > 0")
            sortDescriptor = NSSortDescriptor(key: "shares", ascending: false)
            
        case .allProducts:
            navigationTitle = Constants.NavigationBarTitle.product
            sortDescriptor = NSSortDescriptor(key: "name", ascending: true)

        case .categoryProducts:
//            navigationTitle = <<already set from parent class>>
            sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            self.navigationItem.rightBarButtonItem = nil
        }
        
        self.navigationItem.title = navigationTitle

        if productDisplayView != .categoryProducts {
            
            if let fetchList = try? ProductEntity.fetch(predicate: predicate, sortDescriptor: sortDescriptor) as? [ProductEntity] {
                productEntityList = fetchList
            }

            productCollectionView.resetScrollPositionToTop()
            productCollectionView.reloadData()

        }
        
        
    }
    
    @IBAction func didTapOnSwiftProductView(_ sender: UIBarButtonItem) {
    
        let alert = UIAlertController(title: Constants.Message.selectOneTitle,
                                      message: Constants.Message.selectOneMsg,
                                      preferredStyle: .actionSheet)

        
        alert.addAction(UIAlertAction(title: Constants.NavigationBarTitle.mostViewdProduct, style: .default) { (action) in
            self.setupProductView(productDisplayView: .mostViewdProdcuts)
        })

        alert.addAction(UIAlertAction(title: Constants.NavigationBarTitle.mostOrderedProduct, style: .default) { (action) in
            self.setupProductView(productDisplayView: .mostOrderedProducts)
        })

        alert.addAction(UIAlertAction(title: Constants.NavigationBarTitle.mostSharedProduct, style: .default) { (action) in
            self.setupProductView(productDisplayView: .mostSharedProducts)
        })
        
        alert.addAction(UIAlertAction(title: Constants.Message.allProdcutsAToZ, style: .default) { (action) in
            self.setupProductView(productDisplayView: .allProducts)
        })


        alert.addAction(UIAlertAction(title: Constants.Message.cancel, style: .cancel, handler: nil))

        self.present(alert, animated: true)

    }
    
}


extension ProductViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if productEntityList.count == 0 {
            collectionView.setEmptyMessage(Constants.Message.noProductFound)
        } else {
            collectionView.restore()
        }
        return productEntityList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProductCollectionViewCell
        
        let productViewModel = ProductViewModel(productEntity: productEntityList[indexPath.item],
                                                displayMode: productDisplayView)
        cell.setProduct(productViewModel: productViewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let productDetailVC = storyboard?.instantiateViewController(identifier: ProductDetailViewController.className) as? ProductDetailViewController else {
            return
        }
        
        productDetailVC.productEntity = productEntityList[indexPath.item]
        self.navigationController?.pushViewController(productDetailVC, animated: true)
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
