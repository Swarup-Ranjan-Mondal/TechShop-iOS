//
//  LoginScreenView.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 11/01/21.
//

import SwiftUI

struct LoginScreenView: View {
    
    @ObservedObject var main = MainController.shared
    
    @State var email: String = ""
    @State var password: String = ""
    @State var isValidEmail: Bool = true
    @State var moveToRegister = false
    
    var body: some View {
        Form {
            Section {
                Label("Email Address", systemImage: "envelope.fill")
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
                Label("Password", systemImage: "key.fill")
                SecureField("Enter Password", text: $password)
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
                            if email != "" && password != "" {
                                main.errorMessage = ""
                                main.login(email: email, password: password)
                                email = ""
                                password = ""
                            } else {
                                main.errorMessage = "Please enter all the fields!"
                            }
                        }
                    }) {
                        ButtonView(text: "Sign In", color: .blue)
                    }
                },
                
                footer: HStack(spacing: 0) {
                    Text("New Customer?  ")
                    
                    Button(action: {
                        main.selection = "Register"
                    }) {
                        Text("Register")
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
        .navigationBarTitle("SIGN IN")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginScreenView()
        }
    }
}
