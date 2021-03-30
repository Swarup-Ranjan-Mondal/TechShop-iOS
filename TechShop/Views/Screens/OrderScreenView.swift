//
//  OrderScreenView.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 19/01/21.
//

import SwiftUI
import MessageUI

struct OrderScreenView: View {
    @ObservedObject var main = MainController.shared
    
    var body: some View {
        let itemsPrice: Double = main.order.itemsPrice ?? 0.0
        let shippingPrice: Double = itemsPrice > 100 ? 0 : 10
        let taxPrice: Double = itemsPrice * 0.15
        let totalPrice: Double = itemsPrice + shippingPrice + taxPrice
        
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 5) {
                        Text("Order Number: \(main.order._id)")
                            .fontWeight(.light)
                            .fontWeight(.light).frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Order Placed: \(formatDateString(dateString: main.order.createdAt, format: "d MMMM yyyy"))")
                            .fontWeight(.light).frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .font(.system(size: 12))
                    
                    Separator()
                    
                    VStack(spacing: 20) {
                        Heading(systemName: "shippingbox.fill", text: "SHIP TO")
                    
                        VStack(spacing: 8) {
                            Text("Name: \(main.order.user.name)")
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Email: \(main.order.user.email!)")
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Address: \(main.order.shippingAddress.address), \(main.order.shippingAddress.city), \(main.order.shippingAddress.postalCode), \(main.order.shippingAddress.country)")
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                    }
                     
                    VStack(spacing: 22) {
                        Separator()
                        
                        Heading(systemName: "bus.fill", text: "DELIVERY STATUS")
                        
                        Message(
                            text: !main.order.isDelivered ?
                                "Not Delivered" :
                                "Delivered on \(formatDateString(dateString: main.order.deliveredAt!, format: "EEE, MMM dd, yyyy"))",
                            color: !main.order.isDelivered ? .red : .green
                        )
                        .opacity(0.7)
                        
                        Separator()
                    }
                    
                    VStack(spacing: 20) {
                        Heading(systemName: "creditcard.circle.fill", text: "PAYMENT METHOD")
                        
                        Text("Method: \(main.order.paymentMethod)")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    VStack(spacing: 22) {
                        Separator()
                        
                        Heading(systemName: "banknote.fill", text: "PAYMENT STATUS")
                        
                        Message(
                            text: !main.order.isPaid ?
                                "Not Paid" :
                                "Paid on \(formatDateString(dateString: main.order.paidAt!, format: "MMM dd, yyyy 'at' hh:mm a"))",
                            color: !main.order.isPaid ? .red : .green
                        )
                        .opacity(0.7)
                        
                        Separator()
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
                            .padding(.trailing, 10)
                            .padding(.horizontal, 20)
                        
                            Separator()
                        
                            HStack {
                                Text("Shipping")
                                Spacer()
                                Text("$" + String(format: "%0.2f", shippingPrice))
                            }
                            .padding(.trailing, 10)
                            .padding(.horizontal, 20)
                            
                            Separator()
                            
                            HStack {
                                Text("Tax")
                                Spacer()
                                Text("$" + String(format: "%0.2f", taxPrice))
                            }
                            .padding(.trailing, 10)
                            .padding(.horizontal, 20)
                            
                            Separator()

                            HStack {
                                Text("Total")
                                Spacer()
                                Text("$" + String(format: "%0.2f", totalPrice))
                            }
                            .padding(.trailing, 10)
                            .padding(.horizontal, 20)
                        }
                        
                        if main.errorMessage != "" {
                            Separator()
                            
                            Message(text: main.errorMessage, color: .red)
                                .padding(.horizontal, 20)
                        }

                        if !main.order.isPaid {
                            Separator()
                            
                            Button(action: {
                                main.makePayment(orderId: main.order._id, amount: totalPrice)
                            }) {
                                ButtonView(
                                    text: "MAKE PAYMENT",
                                    color: .blue
                                )
                                .padding(.horizontal, 20)
                            }
                            .disabled(main.loading)
                        } else if !main.order.isDelivered && main.user.isAdmin {
                            Separator()
                            
                            Button(action: {
                                main.deliverOrder(orderId: main.order._id)
                            }) {
                                ButtonView(
                                    text: "MARK AS DELIVERED",
                                    color: .blue
                                )
                                .padding(.horizontal, 20)
                            }
                            .disabled(main.loading)
                        }
                    }
                    .padding(.vertical, 20)
                    .border(Color.black, width: 0.25)
                    
                    VStack(spacing: 20) {
                        Separator()
                            
                        Heading(systemName: "bag.circle.fill", text: "ORDER ITEMS")
                        
                        VStack(spacing: 8) {
                            ForEach(main.order.orderItems) { item in
                                OrderItemView(_id: item.product, imageData: item.imageData, name: item.name, price: item.price, quantity: item.qty)
                            }
                        }
                        
                        Separator()
                    }
                }
                .opacity(0.88)
                .padding(.top, 15)
                .padding(.horizontal, 25)
            }
            
            if main.loading {
                Loader()
            }
        }
        .buttonStyle(PlainButtonStyle())
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarTitle("DETAILS OF ORDER")
        .navigationBarItems(
            leading: HStack {
                Image(systemName: "chevron.backward")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 18, height: 20)
                Text("Home")
                    .fontWeight(.light)
            }
            .foregroundColor(.blue)
            .onTapGesture {
                main.selection = nil
            }
        )
    }
}

struct OrderScreenView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OrderScreenView()
        }
    }
}
