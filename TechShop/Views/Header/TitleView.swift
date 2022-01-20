//
//  TitleView.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 15/02/21.
//

import SwiftUI

struct TitleView: View {
    var body: some View {
        HStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .background(Color(.systemTeal))
                .frame(width: 37, height: 36)
                .clipShape(Capsule())
                .opacity(0.85)
                
            Text("TechShop")
                .font(.system(size: 28))
                .foregroundColor(Color(.systemTeal))
        }
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
