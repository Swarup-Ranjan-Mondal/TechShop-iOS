//
//  OrderController.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 19/01/21.
//

import SwiftUI
import BraintreePayPal

class CreatedOrder: Codable {
    var _id: String = ""
}

struct UserInfo: Codable {
    var _id: String = ""
    var name: String = ""
    var email: String?
}

class OrderDetails: Codable {
    var _id: String = ""
    var orderItems: [OrderItem] = []
    var user: UserInfo = UserInfo()
    var shippingAddress: ShippingAddress = ShippingAddress()
    var paymentMethod: String = ""
    var itemsPrice: Double?
    var shippingPrice: Double = 0.0
    var taxPrice: Double = 0.0
    var totalPrice: Double = 0.0
    var isPaid: Bool = false
    var isDelivered: Bool = false
    var createdAt: String = ""
    var updatedAt: String = ""
    var paidAt: String?
    var deliveredAt: String?
}

class ListedOrder: Identifiable, Codable {
    var _id: String = ""
    var totalPrice: Double = 0.0
    var createdAt: String = ""
    var updatedAt: String = ""
    var isPaid: Bool = false
    var isDelivered: Bool = false
    var paidAt: String?
    var deliveredAt: String?
    var user: UserInfo
}

class MyOrder: Identifiable, Codable {
    var _id: String = ""
    var totalPrice: Double = 0.0
    var createdAt: String = ""
    var updatedAt: String = ""
    var isPaid: Bool = false
    var isDelivered: Bool = false
    var paidAt: String?
    var deliveredAt: String?
}

struct PaymentResult: Codable {
    var id: String
    var payer: Payer
    var status: String
    var update_time: String
    
    init(
        id: String,
        email: String,
        payerId: String,
        payerFirstName: String,
        payerLastName: String,
        status: String,
        updateTime: String
    ) {
        self.id = id
        self.payer = Payer()
        self.payer.email_address = email
        self.payer.payer_id = payerId
        self.payer.firstName = payerFirstName
        self.payer.lastName = payerLastName
        self.status = status
        self.update_time = updateTime
    }
    
    class Payer: Codable {
        var email_address: String = ""
        var payer_id: String = ""
        var firstName: String = ""
        var lastName: String = ""
    }
}

class OrderResponse: Codable {
    var _id: String
    var orderItems: [OrderItem]
    var shippingAddress: ShippingAddress
    var paymentMethod: String
    var shippingPrice: Double
    var taxPrice: Double
    var totalPrice: Double
    var isDelivered: Bool
    var isPaid: Bool
    var paidAt: String
    var deliveredAt: String?
}

class OrderController {
    @ObservedObject var main = MainController.shared
    
