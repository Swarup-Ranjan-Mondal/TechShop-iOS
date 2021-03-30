//
//  UpdateProfileScreen.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 13/02/21.
//

import SwiftUI

struct UpdateProfileScreen: View {
    
    @ObservedObject var main = MainController.shared
    
    @State var name: String
    @State var email: String
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isValidEmail: Bool = true
    
    var body: some View {
        Form {
            Section {
                Label("Name", systemImage: "person")
                TextField("Enter Name", text: $name)
                    .keyboardType(.alphabet)
                    .autocapitalization(.words)
            }
            
            Section {
                Label("Email Address", systemImage: "envelope")
                TextField("Enter Email Id", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .onChange(of: email) {_ in
                        if textFieldValidatorEmail(email) {
                            isValidEmail = true
                        } else {
                            main.errorMessage = ""
                            isValidEmail = false
                        }
                    }
            }
            
            Section {
                Label("Password", systemImage: "key")
                SecureField("Enter Password", text: $password)
                    .autocapitalization(.none)
            }
            
            Section {
                Label("Confirm Password", systemImage: "key")
                SecureField("Confirm Password", text: $confirmPassword)
                    .autocapitalization(.none)
            }
            
            Section(
                header: VStack(alignment: .leading) {
                    if !isValidEmail || main.errorMessage != "" {
                        Text(!isValidEmail ? "Please enter valid email!" : main.errorMessage)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                            .padding(.leading, 12)
                    }
                    
                    HStack{
                        Button(action: {
                            if isValidEmail {
                                if name != "" && email != "" && password != "" && confirmPassword != "" {
                                    if password == confirmPassword {
                                        main.errorMessage = ""
                                        main.updateUserProfile(name: name, email: email, password: password)
                                        password = ""
                                        confirmPassword = ""
                                    } else {
                                        main.errorMessage = "Password and Confirm Password doesn't match"
                                    }
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
                            main.selection = "Profile"
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
        .opacity(0.88)
        .buttonStyle(PlainButtonStyle())
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarTitle("PROFILE DETAILS")
    }
}

struct UpdateProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UpdateProfileScreen(name: "", email: "")
        }
    }
}
