//
//  CheckBox.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 22/02/21.
//

import SwiftUI



struct CheckBox: View {
    let text: String
    @Binding var selection: Bool
    
    var body: some View {
        HStack {
            Image(systemName: selection ? "checkmark.square.fill" : "square")
                .font(.title3)
                .foregroundColor(selection ? .blue : .gray)
            Text(text)
                .font(.system(size: 16))
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .opacity(0.75)
        }
        .onTapGesture {
            selection = !selection
        }
    }
}

struct CheckBox_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
    }
}
