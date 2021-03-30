//
//  ProductEditScreenView.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 18/02/21.
//

import SwiftUI
import PhotosUI

struct ProductEditScreenView: View {
    @Environment(\.presentationMode) private  var presentationMode
    @ObservedObject private var main = MainController.shared
    
    @StateObject var product: ProductData
    @State private var priceBindString: String = ""
    @State private var countInStockBindString: String = ""
    @State private var isPresented: Bool = false
    let uiScreen = UIScreen()
    
    var body: some View {
        ZStack {
            Form {
                Section(
                    header: Header("Name")
                ) {
                    TextField("Enter name", text: $product.name)
                        .keyboardType(.alphabet)
                        .autocapitalization(.words)
                }
                .textCase(nil)
                
                Section(
                    header: Header("Price")
                ) {
                    TextField("Enter price", text: $priceBindString)
                        .keyboardType(.decimalPad)
                        .onAppear {
                            self.priceBindString = String(product.price)
                        }
                        .onChange(of: priceBindString) { value in
                            if let price = Double(value) {
                                product.price = price
                            }
                        }
                }
                .textCase(nil)
                
                Section {
                    if product.imageData == nil {
                        HStack {
                            Image(systemName: "camera")
                                .padding(2)
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(7)

                            Spacer()

                            Button(action: {
                                isPresented = true
                            }){
                                Text("Pick an Image")
                            }
                            .foregroundColor(.blue)
                        }
                    } else {
                        HStack {
                            Image(systemName: "camera")
                                .padding(2)
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(7)
                            
                            Spacer()
                            
                            Button(action: {
                                product.imageData = nil
                            }){
                                Text("Remove Image")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                        getImageFromData(data: product.imageData!)!
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.bottom)
                    }
                }
                .sheet(isPresented: $isPresented) {
                    PhotoPicker(imageData: $product.imageData, callBack: {
                        uploadFileHandler(product.imageData!, completionHandler: { imageLocation in
                            product.image = imageLocation
                        })
                    })
                }
                
                Section(
                    header: Header("Brand")
                ) {
                    TextField("Enter brand", text: $product.brand)
                        .keyboardType(.alphabet)
                        .autocapitalization(.words)
                }
                .textCase(nil)
                
                Section(
                    header: Header("Count In Stock")
                ) {
                    TextField("Enter count in stock", text: $countInStockBindString)
                        .keyboardType(.numberPad)
                        .onAppear {
                            self.countInStockBindString = String(product.countInStock)
                        }
                        .onChange(of: countInStockBindString) { value in
                            if let countInStock = Int(value) {
                                product.countInStock = countInStock
                            }
                        }
                }
                .textCase(nil)
                
                Section(
                    header: Header("Category")
                ) {
                    TextField("Enter category", text: $product.category)
                        .keyboardType(.alphabet)
                        .autocapitalization(.words)
                }
                .textCase(nil)
                
                Section(
                    header: Header("Description")
                ) {
                    ZStack(alignment: .topLeading) {
                        if product.description == "" {
                            Text("Enter description")
                                .foregroundColor(Color(.systemGray4))
                                .padding(.top, 8)
                                .padding(.leading, 4)
                        }
                        
                        TextEditor(text: $product.description)
                            .autocapitalization(.sentences)
                    }
                }
                .textCase(nil)
                
                Section(
                    header: VStack(alignment: .leading) {
                        Text(main.errorMessage)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.red)
                                .padding(.leading, 12)
                        
                        HStack{
                            Button(action: {
                                if product.name != "" && priceBindString != "" && product.brand != "" && countInStockBindString != "" && product.category != "" && product.description != "" {
                                    main.errorMessage = ""
                                    main.updateProduct(product: product, completionHandler: {
                                        presentationMode.wrappedValue.dismiss()
                                    })
                                } else {
                                    main.errorMessage = "Please enter all the fields!"
                                }
                            }) {
                                ButtonView(text: "Update", color: .green)
                                    .opacity(0.95)
                            }
                            
                            Button(action: {
                                main.errorMessage = ""
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                ButtonView(text: "Cancel", color: .red)
                                    .opacity(0.95)
                            }
                        }
                    }
                    .padding(.top, -10)
                ) {
                    
                }
                .textCase(nil)
            }
            
            if main.loading {
                Loader()
            }
        }
        .padding(.bottom, 2)
        .navigationTitle("EDIT PRODUCT")
        .navigationBarBackButtonHidden(true)
    }
    
}

struct Header: View {
    private let content: String
    
    init(_ content: String) {
        self.content = content
    }
    
    var body: some View {
        Text(content)
            .font(.headline)
            .padding(.leading, 12)
            .padding(.top, 5)
    }
}

//struct ProductEditScreenView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductEditScreenView()
//    }
//}
