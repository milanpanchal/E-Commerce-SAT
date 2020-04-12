//
//  ProductViewModelTest.swift
//  E-Commerce SATTests
//
//  Created by Milan Panchal on 12/04/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import XCTest
@testable import E_Commerce_SAT

class ProductViewModelTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testProductViewModel_MostShared() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        let productList = try? ProductEntity.fetchAll() as? [ProductEntity]
        
        XCTAssertNotNil(productList, "Product list should not be nil")
        XCTAssertEqual(productList!.count > 0, true, "There should be at least one product stored")
        
        let productEntity = productList!.first!
        productEntity.variants?.first?.price = 1000
        productEntity.variants?.first?.color = "Blue"
        productEntity.variants?.first?.size = 42
        productEntity.shares = 100

        let productVM = ProductViewModel(productEntity: productEntity,
                                         displayMode: .mostSharedProducts)
        
        XCTAssertEqual(productVM.name, productEntity.name, "Product name is not matching")
        XCTAssertEqual(productVM.formattedPrice!, "₹ 1,000.00", "Formatted price is not matching")
        XCTAssertEqual(productVM.colorSize, "Color: Blue | Size: 42", "colorSize value is not matching")
        XCTAssertEqual(productVM.valueForCounts, "100 Shared", "valueForCounts text is not matching")
        
        
    }

    func testProductViewModel_MostOrdered() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        
        if let productList = try? ProductEntity.fetchAll() as? [ProductEntity], productList.count > 0 {

            let productEntity = productList.first!
            productEntity.variants?.first?.price = 50000
            productEntity.variants?.first?.color = "Red"
            productEntity.variants?.first?.size = -1
            productEntity.orderCount = 2000

            let productVM = ProductViewModel(productEntity: productEntity,
                                             displayMode: .mostOrderedProducts)
            
            XCTAssertEqual(productVM.name, productEntity.name, "Product name is not matching")
            XCTAssertEqual(productVM.formattedPrice!, "₹ 50,000.00", "Formatted price is not matching")
            XCTAssertEqual(productVM.colorSize, "Color: Red", "colorSize value is not matching")
            XCTAssertEqual(productVM.valueForCounts, "2000 Ordered", "valueForCounts text is not matching")

        }

    }
    
    func testProductViewModel_MostViewed() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        
        if let productList = try? ProductEntity.fetchAll() as? [ProductEntity], productList.count > 0 {

            let productEntity = productList.first!
            productEntity.variants?.first?.price = 99999
            productEntity.variants?.first?.color = nil
            productEntity.variants?.first?.size = 44
            productEntity.viewCount = 123456

            let productVM = ProductViewModel(productEntity: productEntity,
                                             displayMode: .mostViewdProdcuts)
            
            XCTAssertEqual(productVM.name, productEntity.name, "Product name is not matching")
            XCTAssertEqual(productVM.formattedPrice!, "₹ 99,999.00", "Formatted price is not matching")
            XCTAssertEqual(productVM.colorSize, "Color: NA | Size: 44", "colorSize value is not matching")
            XCTAssertEqual(productVM.valueForCounts, "123456 Viewed", "valueForCounts text is not matching")

        }

    }
    
    func testFetchProctList() {
        
        let exp = expectation(description: "fetching products from server")
        
        NetworkManager.shared.fetchProductList { (products) in
        
            XCTAssertNotNil(products, "products should not be nil")
            XCTAssertTrue(products.categories.count > 0, "categories should not be empty")
            exp.fulfill()

        }
        
        
        waitForExpectations(timeout: 10.0) { (error) in
            debugPrint(error?.localizedDescription ?? "error")
        }
    }

}
