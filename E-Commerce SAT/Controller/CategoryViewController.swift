//
//  CategoryViewController.swift
//  E-Commerce SAT
//
//  Created by Milan Panchal on 09/04/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    // MARK: - Properties
    fileprivate let reuseIdentifier = "CategoryCollectionViewCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 12.0, bottom: 10.0, right: 12.0)
    fileprivate var itemsPerRow: CGFloat = 1
    fileprivate let maxHeightForCell:CGFloat = 150
    
    lazy fileprivate var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = UIColor.themeColorRed
        return refreshControl
    }()
    
    @IBOutlet weak private var categoryCollectionView: UICollectionView! {
        didSet {
            categoryCollectionView.backgroundColor = UIColor.white
            categoryCollectionView.alwaysBounceVertical = true
            categoryCollectionView.delegate = self
            categoryCollectionView.dataSource = self
            categoryCollectionView.refreshControl = refreshControl
            categoryCollectionView.isHidden = true
        }
    }
    
    @IBOutlet weak var listGridBtn: UIBarButtonItem!


    private var categoryVMList:[CategoryViewModel] = []
    
    // MARK: - View controller life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
            
        self.navigationItem.title = NavigationBarTitle.selectCategory
        self.toggleListGridImage()
        
        self.apiCallToFetchAllCategoryList()
        
    }

    // MARK: - User defined methods

    fileprivate func apiCallToFetchAllCategoryList() {

        NetworkManager.shared.fetchProductList() { [weak self] (productInfo) in
            
            self?.categoryVMList = productInfo.categories.map({ return CategoryViewModel(category: $0)})
            
            DispatchQueue.main.async {

                // TODO: 
                CategoryEntity.deleteAllData()
                CategoryEntity.insetAll(categoryList: productInfo.categories)
                
                if let fetchData = CategoryEntity.fetch() {
                    _ = fetchData.map { (obj) -> Void in
                        print(">>>>> CategoryName " + (obj.name ?? "") + "Product Names: \(obj.products?.first?.dateAdded)" + "Count: \(obj.products?.count)")
                    }
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
        
        if categoryVMList.count == 0 {
            collectionView.setEmptyMessage("No data found")
        } else {
            collectionView.restore()
        }
        return categoryVMList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
        cell.setCategory(categoryVM: categoryVMList[indexPath.item])
        return cell
    }

}

extension CategoryViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: min(widthPerItem, maxHeightForCell))
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
