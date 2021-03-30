//
//  ShippingScreenView.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 18/01/21.
//

import SwiftUI

struct ShippingScreenView: View {
    @ObservedObject var main = MainController.shared
    
    @State var shippingAddress: ShippingAddress
    @State var moveToPaymentMethod: Bool = false
    
    var body: some View {
        NavigationLink(
            destination: PaymentMethodScreenView(
                paymentMethod: main.paymentMethod == "" ? main.paymentMethods[0] : main.paymentMethod
            ),
            isActive: $moveToPaymentMethod
        ) {
            EmptyView()
        }
        
        Form {
            Section(
                header: VStack {
                    Text(main.errorMessage)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 2)
                    
                    Text("Address")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.leading, 8)
            ) {
                TextField("Enter address", text: $shippingAddress.address)
                    .autocapitalization(.words)
            }
            
            Section(
                header: Text("City")
                    .padding(.leading, 8)
            ) {
                TextField("Enter city", text: $shippingAddress.city)
                    .autocapitalization(.words)
            }
            
            Section(
                header: Text("Postal Code")
                    .padding(.leading, 8)
            ) {
                TextField("Enter postal code", text: $shippingAddress.postalCode)
                    .keyboardType(.numberPad)
            }
            
            Section(
                header: Text("Country")
                    .padding(.leading, 8)
            ) {
                TextField("Enter country", text: $shippingAddress.country)
                    .autocapitalization(.words)
            }
            
            Section(
                header: Button(action: {
                    if shippingAddress.address != "" && shippingAddress.city != "" && shippingAddress.postalCode != "" && shippingAddress.country != "" {
                        main.errorMessage = ""
                        main.shippingAddress = shippingAddress
                        main.saveShippingAddress()
                        moveToPaymentMethod = true
                    } else {
                        main.errorMessage = "All fields are neccessary!"
                    }
                }) {
                    ButtonView(text: "Continue", color: .blue)
                        .padding(.top, 5)
                }
            ) {
                
            }
        }
        .opacity(0.88)
        .buttonStyle(PlainButtonStyle())
        .navigationBarTitleDisplayMode(.large)
        .navigationBarTitle("SHIPPING")
    }
}

struct ShippingScreenView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ShippingScreenView(shippingAddress: ShippingAddress())
        }
    }
}
