//
//  RegisterScreenView.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 12/01/21.
//

import SwiftUI

struct RegisterScreenView: View {
    
    @ObservedObject var main = MainController.shared
    
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var isValidEmail: Bool = true
    
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
                        } else if email != "" {
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
                    
                    Button(action: {
                        if isValidEmail {
                            if name != "" && email != "" && password != "" && confirmPassword != "" {
                                if password == confirmPassword {
                                    main.errorMessage = ""
                                    main.register(name: name, email: email, password: password)
                                    name = ""
                                    email = ""
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
                        ButtonView(text: "Sign Up", color: .blue)
                    }
                },
                
                footer: HStack(spacing: 0) {
                    Text("Have an Account?  ")
                    Button(action: {
                        main.selection = "Login"
                    }) {
                        Text("Login")
                            .foregroundColor(.blue)
                    }
                }
                .font(.headline)
            ) {
                
            }
            .textCase(nil)
        }
        .opacity(0.88)
        .buttonStyle(PlainButtonStyle())
        .navigationBarTitleDisplayMode(.large)
        .navigationBarTitle("SIGN UP")
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RegisterScreenView()
        }
    }
}
