//
//  PaymentMethodScreenView.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 18/01/21.
//

import SwiftUI

struct PaymentMethodScreenView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var main = MainController.shared
    
    @State var paymentMethod: String
    @State var moveToPlaceOrder: Bool = false
    
    var body: some View {
        NavigationLink(destination: PlaceOrderScreenView(), isActive: $moveToPlaceOrder) {
            EmptyView()
        }
        
        Form {
            Section(
                header: Text("Select Method")
                    .font(.headline)
                    .padding(.top)
            ) {
                
            }
            
            Section(
                header: RadioButtonGroups(
                    options: main.paymentMethods,
                    callback:  { selectedMethod in
                        self.paymentMethod = selectedMethod
                    },
                    selected: self.paymentMethod
                )
                .padding(.leading, 20)
            ) {
                
            }
            
            Section(
                header: HStack {
                    Button(action: {
                        main.paymentMethod = paymentMethod
                        main.savePaymentMethod()
                        moveToPlaceOrder = true
                    }) {
                        ButtonView(text: "Continue", color: .blue)
                    }
                    
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        ButtonView(text: "Back", color: .black)
                    }
                }
                .padding(.top, 5)
            ) {
                
            }
        }
        .opacity(0.85)
        .buttonStyle(PlainButtonStyle())
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarTitle("PAYMENT METHOD")
    }
}

struct PaymentMethodView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PaymentMethodScreenView(paymentMethod: "")
        }
    }
}
