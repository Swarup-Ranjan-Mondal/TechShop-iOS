//
//  ReviewView.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 11/01/21.
//

import SwiftUI

struct ReviewView: View {
    
    let review: Review
    
    var body: some View {
        VStack(spacing: 10) {
            Text(review.name)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
            RatingView(value: review.rating, color: .yellow)
            Text(review.createdAt.prefix(10))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(review.comment)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 10)
        }
        .foregroundColor(Color(.systemGray))
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView(review: Review())
    }
}
