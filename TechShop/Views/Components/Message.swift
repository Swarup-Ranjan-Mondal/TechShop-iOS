//
//  Message.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 11/01/21.
//

import SwiftUI

struct Message: View {
    let text: String
    let color: Color
    
    var body: some View {
        ZStack {
            Rectangle()
                .opacity(0.2)
                .frame(height: 50)
            
            Text(text)
                .font(.callout)
                .fontWeight(.semibold)
                .padding(.horizontal, 30)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .foregroundColor(color)
        .border(color, width: 1)
    }
}

struct NoReviewsView_Previews: PreviewProvider {
    static var previews: some View {
        Message(text: "No Reviews", color: .blue)
    }
}
