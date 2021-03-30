//
//  ButtonView.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 11/01/21.
//

import SwiftUI

struct ButtonView: View {
    
    let text: String
    let color: Color
    
    var body: some View {
        HStack {
            Spacer()
            Text(text)
                .bold()
            Spacer()
        }
        .font(.custom("Custom", size: 20))
        .padding()
        .background(color)
        .foregroundColor(.white)
        .cornerRadius(5)
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(text: "Add To Cart", color: .orange)
    }
}
