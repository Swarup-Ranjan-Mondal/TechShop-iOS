//
//  OrderItemView.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 19/01/21.
//

import SwiftUI

struct OrderItemView: View {
    @ObservedObject var main = MainController.shared
    
    let _id: String
    let imageData: Data?
    let name: String
    let price: Double
    let quantity: Int
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            if imageData != nil {
                getImageFromData(data: imageData!)!
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 90)
                    .border(Color(.systemGray4), width: 1)
                    .opacity(0.85)
            }
            
            VStack(spacing: 0) {
                Spacer()
                Button(action: {
                    main.selectedIdOrScreen = _id
                }) {
                    Text(name)
                    Spacer()
                }
                Spacer()
            }
            .padding(.horizontal, 8)
            .opacity(0.8)
            
            VStack(spacing: 4) {
                Text("\(quantity) x $\(String(format: "%0.2f", price))")
                Text(" = $\(String(format: "%0.2f", totalPrice(qty: quantity, price: price)))")
            }
            .font(.footnote)
            .padding(.horizontal, 8)
            .frame(maxHeight: .infinity, alignment: .center)
        }
        .frame(maxHeight: 70)
        .border(Color(.systemGray4))
    }
    
    func totalPrice(qty: Int, price: Double) -> Double {
        return Double(qty) * price
    }
}
