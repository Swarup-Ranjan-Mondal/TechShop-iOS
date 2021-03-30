//
//  ProductListScreenView.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 15/02/21.
//

import SwiftUI

struct ProductListScreenView: View {
    @ObservedObject private var main = MainController.shared
    
    @State private var showCreateView: Bool = false
    
    var body: some View {
        ZStack {
            NavigationLink(
                destination: ProductEditScreenView(
                    product: ProductData(
                        _id: main.product._id,
                        name: main.product.name,
                        price: main.product.price,
                        image: main.product.image,
                        imageData: main.product.imageData,
                        brand: main.product.brand,
                        category: main.product.category,
                        countInStock: main.product.countInStock,
                        description: main.product.description
                    )
                ),
                isActive: $showCreateView
            ) {
                EmptyView()
            }
            
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(main.products) { product in
                        ListedProductView(_id: product._id, name: product.name, price: product.price, category: product.category, brand: product.brand) {
                            showCreateView = true
                        }
                    }
                }
            }
            
            if(main.loading) {
                Loader()
            }
        }
        .navigationBarTitle("PRODUCTS")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarItems(
            trailing: Button(action: {
                main.loading = true
                main.createProduct(completionHandler: {
                    showCreateView = true
                })
            }) {
                Image(systemName: "note.text.badge.plus")
                    .font(.title)
            }
        )
    }
}

struct ListedProductView: View {
    @ObservedObject private var main = MainController.shared
    @State private var showingAlert: Bool = false
    
    let _id: String
    let name: String
    let price: Double
    let category: String
    let brand: String
    let createHandler: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
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
                Text("Name")
                    .bold()
                    .textCase(.uppercase)
                    .frame(maxWidth: 100, alignment: .leading)
                Text(":")
                    .bold()
                Text(name)
                    .bold()
            }
            
            HStack(alignment: .top) {
                Text("Price")
                    .bold()
                    .textCase(.uppercase)
                    .frame(maxWidth: 100, alignment: .leading)
                Text(":")
                    .bold()
                Text("$" + String(format: "%0.2f", price))
                    .bold()
            }
            
            HStack(alignment: .top) {
                Text("Category")
                    .bold()
                    .textCase(.uppercase)
                    .frame(maxWidth: 100, alignment: .leading)
                Text(":")
                    .bold()
                Text(category)
                    .bold()
            }
            
            HStack(alignment: .top) {
                Text("Brand")
                    .bold()
                    .textCase(.uppercase)
                    .frame(maxWidth: 100, alignment: .leading)
                Text(":")
                    .bold()
                Text(brand)
                    .bold()
            }
            
            HStack(spacing: 0) {
                Button(action: {
                    main.getProductDetails(productId: self._id, completionHandler: createHandler)
                }) {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 20)
                        .foregroundColor(.black)
                        .background(Color.white)
                }
                
                Button(action: {
                    showingAlert = true
                }) {
                    Image(systemName: "trash.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 20)
                        .foregroundColor(.white)
                        .background(Color.red)
                }
                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("Delete confirmation"),
                        message: Text("Are you sure you want to permanently remove this item?"),
                        primaryButton: .destructive(
                            Text("Ok")
                                .foregroundColor(.red),
                            action: {
                                main.deleteProduct(_id)
                            }
                        ),
                        secondaryButton: .cancel()
                    )
                }
            }
            .cornerRadius(8)
            .padding(.top, 15)
            .padding(.bottom, 5)
        }
        .padding(12)
        .foregroundColor(Color(.systemIndigo))
        .background(Color(.yellow))
        .cornerRadius(12)
        .opacity(0.95)
        .shadow(color: .black, radius: 3, x: 0.5, y: 0.3)
        .padding(.horizontal, 10)
    }
}

struct ProductsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProductListScreenView()
//            ListedProductView(_id: "5fdf62cbc33f005a60877857", name: "Logitech G-Series Gaming Mouse", price: 49.99, category: "Electronics", brand: "Logitech")
        }
    }
}
