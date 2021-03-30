//
//  CartScreenView.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 15/01/21.
//

import SwiftUI

struct CartScreenView: View {
    @ObservedObject var main = MainController.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                VStack {
                    HStack {
                        
                        Text("Total Items:")
                        Spacer()
                        Text("\(main.getTotalItems())")
                    }
                    Separator()
                        .shadow(color: .black, radius: 0.1)
                    HStack {
                        Text("Sub Total:")
                        Spacer()
                        Text("$" + String(format: "%0.2f", main.getItemsTotalPrice()))
                    }
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(Color(.systemTeal))
                .cornerRadius(10)
                .shadow(color: Color(.black), radius: 2, x: 0.5, y: 0.8)
                .padding(.horizontal, 15)
                
                Button(action: {
                    main.errorMessage = ""
                    if main.isLoggedIn {
                        main.selection = "Shipping"
                    } else {
                        main.selectedIdOrScreen = "Shipping"
                        main.selection =  "Login"
                    }
                }) {
                    ButtonView(text: "Proceed To Checkout", color: Color(.systemOrange))
                        .padding(.top, 5)
                        .padding(.bottom, 20)
                        .opacity(main.cartItems.count > 0 ? 0.87 : 1)
                        .padding(.horizontal, 15)
                }
                .disabled(main.cartItems.count == 0)
                
                if main.cartItems.count > 0 {
                    ForEach(main.cartItems) { item in
                        CartItemView(item: item, quantity: item.quantity)
                            .padding(.horizontal, 8.5)
                    }
                } else {
                    ZStack {
                        Rectangle()
                            .opacity(0.4)
                            .frame(height: 50)
                        HStack(spacing: 0) {
                            Text("Your Cart is Empty ")
                                .fontWeight(.light)
                                .foregroundColor(.blue)
                            Button(action: {
                                main.selection = nil
                            }) {
                                Text("Go Back")
                                    .fontWeight(.light)
                                    .foregroundColor(Color(.systemGray))
                            }
                        }
                        .font(.callout)
                        .padding(.horizontal, 30)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .foregroundColor(Color(.cyan))
                    .border(Color(.cyan))
                    .cornerRadius(5)
                    .padding(.horizontal, 15)
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 10)
        }
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("SHOPPING CART   🛒")
    }
}

struct CartScreenView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CartScreenView()
        }
    }
}
