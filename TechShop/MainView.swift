//
//  ContentView.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 09/01/21.
//

import SwiftUI
import BraintreePayPal

struct MainView: View {
    
    @ObservedObject var main = MainController.shared
    
    var body: some View {
        NavigationView {
            HomeScreenView(products: main.products)
                .onAppear() {
                    // BrainTree Authorization Token from env.swift file in Data folder
                    main.braintreeClient = BTAPIClient(authorization: BT_AUTH_TOKEN)
                }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