    func createOrder(itemsPrice: Double, shippingPrice: Double, taxPrice: Double, totalPrice: Double) {
        self.main.errorMessage = ""
        var orderItems: [OrderItem] = []
        for item in main.cartItems {
            let orderItem = OrderItem(_id: item._id, name: item.name, price: item.price, image: item.image, quantity: item.quantity)
            orderItems.append(orderItem)
        }
        
        if let url = URL(string: "\(serverURL)/api/orders") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(main.user.token)", forHTTPHeaderField: "Authorization")
            let order = Order(
                orderItems: orderItems,
                shippingAddress: main.shippingAddress,
                paymentMethod: main.paymentMethod,
                itemsPrice: itemsPrice,
                shippingPrice: shippingPrice,
                taxPrice: taxPrice,
                totalPrice: totalPrice
            )
            
            let encodedData = try? JSONEncoder().encode(order)
            //print(String(data: encodedData!, encoding: .utf8)!)
            
            request.httpBody = encodedData
            URLSession.shared.dataTask(with: request) { (data, response, _) in
                if let webData = data {
                    if let json = try? JSONDecoder().decode(CreatedOrder.self, from: webData) {
                        DispatchQueue.main.async {
                            self.getOrderDetails(orderId: json._id)
                        }
                    } else if let error = try? JSONDecoder().decode(ErrorResponse.self, from: webData) {
                        DispatchQueue.main.async {
                            self.main.errorMessage = error.message
                        }
                    }
                }
            }
            .resume()
        }
    }
    
    func getOrderDetails(orderId: String) {
        self.main.errorMessage = ""
        if let url = URL(string: "\(serverURL)/api/orders/\(orderId)") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(main.user.token)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: request) { (data, response, _) in
                if let webData = data {
                    if let json = try? JSONDecoder().decode(OrderDetails.self, from: webData) {
                        DispatchQueue.main.async {
                            self.main.order = json
                            self.main.order.itemsPrice = json.orderItems.reduce(0.0, { acc, item in
                                acc + Double(item.qty) * item.price
                            })
                            
                            for i in 0..<json.orderItems.count {
                                if let imageData = getImageDataFromURL("\(serverURL)\(json.orderItems[i].image)") {
                                    self.main.order.orderItems[i].imageData = imageData
                                }
                            }
                            
                            self.main.loading = false
                            self.main.selection = "OrderScreen"
                        }
                    } else if let error = try? JSONDecoder().decode(ErrorResponse.self, from: webData) {
                        DispatchQueue.main.async {
                            self.main.errorMessage = error.message
                        }
                    }
                }
            }
            .resume()
        }
    }
    
    func listOrders() {
        self.main.loading = true
        if let url = URL(string: "\(serverURL)/api/orders") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(main.user.token)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: request) { (data, response, _) in
                if let webData = data {
                    if let json = try? JSONDecoder().decode([ListedOrder].self, from: webData) {
                        DispatchQueue.main.async {
                            self.main.loading = false
                            self.main.orders = json
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
    
    func getMyOrders() {
        self.main.errorMessage = ""
        if let url = URL(string: "\(serverURL)/api/orders/myorders") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(main.user.token)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: request) { (data, response, _) in
                if let webData = data {
                    if let json = try? JSONDecoder().decode([MyOrder].self, from: webData) {
                        DispatchQueue.main.async {
                            self.main.myOrders = json
                        }
                    } else if let error = try? JSONDecoder().decode(ErrorResponse.self, from: webData) {
                        DispatchQueue.main.async {
                            self.main.errorMessage = error.message
                        }
                    }
                }
            }
            .resume()
        }
    }
    
    func makePayment(orderId: String, amount: Double) {
        let payPalDriver = BTPayPalDriver(apiClient: main.braintreeClient!)

        let request = BTPayPalCheckoutRequest(amount: "\(amount)")
        request.currencyCode = "USD"
        

        payPalDriver.tokenizePayPalAccount(with: request) { (tokenizedPayPalAccount, error) in
            if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                // Access additional information
                let id = tokenizedPayPalAccount.nonce
                let email = tokenizedPayPalAccount.email
                let payerId = tokenizedPayPalAccount.payerID
                let firstName = tokenizedPayPalAccount.firstName
                let lastName = tokenizedPayPalAccount.lastName

                // Getting the current date and time as String
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let date = Date()
                let dateString = dateFormatter.string(from: date)

                let paymentResult = PaymentResult(
                    id: id,
                    email: email!,
                    payerId: payerId!,
                    payerFirstName: (firstName ?? "Unknown"),
                    payerLastName: (lastName ?? ""),
                    status: "COMPLETED",
                    updateTime: dateString
                )

                DispatchQueue.main.async {
                    self.payOrder(orderId: orderId, paymentResult: paymentResult)
                }
            } else if let error = error {
                self.main.errorMessage = error.localizedDescription
            } else {
                // Buyer canceled payment approval
            }
        }
    }
    
    func deliverOrder(orderId: String) {
        self.main.loading = true
        if let url = URL(string: "\(serverURL)/api/orders/\(orderId)/deliver") {
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("Bearer \(main.user.token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { (data, response, _) in
                if let webData = data {
                    if let json = try? JSONDecoder().decode(OrderResponse.self, from: webData) {
                        DispatchQueue.main.async {
                            self.getOrderDetails(orderId: json._id)
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
    
    private func payOrder(orderId: String, paymentResult: PaymentResult) {
        self.main.loading = true
        if let url = URL(string: "\(serverURL)/api/orders/\(orderId)/pay") {
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(main.user.token)", forHTTPHeaderField: "Authorization")
            
            let encodedData = try? JSONEncoder().encode(paymentResult)
            //print(String(data: encodedData!, encoding: .utf8)!)
            
            request.httpBody = encodedData
            URLSession.shared.dataTask(with: request) { (data, response, _) in
                if let webData = data {
                    if let json = try? JSONDecoder().decode(OrderResponse.self, from: webData) {
                        DispatchQueue.main.async {
                            self.getOrderDetails(orderId: json._id)
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
}
