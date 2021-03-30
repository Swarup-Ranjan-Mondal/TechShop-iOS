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
                .background(Color.black)
                .clipShape(Circle())
                .frame(width: 30, height: 30)
                .opacity(0.85)
                
            Text("TechShop")
                .font(.system(size: 26))
                .foregroundColor(Color(.systemTeal))
        }
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
