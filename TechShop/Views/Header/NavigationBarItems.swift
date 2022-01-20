//
//  NavigationBarItems.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 11/01/21.
//

import SwiftUI

struct CartButton: View {
    @ObservedObject var main = MainController.shared
    
    var body: some View {
        Button(action: {
            main.selection = "Cart"
        }) {
            Image(systemName: "cart.fill")
                .font(.title)
                .opacity(0.75)
        }
    }
}

struct UserDropDownButton: View {
    @ObservedObject var main = MainController.shared

    @State var userSelection: String = ""
    
    var body: some View {
        if !main.isLoggedIn {
            Button(action: {
                main.selection = "Login"
            }) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.title)
                    .opacity(0.75)
            }
        } else {
            let options = ["Profile", "Logout"]
            
            Menu {
                Picker(
                    selection: $userSelection,
                    label: EmptyView()
                ) {
                    ForEach(options, id: \.self) { option in
                        Text(option)
                    }
                }
            } label: {
                Image("profilePic")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(width: 40, height: 40)
                    .opacity(0.92)
            }
            .onChange(of: userSelection) { _ in
                switch(userSelection) {
                case "Profile":
                    main.selection = userSelection
                    break
                case "Logout":
                    main.logout()
                    break
                default:
                    break
                }
                userSelection = ""
            }
        }
    }
}

struct AdminDropDownButton: View {
    @ObservedObject var main = MainController.shared
    
    @State var adminSelection: String = ""
    
    var body: some View {
        let options = ["Users", "Products", "Orders"]
        
        Menu {
            Picker(
                selection: $adminSelection,
                label: EmptyView()
            ) {
                ForEach(options, id: \.self) { option in
                    Text(option)
                }
            }
        } label: {
            Image("admin")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 36, height: 36)
                .opacity(0.72)
        }
        .onChange(of: adminSelection) { _ in
            switch(adminSelection) {
            case "Users":
                main.selection = adminSelection
                break
            case "Products":
                main.selection = adminSelection
                break
            case "Orders":
                main.selection = adminSelection
                break
            default:
                break
            }
            adminSelection = ""
        }
    }
}
