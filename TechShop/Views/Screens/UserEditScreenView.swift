//
//  UserEditScreenView.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 22/02/21.
//

import SwiftUI

struct UserEditScreenView: View {
    @Environment(\.presentationMode) private  var presentationMode
    @ObservedObject private var main = MainController.shared
    
    let _id: String
    @State var name: String
    @State var email: String
    @State var isAdmin: Bool
    @State private var isValidEmail: Bool = true
    
    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section {
                        Label("Name", systemImage: "person.crop.rectangle.fill")
                        TextField("Enter Name", text: $name)
                            .keyboardType(.alphabet)
                            .autocapitalization(.words)
                    }
                    .textCase(nil)
                    
                    Section(
                        footer: CheckBox(text: "Is Admin", selection: $isAdmin)
                            .padding(.top, 16)
                            .padding(.leading, 5)
                    ) {
                        Label("Email", systemImage: "envelope.fill")
                        TextField("Enter Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .onChange(of: email) { _ in
                                if textFieldValidatorEmail(email) {
                                    isValidEmail = true
                                } else if email != "" {
                                    main.errorMessage = ""
                                    isValidEmail = false
                                }
                            }
                    }
                    .textCase(nil)
                    
                    Section(
                        header: VStack(alignment: .leading) {
                            Text(!isValidEmail ? "Please enter valid email!" : main.errorMessage)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.red)
                                    .padding(.leading, 12)
                                    .padding(.top, 5)
                            
                            HStack{
                                Button(action: {
                                    if isValidEmail {
                                        if name != "" && email != "" {
                                            main.errorMessage = ""
                                            
                                            let user: UserData = UserData()
                                            user._id = _id
                                            user.name = name
                                            user.email = email
                                            user.isAdmin = isAdmin
                                            
                                            main.updateUser(user, completionHandler: {
                                                presentationMode.wrappedValue.dismiss()
                                            })
                                        } else {
                                            main.errorMessage = "Please enter all the fields!"
                                        }
                                    }
                                }) {
                                    ButtonView(text: "Update", color: .green)
                                        .opacity(0.95)
                                }
                                
                                Button(action: {
                                    main.errorMessage = ""
                                    presentationMode.wrappedValue.dismiss()
                                }) {
                                    ButtonView(text: "Cancel", color: .red)
                                        .opacity(0.95)
                                }
                            }
                        }
                    ) {
                        
                    }
                    .textCase(nil)
                }
            }
            .navigationTitle("Edit User")
        }
    }
}

struct UserEditScreenView_Previews: PreviewProvider {
    static var previews: some View {
        UserEditScreenView(_id: "", name: "", email: "", isAdmin: true)
    }
}
