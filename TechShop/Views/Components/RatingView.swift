//
//  RatingView.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 09/01/21.
//

import SwiftUI

struct RatingView: View {
    
    var value: Double
    var color: Color
    var numReviews: Int = 0
    
    var body: some View {
        HStack {
            HStack(spacing: 1) {
                Image(systemName: value >= 1 ? "star.fill" : value >= 0.5 ? "star.leadinghalf.fill" : "star")
                Image(systemName: value >= 2 ? "star.fill" : value >= 1.5 ? "star.leadinghalf.fill" : "star")
                Image(systemName: value >= 3 ? "star.fill" : value >= 2.5 ? "star.leadinghalf.fill" : "star")
                Image(systemName: value >= 4 ? "star.fill" : value >= 3.5 ? "star.leadinghalf.fill" : "star")
                Image(systemName: value >= 5 ? "star.fill" : value >= 4.5 ? "star.leadinghalf.fill" : "star")
            }
            .foregroundColor(color)
            
            Text(numReviews > 0 ? numReviews == 1 ? "1 review" : "\(numReviews) reviews" : "")
                .foregroundColor(.gray)
            
            Spacer()
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(value: 3.5, color: .yellow)
    }
}
