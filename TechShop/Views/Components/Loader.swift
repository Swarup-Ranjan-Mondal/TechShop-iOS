//
//  Loader.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 07/02/21.
//

import SwiftUI

struct Loader: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .scaleEffect(3)
    }
}

struct Loader_Previews: PreviewProvider {
    static var previews: some View {
        Loader()
    }
}
