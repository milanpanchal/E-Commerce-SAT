//
//  NetworkManager.swift
//  E-Commerce SAT
//
//  Created by Milan Panchal on 09/04/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import Foundation

final class NetworkManager: NSObject {
    
    // Create a singleton instance
    static let shared: NetworkManager = {
        return NetworkManager()
    }()


    func fetchProductList(completionHandler: @escaping (ProductInfo) -> Void) {
        
        let url = URL(string: Constants.API.baseUrl)!
        print("fetching data for url: \(url)")
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error while fetching product list: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    print("Error with the response, unexpected status code: \(String(describing: response))")
                    return
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase // convert date_added to dateAdded
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)

            do {
                
                if let data = data {
                    let productInfo = try decoder.decode(ProductInfo.self, from: data)
                    print(productInfo)
                    completionHandler(productInfo)
                }
                
            } catch let error {
                print(error)
            }
        })
        task.resume()
    }
    
}
