//
//  CartController.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 16/01/21.
//

import SwiftUI

class CartController {
    @ObservedObject var main = MainController.shared
    
    func addToCart(product: Product, quantity: Int) {
        let item = CartItem(_id: product._id, name: product.name, price: product.price, image: product.image, imageData: product.imageData, countInStock: product.countInStock, quantity: quantity)
        
        if let index = main.cartItems.firstIndex(where: { cartItem -> Bool in
            return product._id == cartItem._id
        }) {
            main.cartItems[index] = item
        } else {
            main.cartItems.append(item)
        }
        saveCartItems()
    }
    
    func deleteFromCart(itemId: String) {
        if let index = main.cartItems.firstIndex(where: { cartItem -> Bool in
            return itemId == cartItem._id
        }) {
            main.cartItems.remove(at: index)
        }
        saveCartItems()
    }
    
    func loadCartItems() {
        DispatchQueue.global().async {
            if let data = UserDefaults.standard.data(forKey: "cartItems") {
                let decoder = JSONDecoder()
                if let decoded = try? decoder.decode([CartItem].self, from: data) {
                    DispatchQueue.main.async {
                        self.main.cartItems = decoded
                    }
                }
            }
        }
    }
    
    func saveCartItems() {
        DispatchQueue.global().async {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(self.main.cartItems) {
                UserDefaults.standard.setValue(encoded, forKey: "cartItems")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    func saveShippingAddress() {
        DispatchQueue.global().async {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(self.main.shippingAddress) {
                UserDefaults.standard.setValue(encoded, forKey: "shippingAddress")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    func loadShippingAddress() {
        DispatchQueue.global().async {
            if let data = UserDefaults.standard.data(forKey: "shippingAddress") {
                let decoder = JSONDecoder()
                if let decoded = try? decoder.decode(ShippingAddress.self, from: data) {
                    DispatchQueue.main.async {
                        self.main.shippingAddress = decoded
                    }
                }
            }
        }
    }
    
    func savePaymentMethod() {
        DispatchQueue.global().async {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(self.main.paymentMethod) {
                UserDefaults.standard.setValue(encoded, forKey: "paymentMethod")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    func loadPaymentMethod() {
        DispatchQueue.global().async {
            if let data = UserDefaults.standard.data(forKey: "paymentMethod") {
                let decoder = JSONDecoder()
                if let decoded = try? decoder.decode(String.self, from: data) {
                    DispatchQueue.main.async {
                        self.main.paymentMethod = decoded
                    }
                }
            }
        }
    }
}
