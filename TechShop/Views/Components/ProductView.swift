//
//  ProductView.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 09/01/21.
//

import SwiftUI

struct ProductView: View {
    
    let product: Product
    private let width = UIScreen.main.bounds.width
    
    var body: some View {
        HStack(alignment: .top) {
            VStack {
                if product.imageData != nil {
                    product.getImage()!
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .opacity(0.9)
                } else {
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .opacity(0.9)
                }
            }
            .frame(maxWidth: 0.35 * width)
            
            VStack(spacing: 0) {
                Text(product.name)
                    .font(.headline)
                    .bold()
                    .opacity(0.65)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 3)
                
                Text("by \(product.brand)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 8)
                
                RatingView(value: product.rating, color: .yellow, numReviews: product.numReviews)
                    .font(.footnote)
                    .frame(alignment: .leading)
                    .padding(.bottom, 5)
                
                HStack {
                    PriceView(price: product.price)
                        .opacity(0.75)
                    Text("$" + String(format: "%0.2f", product.price * 1.18))
                        .strikethrough()
                        .opacity(0.65)
                    Spacer()
                }
            }
            .padding(.vertical, 5)
            .padding(.leading, 5)
            .frame(maxWidth: 0.65 * width, minHeight: 0.3 * width)
        }
        .padding(8)
        .border(Color(.systemGray4))
        .padding(.top, 4)
        .padding(.horizontal, 8)
    }
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        ProductView(product: testProducts[1])
    }
}
