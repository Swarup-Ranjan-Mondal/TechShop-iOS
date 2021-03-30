//
//  Order.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 19/01/21.
//

import SwiftUI

class OrderItem: Codable, Identifiable {
    var product: String
    var name: String
    var price: Double
    var image: String
    var imageData: Data?
    var qty: Int
    
    init(_id: String, name: String, price: Double, image: String, imageData: Data? = nil, quantity: Int) {
        self.product = _id
        self.name = name
        self.price = price
        self.image = image
        self.imageData = imageData
        self.qty = quantity
    }
}

class Order: Codable {
    var orderItems: [OrderItem]
    var shippingAddress: ShippingAddress
    var paymentMethod: String
    var itemsPrice: Double
    var shippingPrice: Double
    var taxPrice: Double
    var totalPrice: Double
    
    init(
        orderItems: [OrderItem],
        shippingAddress: ShippingAddress,
        paymentMethod: String,
        itemsPrice: Double,
        shippingPrice: Double,
        taxPrice: Double,
        totalPrice: Double
    ) {
        self.orderItems = orderItems
        self.shippingAddress = shippingAddress
        self.paymentMethod = paymentMethod
        self.itemsPrice = itemsPrice
        self.shippingPrice = shippingPrice
        self.taxPrice = taxPrice
        self.totalPrice = totalPrice
    }
}
