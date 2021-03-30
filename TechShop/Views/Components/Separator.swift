//
//  SeparatorView.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 11/01/21.
//

import SwiftUI

struct Separator: View {
    var body: some View {
        Rectangle()
            .foregroundColor(Color(.systemGray2))
            .frame(height: 0.5)
    }
}

struct SeparatorView_Previews: PreviewProvider {
    static var previews: some View {
        Separator()
    }
}
