//
//  OrderPage.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 18/01/21.
//

import SwiftUI

struct PlaceOrderScreenView: View {
    @ObservedObject var main = MainController.shared
    
    var body: some View {
        let itemsPrice: Double = main.getItemsTotalPrice()
        let shippingPrice: Double = itemsPrice > 100 ? 0 : 10
        let taxPrice: Double = itemsPrice * 0.15
        let totalPrice: Double = itemsPrice + shippingPrice + taxPrice
        
        ScrollView {
            VStack(spacing: 10) {
                VStack(spacing: 10) {
                    Separator()
                        .padding(.bottom, 12)
                    
                    Heading(systemName: "house.circle.fill", text: "SHIPPING")
                    
                    HStack(spacing: 15) {
                        VStack {
                            Text("Address:")
                            Spacer()
                        }
                        
                        VStack {
                            Text("\(main.shippingAddress.address),")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(main.shippingAddress.city),")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(main.shippingAddress.postalCode),")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(main.shippingAddress.country)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .foregroundColor(Color(.systemGray))
                    .padding(.horizontal, 20)
                    
                    Separator()
                        .padding(.vertical, 12)
                    
                    Heading(systemName: "creditcard.circle.fill", text: "PAYMENT METHOD")
                    
                    HStack(spacing: 15) {
                        Text("Method: ")
                        Text("\(main.paymentMethod)")
                    }
                    .foregroundColor(Color(.systemGray))
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Separator()
                        .padding(.vertical, 12)
                    
                    Heading(systemName: "bag.circle.fill", text: "ORDER ITEMS")
                    
                    ForEach(main.cartItems) { item in
                        OrderItemView(_id: item._id, imageData: item.imageData, name: item.name, price: item.price, quantity: item.quantity)
                    }
                
                    Separator()
                        .padding(.vertical, 12)
                }
                
                VStack(spacing: 20) {
                    Text("ORDER SUMMARY")
                        .fontWeight(.heavy)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal, 20)
                    
                    VStack(spacing: 20) {
                        Separator()
                        
                        HStack {
                            Text("Items")
                            Spacer()
                            Text("$" + String(format: "%0.2f", itemsPrice))
                        }
                        .padding(.horizontal, 20)
                    
                        Separator()
                    
                        HStack {
                            Text("Shipping")
                            Spacer()
                            Text("$" + String(format: "%0.2f", shippingPrice))
                        }
                        .padding(.horizontal, 20)
                        
                        Separator()
                        
                        HStack {
                            Text("Tax")
                            Spacer()
                            Text("$" + String(format: "%0.2f", taxPrice))
                        }
                        .padding(.horizontal, 20)
                        
                        Separator()

                        HStack {
                            Text("Total")
                            Spacer()
                            Text("$" + String(format: "%0.2f", totalPrice))
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    if main.errorMessage != "" {
                        Separator()
                        
                        Message(text: main.errorMessage, color: .red)
                            .padding(.horizontal, 20)
                    }

                    Separator()
                    
                    Button(action: {
                        main.createOrder(itemsPrice: itemsPrice, shippingPrice: shippingPrice, taxPrice: taxPrice, totalPrice: totalPrice)
                        //main.selection = "OrderScreen"
                    }) {
                        ButtonView(text: "PLACE ORDER", color: .blue)
                            .padding(.horizontal, 20)
                    }
                }
                .padding(.vertical, 20)
                .border(Color.black, width: 0.25)
            }
            .padding(.top, 10)
            .padding(.bottom, 20)
            .padding(.horizontal, 24)
        }
        .opacity(0.88)
        .buttonStyle(PlainButtonStyle())
        .navigationBarTitleDisplayMode(.large)
        .navigationBarTitle("PLACE ORDER")
    }
}

struct Heading: View {
    let systemName: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
                    Image(systemName: systemName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                    Text(text)
                        .font(.system(size: 20))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundColor(Color(.black))
        .opacity(0.75)
    }
}
