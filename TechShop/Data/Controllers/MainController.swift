//
//  MainController.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 09/01/21.
//

import SwiftUI
import BraintreePayPal

class MainController: ObservableObject {
    static var shared = MainController()
    
    private static let userController = UserController()
    private static let productController = ProductController()
    private static let cartController = CartController()
    private static let orderController = OrderController()
    
    let paymentMethods = ["PayPal"]
    
    @Published var products: [Product] = []
    @Published var product: Product = Product()
    
    @Published var user: User = User()
    @Published var isLoggedIn = false
    @Published var users: [UserData] = []
    
    @Published var cartItems: [CartItem] = []
    @Published var shippingAddress: ShippingAddress = ShippingAddress()
    @Published var paymentMethod: String = ""
    
    @Published var order: OrderDetails = OrderDetails()
    @Published var myOrders: [MyOrder] = []
    @Published var orders: [ListedOrder] = []
    
    @Published var loading: Bool = false
    @Published var errorMessage: String = ""
    
    @Published var selection: String? = nil
    @Published var selectedIdOrScreen: String = ""
    
    @Published var braintreeClient: BTAPIClient?
    
    
    /* Products functions */
    func listProducts() {
        MainController.productController.listProducts()
    }
    
    func getProductDetails(productId: String, completionHandler: @escaping () -> Void) {
        MainController.productController.getProductDetails(productId: productId, completionHandler: completionHandler)
    }
    
    func createProduct(completionHandler: @escaping () -> Void) {
        MainController.productController.createProduct(completionHandler: completionHandler)
    }
    
    func updateProduct(product: ProductData, completionHandler: @escaping () -> Void) {
        MainController.productController.updateProduct(product: product, completionHandler: completionHandler)
    }
    
    func deleteProduct(_ productId: String) {
        MainController.productController.deleteProduct(productId: productId)
    }
    
    func createProductReview(productId: String, review: CreateReview) {
        MainController.productController.createProductReview(productId: productId, review: review)
    }
    /* end */
    
    
    /* User functions */
    func register(name: String, email: String, password: String) {
        MainController.userController.register(name: name, email: email, password: password)
    }
    
    func login(email: String, password: String) {
        MainController.userController.login(email: email, password: password)
    }
    
    func logout() {
        MainController.userController.logout()
    }
    
    func updateUserProfile(name: String, email: String, password: String) {
        MainController.userController.updateUserProfile(name: name, email: email, password: password)
    }
    
    func listUsers() {
        MainController.userController.listUsers()
    }
    
    func getUserDetails(_ userId: String, completionHandler: @escaping (UserData) -> Void) {
        MainController.userController.getUserDetails(userId: userId, completionHandler: completionHandler)
    }
    
    func updateUser(_ user: UserData, completionHandler: @escaping () -> Void) {
        MainController.userController.updateUser(user: user, completionHandler: completionHandler)
    }
    
    func deleteUser(_ userId: String) {
        MainController.userController.deleteUser(userId: userId)
    }
    
    func loadUserData() {
        MainController.userController.loadUserData()
    }
    /* end */
    
    
    /* Cart functions */
    func addToCart(_ item: Product, quantity: Int) {
        MainController.cartController.addToCart(product: item, quantity: quantity)
    }
    
    func deleteFromCart(_ itemId: String) {
        MainController.cartController.deleteFromCart(itemId: itemId)
    }
    
    func loadCartItems() {
        MainController.cartController.loadCartItems()
    }
    
    func saveCartItems() {
        MainController.cartController.saveCartItems()
    }
    
    func saveShippingAddress() {
        MainController.cartController.saveShippingAddress()
    }
    
    func loadShippingAddress() {
        MainController.cartController.loadShippingAddress()
    }
    
    func savePaymentMethod() {
        MainController.cartController.savePaymentMethod()
    }
    
    func loadPaymentMethod() {
        MainController.cartController.loadPaymentMethod()
    }
    
    func getTotalItems() -> Int {
        return self.cartItems.reduce(0, { acc, item in
            acc + item.quantity
        })
    }
    
    func getItemsTotalPrice() -> Double {
        return self.cartItems.reduce(0.0, { acc, item in
            acc + Double(item.quantity) * item.price
        })
    }
    /* end */
    
    
    /* Order functions */
    func createOrder(itemsPrice: Double, shippingPrice: Double, taxPrice: Double, totalPrice: Double) {
        MainController.orderController.createOrder(itemsPrice: itemsPrice, shippingPrice: shippingPrice, taxPrice: taxPrice, totalPrice: totalPrice)
    }
    
    func getOrderDetails(_ orderId: String) {
        MainController.orderController.getOrderDetails(orderId: orderId)
    }
    
    func listOrders() {
        MainController.orderController.listOrders()
    }
    
    func getMyOrders() {
        MainController.orderController.getMyOrders()
    }
    
    func makePayment(orderId: String, amount: Double) {
        MainController.orderController.makePayment(orderId: orderId, amount: amount)
    }
    
    func deliverOrder(orderId: String) {
        MainController.orderController.deliverOrder(orderId: orderId)
    }
    /* end */
}

