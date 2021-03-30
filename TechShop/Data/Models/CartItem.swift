//
//  CartItem.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 16/01/21.
//

import SwiftUI

class CartItem: ObservableObject, Identifiable, Codable {
    var _id: String
    var name: String
    var price: Double
    var image: String
    var imageData: Data?
    var countInStock: Int
    var quantity: Int
    
    init(_id: String, name: String, price: Double, image: String, imageData: Data? = nil, countInStock: Int, quantity: Int) {
        self._id = _id
        self.name = name
        self.price = price
        self.image = image
        self.imageData = imageData
        self.countInStock = countInStock
        self.quantity = quantity
    }
    
    func getImage() -> Image? {
        if let data = imageData {
            if let uiImage = UIImage(data: data) {
                return Image(uiImage: uiImage)
            }
        }
        
        return nil
    }
}
