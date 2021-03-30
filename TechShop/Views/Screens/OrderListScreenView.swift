//
//  OrdersScreenView.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 15/02/21.
//

import SwiftUI

struct OrderListScreenView: View {
    @ObservedObject private var main = MainController.shared
    
    var body: some View {
        ZStack {
            NavigationLink(destination: EmptyView()) {
                
            }
            
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(main.orders) { order in
                        ListedOrderView(
                            _id: order._id,
                            userName: order.user.name,
                            createdAt: order.createdAt,
                            totalPrice: order.totalPrice,
                            isPaid: order.isPaid,
                            isDelivered: order.isDelivered,
                            paidAt: order.paidAt,
                            deliveredAt: order.deliveredAt
                        )
                    }
                }
            }
            
            if main.loading {
                Loader()
            }
        }
        .navigationBarTitle(Text("ORDERS"))
        .navigationBarTitleDisplayMode(.large)
    }
}

struct ListedOrderView: View {
    @ObservedObject var main = MainController.shared
    
    let _id: String
    let userName: String
    let createdAt: String
    let totalPrice: Double
    let isPaid: Bool
    let isDelivered: Bool
    let paidAt: String?
    let deliveredAt: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                Text("Id")
                    .bold()
                    .textCase(.uppercase)
                    .frame(maxWidth: 100, alignment: .leading)
                Text(":")
                    .bold()
                Text(_id)
                    .bold()
            }
            
            HStack(alignment: .top) {
                Text("User")
                    .bold()
                    .textCase(.uppercase)
                    .frame(maxWidth: 100, alignment: .leading)
                Text(":")
                    .bold()
                Text(userName)
                    .bold()
            }
            
            HStack(alignment: .top) {
                Text("Date")
                    .bold()
                    .textCase(.uppercase)
                    .frame(maxWidth: 100, alignment: .leading)
                Text(":")
                    .bold()
                Text(formatDateString(dateString: createdAt, format: "yyyy-MM-dd"))
                    .bold()
            }
            
            HStack(alignment: .top) {
                Text("Total Price")
                    .bold()
                    .textCase(.uppercase)
                    .frame(maxWidth: 100, alignment: .leading)
                Text(":")
                    .bold()
                Text("$" + String(format: "%0.2f", totalPrice))
                    .bold()
            }
            
            HStack(alignment: .top) {
                Text("Paid")
                    .bold()
                    .textCase(.uppercase)
                    .frame(maxWidth: 100, alignment: .leading)
                Text(":")
                    .bold()
                if isPaid {
                    Text(formatDateString(dateString: paidAt!, format: "yyyy-MM-dd"))
                        .bold()
                } else {
                    Text("❌")
                        .font(.caption2)
                        .padding(.top, 5)
                        .opacity(0.85)
                }
            }
            
            HStack(alignment: .top) {
                Text("Delivered")
                    .bold()
                    .textCase(.uppercase)
                    .frame(maxWidth: 100, alignment: .leading)
                Text(":")
                    .bold()
                if isDelivered {
                    Text(formatDateString(dateString: deliveredAt!, format: "yyyy-MM-dd"))
                        .bold()
                } else {
                    Text("❌")
                        .font(.caption2)
                        .padding(.top, 5)
                        .opacity(0.85)
                }
            }
            
            Button(action: {
                main.getOrderDetails(_id)
            }) {
                ButtonView(text: "DETAILS", color: .blue)
            }
            .padding(.top, 10)
        }
        .padding(12)
        .foregroundColor(Color(.black))
        .background(Color(red: 50 / 255, green: 205 / 255, blue: 50 / 255))
        .cornerRadius(12)
        .shadow(color: .black, radius: 3, x: 0.5, y: 0.3)
        .padding(.horizontal, 10)
    }
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        ListedOrderView(_id: "5fe0c48a42d9857d58d6eec5", userName: "Jane Doe", createdAt: "2020-12-21", totalPrice: 218.47, isPaid: true, isDelivered: true, paidAt: "2020-12-21", deliveredAt: "2020-12-21")
    }
}
