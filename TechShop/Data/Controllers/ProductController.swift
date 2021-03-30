//
//  ProductController.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 16/01/21.
//

import SwiftUI

class JSONProductsResponse: Codable {
    let products: [Product]
    let page: Int
    let pages: Int
}

class ProductController {
    @ObservedObject var main = MainController.shared
    
    func listProducts() {
        self.main.loading = true
        if let url = URL(string: "\(serverURL)/api/products") {
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let webData = data {
                    if let json = try? JSONDecoder().decode(JSONProductsResponse.self, from: webData) {
                        DispatchQueue.main.async {
                            for i in 0 ..< json.products.count {
                                json.products[i].imageData = getImageDataFromURL("\(serverURL)\(json.products[i].image)")
                            }
                            self.main.products = json.products
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.main.loading = false
                }
            }.resume()
        }
    }
    
    func getProductDetails(productId: String, completionHandler: @escaping () -> Void) {
        self.main.loading = true
        if let url = URL(string: "\(serverURL)/api/products/\(productId)") {
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let webData = data {
                    if let json = try? JSONDecoder().decode(Product.self, from: webData) {
                        DispatchQueue.main.async {
                            json.imageData = getImageDataFromURL("\(serverURL)\(json.image)")
                            self.main.product = json
                            completionHandler()
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.main.loading = false
                }
            }.resume()
        }
    }
    
    
//    _id: "6030267a87dce00ccbb76346"
//
//    brand: "Sample brand"
//
//    category: "Sample category"
//
//    countInStock: 0
//
//    createdAt: "2021-02-19T20:58:34.011Z"
//
//    description: "Sample description"
//
//    image: "/images/sample.jpg"
//
//    name: "Sample name"
//
//    numReviews: 0
//
//    price: 0
//
//    rating: 0
//
//    reviews: [] (0)
//
//    updatedAt: "2021-02-19T20:58:34.011Z"
//
//    user: "5fdf62cbc33f005a60877850"
    
    func createProduct(completionHandler: @escaping () -> Void) {
        if let url = URL(string: "\(serverURL)/api/products") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Bearer \(main.user.token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { (data, response, _) in
                if let webData = data {
                    if let json = try? JSONDecoder().decode(Product.self, from: webData) {
                        DispatchQueue.main.async {
                            self.main.product = json
                            self.main.loading = false
                            completionHandler()
                        }
                    } else if let error = try? JSONDecoder().decode(ErrorResponse.self, from: webData) {
                        DispatchQueue.main.async {
                            self.main.loading = false
                            self.main.errorMessage = error.message
                        }
                    }
                }
            }
            .resume()
        }
    }
   
//    _id: "5fdf62cbc33f005a60877858"
//
//    brand: "Amazon"
//
//    category: "Electronics"
//
//    countInStock: 0
//
//    createdAt: "2020-12-20T14:42:19.795Z"
//
//    description: "Meet Echo Dot - Our most popular smart speaker with a fabric design. It is our most compact smart speaker that fits perfectly into smal…"
//
//    image: "/images/alexa.jpg"
//
//    name: "Amazon Echo Dot 3rd Generation"
//
//    numReviews: 12
//
//    price: 29
//
//    rating: 4
//
//    reviews: [] (0)
//
//    updatedAt: "2021-02-20T21:31:38.311Z"
//
//    user: "5fdf62cbc33f005a60877850"
    
    func updateProduct(product: ProductData, completionHandler: @escaping () -> Void) {
        self.main.loading = true
        if let url = URL(string: "\(serverURL)/api/products/\(product._id)") {
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("Bearer \(main.user.token)", forHTTPHeaderField: "Authorization")
            request.setValue("Application/JSON", forHTTPHeaderField: "Content-Type")
            
            let encodedData = try? JSONEncoder().encode(product)
            //print(String(data: encodedData!, encoding: .utf8)!)
            
            request.httpBody = encodedData
            URLSession.shared.dataTask(with: request) { (data, response, _) in
                if let webData = data {
                    if let _ = try? JSONDecoder().decode(Product.self, from: webData) {
                        DispatchQueue.main.async {
                            self.main.product = Product()
                            self.main.loading = false
                            completionHandler()
                        }
                    } else if let error = try? JSONDecoder().decode(ErrorResponse.self, from: webData) {
                        DispatchQueue.main.async {
                            self.main.loading = false
                            self.main.errorMessage = error.message
                        }
                    }
                }
            }
            .resume()
        }
    }
    
    func deleteProduct(productId: String) {
        if let url = URL(string: "\(serverURL)/api/products/\(productId)") {
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.setValue("Bearer \(main.user.token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { (data, response, _) in                if let webData = data {
                    if let json = try? JSONDecoder().decode([String : String].self, from: webData) {
                        DispatchQueue.main.async {
                            if json["message"]! == "Product removed" {
                                self.listProducts()
                            } else {
                                self.main.errorMessage = json["message"]!
                            }
                        }
                    }
                }
            }
            .resume()
        }
    }
    
    func createProductReview(productId: String, review: CreateReview) {
        if let url = URL(string: "\(serverURL)/api/products/\(productId)/reviews") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Bearer \(main.user.token)", forHTTPHeaderField: "Authorization")
            request.setValue("Application/JSON", forHTTPHeaderField: "Content-Type")
            
            let encodedData = try? JSONEncoder().encode(review)
            //print(String(data: encodedData!, encoding: .utf8)!)
            
            request.httpBody = encodedData
            URLSession.shared.dataTask(with: request) { (data, response, _) in
                if let webData = data {
                    if let json = try? JSONDecoder().decode([String : String].self, from: webData) {
                        DispatchQueue.main.async {
                            if json["message"]! == "Review added" {
                                self.getProductDetails(productId: productId, completionHandler: {})
                            } else {
                                self.main.errorMessage = json["message"]!
                            }
                        }
                    }
                }
            }
            .resume()
        }
    }
    
    private func extractImageName(imageLocation: String) -> String {
        let startIndex = imageLocation.index(after: imageLocation.lastIndex(of: "/")!)
        let endIndex = imageLocation.index(before: imageLocation.lastIndex(of: ".")!)
        return String(imageLocation[startIndex...endIndex])
    }
}
