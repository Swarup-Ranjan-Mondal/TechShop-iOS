//
//  PriceView.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 11/01/21.
//

import SwiftUI

struct PriceView: View {
    
    var currencySymbol: String = "$"
    var price: Double = 0.0
    var strike: Bool = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 2) {
            Text(currencySymbol)
                .font(.callout)
                .padding(.top, 5)
            Text(String(format: "%0.2f", price))
                .font(.title)
                .strikethrough(strike)
        }
    }
}

struct PriceView_Previews: PreviewProvider {
    static var previews: some View {
        PriceView(price: 4.99)
    }
}
