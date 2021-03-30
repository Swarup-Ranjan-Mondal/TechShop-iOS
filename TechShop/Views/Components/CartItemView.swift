//
//  CartItemView.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 15/01/21.
//

import SwiftUI

struct CartItemView: View {
    @ObservedObject var main = MainController.shared
    
    @ObservedObject var item: CartItem
    @State var quantity: Int
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            if item.imageData != nil {
                item.getImage()!
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 95, height: 80)
                    .border(Color(.systemGray4), width: 1)
                    .opacity(0.85)
            }
            
            VStack(spacing: 0) {
                Button(action: {
                    main.selectedIdOrScreen = item._id
                    main.selection = "Product"
                }) {
                    Text(item.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer()
                HStack(spacing: 0) {
                    Text("$")
                        .fontWeight(.medium)
                        .scaleEffect(0.8)
                    Text(String(format: "%0.2f", item.price))
                        .fontWeight(.medium)
                }
                .font(.subheadline)
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
            }
            .frame(maxHeight: 80)
            .padding(.horizontal, 8)
            .opacity(0.8)
            
            VStack(spacing: 0) {
                let qtyArray: [Int] = Array(1...item.countInStock)

                HStack {
                    Section {
                        Picker(selection: $quantity,
                            label: HStack(spacing: 0) {
                                Text("\(quantity)")
                                    .padding(.trailing, 10)
                                    .padding(.leading, 5)
                                    .padding(.vertical, 7.5)
                                    .frame(width: 50)
                                    .background(Color(.systemGray6))

                                Image(systemName: "chevron.down")
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 0.2)
                                    .background(Color(.systemGray4))
                                    .border(Color(.systemGray3))
                            }
                            .foregroundColor(.primary)
                            .cornerRadius(3)
                        ) {
                            ForEach(qtyArray, id: \.self) { qty in
                                Text("\(qty)")
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .onChange(of: quantity) { _ in
                            if let index = main.cartItems.firstIndex(where: { cartItem -> Bool in
                                return item._id == cartItem._id
                            }) {
                                item.quantity = quantity
                                main.cartItems[index] = item
                            }
                            main.saveCartItems()
                        }
                    }
                }
                Spacer()
                Button(action: {
                    main.deleteFromCart(item._id)
                }) {
                    Image(systemName: "trash.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.vertical, 5)
            .padding(.trailing, 10)
            .frame(width: 70, height: 80)
        }
        .border(Color(.systemGray4))
    }
}

//struct CartItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        CartItemView(item: CartItem())
//    }
//}
