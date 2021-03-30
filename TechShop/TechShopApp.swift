//
//  TechShopApp.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 09/01/21.
//

import SwiftUI
import BraintreePayPal

@main
struct TechShopApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear() {
                    MainController.shared.listProducts()
                    MainController.shared.loadUserData()
                    MainController.shared.loadCartItems()
                    BTAppContextSwitcher.setReturnURLScheme("swarup.mondal.TechShop.payments")
                }
                .onOpenURL(perform: { url in
                    if url.scheme?.localizedCaseInsensitiveCompare("swarup.mondal.TechShop.payments") == .orderedSame {
                        BTAppContextSwitcher.handleOpenURL(url)
                    }
                })
        }
    }
}
