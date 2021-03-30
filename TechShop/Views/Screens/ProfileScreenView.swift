//
//  ProfileScreenView.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 09/02/21.
//

import SwiftUI

struct ProfileScreenView: View {
    @ObservedObject var main = MainController.shared
    
    var body: some View {
            VStack {
                Spacer()
                    .frame(height: 15)
                
                VStack {
                    Image("profilePic")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: 120, height: 120)
                    
                    Text(main.user.name)
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                        .frame(height: 10)
                    
                    HStack {
                        Image(systemName: "envelope")
                        Text(main.user.email)
                    }
                    
                    Spacer()
                        .frame(height: 20)
                    
                    Button(action: {
                        main.selection = "UpdateProfile"
                    }) {
                        Text("Update Profile")
                            .bold()
                            .frame(width: 250, height: 50)
                            .foregroundColor(.white)
                            .background(Color.red)
                            .cornerRadius(15)
                            .opacity(0.95)
                        
                    }
                }
                
                Spacer()
                    .frame(height: 25)
                
                Text("My Orders")
                    .bold()
                    .font(.title)
                    .frame(maxWidth: 360, alignment: .leading)
                
                Spacer()
                    .frame(height: 10)
                
                List {
                    ForEach(main.myOrders) { order in
                        MyOrderView(_id: order._id, createdAt: order.createdAt, totalPrice: order.totalPrice, isPaid: order.isPaid, isDelivered: order.isDelivered, paidAt: order.paidAt, deliveredAt: order.deliveredAt)
                    }
                }
                .padding(.bottom, 2)
            }
            .opacity(0.9)
    }
}

struct MyOrderView: View {
    @ObservedObject var main = MainController.shared
    
    let _id: String
    let createdAt: String
    let totalPrice: Double
    let isPaid: Bool
    let isDelivered: Bool
    let paidAt: String?
    let deliveredAt: String?
    
    var body: some View {
        VStack {
            HStack {
                VStack(spacing: 4) {
                    let headings = ["Id", "Date", "Total", "Paid", "Delivered"]
                    
                    ForEach(headings, id: \.self) { heading in
                        Text(heading)
                            .bold()
                            .textCase(.uppercase)
                            .frame(maxWidth: 95, alignment: .leading)
                    }
                }
                
                VStack(spacing: 4) {
                    ForEach(0..<5) { _ in
                        Text(":")
                            .bold()
                    }
                }
                
                VStack(spacing: 4) {
                    Text(_id)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(formatDateString(dateString: createdAt, format: "yyyy-MM-dd"))
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("$" + String(format: "%0.2f", totalPrice))
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if isPaid {
                        Text(formatDateString(dateString: paidAt!, format: "yyyy-MM-dd"))
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        Text("❌")
                            .font(.caption2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .opacity(0.8)
                    }
                    
                    if isDelivered {
                        Text(formatDateString(dateString: deliveredAt!, format: "yyyy-MM-dd"))
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        Text("❌")
                            .font(.caption2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .opacity(0.85)
                    }
                }
            }
            .font(.subheadline)
            
            Button(action: {
                main.getOrderDetails(_id)
            }) {
                ButtonView(text: "DETAILS", color: .orange)
            }
            .padding(.top, 10)
        }
        .padding(12)
        .foregroundColor(.white)
        .background(Color.accentColor)
        .cornerRadius(12)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreenView()
    }
}
