//
//  UserListScreenView.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 15/02/21.
//

import SwiftUI

struct UserListScreenView: View {
    @ObservedObject private var main = MainController.shared
    
    @State private var showEditUser = false
    @State private var userData = UserData()
    
    var body: some View {
        ZStack {
            NavigationLink(
                destination: UserEditScreenView(_id: userData._id, name: userData.name, email: userData.email, isAdmin: userData.isAdmin),
                isActive: $showEditUser
            ) {
                
            }
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(main.users) { user in
                        ListedUserView(
                            _id: user._id,
                            name: user.name,
                            email: user.email,
                            isAdmin: user.isAdmin
                        ) { data in
                            userData = data
                            showEditUser = true
                        }
                    }
                }
            }
            
            if main.loading {
                Loader()
            }
        }
        .navigationBarTitle(Text("USERS"))
        .navigationBarTitleDisplayMode(.large)
    }
}

struct ListedUserView: View {
    @ObservedObject private var main = MainController.shared
    @State private var showingAlert: Bool = false
    
    let _id: String
    let name: String
    let email: String
    let isAdmin: Bool
    let userEditHandler: (UserData) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                Text("Id")
                    .bold()
                    .textCase(.uppercase)
                    .frame(maxWidth: 100, alignment: .leading)
                Text(":")
                    .bold()
                Text(_id)
                    .bold()
            }
            
            HStack(alignment: .top) {
                Text("Name")
                    .bold()
                    .textCase(.uppercase)
                    .frame(maxWidth: 100, alignment: .leading)
                Text(":")
                    .bold()
                Text(name)
                    .bold()
            }
            
            HStack(alignment: .top) {
                Text("Email")
                    .bold()
                    .textCase(.uppercase)
                    .frame(maxWidth: 100, alignment: .leading)
                Text(":")
                    .bold()
                Text(email)
                    .bold()
            }
            
            HStack(alignment: .top) {
                Text("Admin")
                    .bold()
                    .textCase(.uppercase)
                    .frame(maxWidth: 100, alignment: .leading)
                Text(":")
                    .bold()
                ZStack {
                    Rectangle()
                        .frame(width: 18, height: 18)
                    
                    if isAdmin {
                        Image(systemName: "checkmark.square.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.green)
                            .frame(width: 22, height: 22)
                    } else {
                        Image(systemName: "xmark.square.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.red)
                            .frame(width: 22, height: 22)
                    }
                }
            }
            
            HStack(spacing: 0) {
                Button(action: {
                    main.getUserDetails(_id, completionHandler: { userData in
                        userEditHandler(userData)
                    })
                }) {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 20)
                        .foregroundColor(.black)
                        .background(Color.white)
                }
                
                Button(action: {
                    showingAlert = true
                }) {
                    Image(systemName: "trash.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 20)
                        .foregroundColor(.white)
                        .background(Color.red)
                }
                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("Delete confirmation"),
                        message: Text("Are you sure you want to permanently remove this user?"),
                        primaryButton: .destructive(
                            Text("Ok")
                                .foregroundColor(.red),
                            action: {
                                main.deleteUser(_id)
                            }
                        ),
                        secondaryButton: .cancel()
                    )
                }
            }
            .cornerRadius(8)
            .padding(.top, 12)
            .padding(.bottom, 3)
        }
        .padding(12)
        .foregroundColor(.white)
        .background(Color.accentColor)
        .cornerRadius(12)
        .padding(.horizontal, 10)
    }
}

//struct UsersView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListedUserView(_id: "5fdf62cbc33f005a60877850", name: "Admin User", email: "admin@example.com", isAdmin: true, userEditHandler: (UserData) -> Void)
//    }
//}
