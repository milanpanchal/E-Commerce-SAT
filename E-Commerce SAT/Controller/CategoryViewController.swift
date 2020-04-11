//
//  CategoryViewController.swift
//  E-Commerce SAT
//
//  Created by Milan Panchal on 09/04/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import UIKit
import MBProgressHUD

class CategoryViewController: UIViewController {

    // MARK: - Properties
    fileprivate let reuseIdentifier = "CategoryCollectionViewCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 12.0, bottom: 10.0, right: 12.0)
    fileprivate let maxHeightForCell:CGFloat = 100

    fileprivate var itemsPerRow: CGFloat = 1
    fileprivate var navigationTitle: String = Constants.NavigationBarTitle.category
    fileprivate var categoryEntityList:[CategoryEntity] = []

    lazy fileprivate var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = UIColor.themeColorRed
        return refreshControl
    }()
    
    @IBOutlet weak private var categoryCollectionView: UICollectionView! {
        didSet {
            categoryCollectionView.backgroundColor = UIColor.themeColorBackground
            categoryCollectionView.alwaysBounceVertical = true
            categoryCollectionView.delegate = self
            categoryCollectionView.dataSource = self
            categoryCollectionView.refreshControl = refreshControl
        }
    }
    
    @IBOutlet weak var listGridBtn: UIBarButtonItem!

    // MARK: - View controller life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
            

        if self.categoryEntityList.count == 0 {

            let predicate = NSPredicate(format: "self.parentCategoryId == -1")
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            if let fetchData = try? CategoryEntity.fetch(predicate: predicate, sortDescriptor: sortDescriptor) as? [CategoryEntity], fetchData.count > 0 {
                self.categoryEntityList = fetchData
            } else {
                categoryCollectionView.isHidden = true
                self.apiCallToFetchAllCategoryList()
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = navigationTitle
        self.toggleListGridImage()
    }

    // MARK: - User defined methods

    fileprivate func apiCallToFetchAllCategoryList() {

        let progressHUD = MBProgressHUD.showAdded(to: self.navigationController!.view, animated: true)
        
        NetworkManager.shared.fetchProductList() { [weak self] (productInfo) in
                        
            DispatchQueue.main.async {

                // Hide progressHUD
                progressHUD.hide(animated: true)
                
                // TODO: 
                try? CategoryEntity.deleteAll()
                CategoryEntity.saveAllInventory(productInfo: productInfo)
            
                if let fetchData = try? CategoryEntity.fetchAll() as? [CategoryEntity] {
                    self?.categoryEntityList = fetchData
                }
                
                // Hide refresh control if refreshing
                if let isRefreshing = self?.refreshControl.isRefreshing, isRefreshing == true {
                    self?.refreshControl.endRefreshing()
                }

                self?.categoryCollectionView.isHidden = false
                self?.categoryCollectionView.reloadData()
            }
        }

    }
    
    @objc private func pullToRefresh() {
        self.apiCallToFetchAllCategoryList()
    }

    @IBAction func didTapOnListGridBtn(_ sender: UIBarButtonItem) {
        
        itemsPerRow = (itemsPerRow == 1) ? 2 : 1

        toggleListGridImage()
        categoryCollectionView.reloadData()
    }
    
    fileprivate func toggleListGridImage() {
        
        if itemsPerRow == 1 {
            listGridBtn.image = UIImage(systemName: "circle.grid.3x3")
        } else {
            listGridBtn.image = UIImage(systemName: "list.bullet")
        }
        
    }    
}


extension CategoryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if categoryEntityList.count == 0 {
            collectionView.setEmptyMessage("No data found")
        } else {
            collectionView.restore()
        }
        return categoryEntityList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
        cell.setCategory(category: categoryEntityList[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedCategory = categoryEntityList[indexPath.row]
        
        if selectedCategory.childCategories.count > 0 { // Reload list with subcategories
            
            guard let subCateogryVC = storyboard?.instantiateViewController(identifier: "CategoryViewController") as? CategoryViewController else {
                fatalError("Unable to find storyboard")
            }
            
            let predicate = NSPredicate(format: "ANY self.id in %@", selectedCategory.childCategories)

            guard let categoryList = try? CategoryEntity.fetch(predicate: predicate, sortDescriptor: nil) as? [CategoryEntity], categoryList.count > 0 else {
                fatalError("No subcategory found")
            }
            
            subCateogryVC.itemsPerRow = self.itemsPerRow
            subCateogryVC.navigationTitle = selectedCategory.name ?? ""
            
            subCateogryVC.categoryEntityList = categoryList
            self.navigationController?.pushViewController(subCateogryVC, animated: true)
            
            
        } else if let productList = selectedCategory.products, productList.count > 0 {
            
            if let productVC = storyboard?.instantiateViewController(identifier: "ProductViewController") as? ProductViewController {
                productVC.navigationTitle = selectedCategory.name
                productVC.productEntityList = Array(productList).sorted(by: { (prod1, prod2) -> Bool in
                    return prod1.name ?? "" < prod2.name ?? ""
                })
                
                self.navigationController?.pushViewController(productVC, animated: true)

            }
        }
    }

}

extension CategoryViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = (itemsPerRow == 1) ? maxHeightForCell : widthPerItem
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
