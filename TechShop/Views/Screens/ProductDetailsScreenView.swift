//
//  ProductDetailsScreenView.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 10/01/21.
//

import SwiftUI

struct ProductDetailsScreenView: View {

    @ObservedObject var main = MainController.shared
    
    @State private var quantity: Int = 1
    @State private var rating: Int = 0
    @State private var comment: String = ""
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 10) {
                    Text("Brand: \(main.product.brand)")
                        .font(.callout)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(main.product.name)
                        .font(.largeTitle)
                        .bold()
                        .opacity(0.7)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if main.product.getImage() != nil {
                        main.product.getImage()!
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .opacity(0.9)
                    } else {
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    
                    RatingView(value: main.product.rating, color: .yellow, numReviews: main.product.numReviews)
                        .font(.headline)
                        .padding(.vertical, 10)
                    
                    VStack(spacing: 4) {
                        Text("Description:")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(main.product.description)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .opacity(0.6)
                    .padding(.bottom, 2)
                    
                    VStack(spacing: 2.5) {
                        HStack {
                            Text("MRP: ")
                                .foregroundColor(.gray)
                                .font(.callout)
                            PriceView(price: main.product.price * 1.18, strike: true)
                                .foregroundColor(Color(.darkGray))
                                .opacity(0.9)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        HStack {
                            Text("Price: ")
                                .foregroundColor(.gray)
                                .font(.callout)
                            PriceView(price: main.product.price)
                                .foregroundColor(Color(.red))
                                .opacity(0.6)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        HStack {
                            Text("You Save: ")
                                .foregroundColor(.gray)
                                .font(.callout)
                            PriceView(price: main.product.price * 0.18)
                                .foregroundColor(Color(.red))
                                .opacity(0.6)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    Text(main.product.countInStock > 0 ? "In Stock" : "Out Of Stock")
                        .font(.title2)
                        .foregroundColor(main.product.countInStock > 0 ? .green : .red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if main.product.countInStock > 0 {
                        let qtyArray: [Int] = Array(1...main.product.countInStock)

                        HStack {
                            Text("Select Quantity: ")
                                .font(.system(size: 18))
                            Spacer()
                            Section {
                                Picker(selection: $quantity,
                                       label: HStack(spacing: 0) {
                                                    Text(quantity == 1 ? "1 piece" : "\(quantity) pieces")
                                                        .padding(.trailing, 25)
                                                        .padding(.leading, 10)
                                                        .padding(.vertical, 7.5)
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
                                        Text(qty == 1 ? "1 piece" : "\(qty) pieces")
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .animation(nil)
                            }
                            .opacity(0.9)
                        }
                        .padding(.top, 5)
                        .padding(.bottom, 12)
                        .opacity(0.75)
                    }
                    
                    Button(action: {
                        main.addToCart(main.product, quantity: quantity)
                        main.selection = "Cart"
                    }) {
                        ButtonView(text: "Add To Cart", color: .orange)
                            .padding(.bottom, 15)
                            .opacity(main.product.countInStock > 0 ? 0.87 : 1)
                    }
                    .disabled(main.loading || main.product.countInStock == 0)
                    Group {
                        VStack(spacing: 13) {
                            Text("Reviews:")
                                .font(.custom("review", fixedSize: 24))
                                .fontWeight(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .opacity(0.65)
                            if main.product.reviews.count > 0 {
                                ForEach(main.product.reviews) { review in
                                    ReviewView(review: review)
                                        .opacity(0.7)
                                    Separator()
                                }
                            } else {
                                Message(text: "No Reviews", color: .blue)
                                    .opacity(0.7)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 17) {
                            Text("Write a Customer Review:")
                                .font(.custom("review", fixedSize: 22))
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .opacity(0.65)
                            
                            if !main.isLoggedIn {
                                Message(text: "Please sign in to write a review", color: .blue)
                            } else {
                                if main.errorMessage != "" {
                                    Message(text: main.errorMessage, color: .red)
                                }
                                
                                Text("Rating")
                                    .font(.system(size: 18))
                                    .opacity(0.75)
                                
                                let ratingArray: [String] = [
                                    "Select...",
                                    "Poor",
                                    "Fair",
                                    "Good",
                                    "Very Good",
                                    "Excellent"
                                ]
                                Picker(selection: $rating,
                                       label: HStack(spacing: 0) {
                                            Text(rating > 0 ? "\(rating) - \(ratingArray[rating])" : ratingArray[rating])
                                                .font(.headline)
                                                .fontWeight(.light)
                                            Spacer()
                                            Image(systemName: "chevron.down")
                                                .font(.headline)
                                       }
                                       .padding(.horizontal, 10)
                                       .frame(maxWidth: 180, maxHeight: 40)
                                       .background(Color(.systemGray5))
                                       .foregroundColor(.primary)
                                       .cornerRadius(5)
                                ) {
                                    ForEach(0 ..< ratingArray.count) {
                                        Text($0 > 0 ? "\($0) - \(ratingArray[$0])" : ratingArray[$0])
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .animation(nil)
                                
                                Text("Comment")
                                    .font(.system(size: 18))
                                    .opacity(0.75)
                                
                                TextEditor(text: $comment)
                                    .frame(minHeight: 80)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                                    .autocapitalization(.sentences)
                                
                                Button(action: {
                                    if rating == 0 || comment == "" {
                                        main.errorMessage = "Select a rating and write a comment."
                                    } else {
                                        main.errorMessage = ""
                                        
                                        let review = CreateReview(rating: rating, comment: comment)
                                        main.createProductReview(productId: main.product._id, review: review)
                                        
                                        rating = 0
                                        comment = ""
                                    }
                                }) {
                                    ButtonView(text: "Submit", color: .primary)
                                        .frame(width: 200)
                                        .opacity(0.9)
                                }
                            }
                        }
                        .padding(.top, 20)
                    }
                }
                .redacted(reason: main.loading ? .placeholder : [])
                .padding(15)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.bottom, 20)
                .buttonStyle(PlainButtonStyle())
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        CartButton()
                        if main.user.isAdmin {
                            AdminDropDownButton()
                        }
                        UserDropDownButton()
                    }
                }
            }
            
            if main.loading {
                Loader()
            }
        }
    }
}

struct ProductPageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProductDetailsScreenView()
        }
    }
}
