//
//  UserController.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 16/01/21.
//

import SwiftUI

class LoginModel: Codable {
    let email: String
    let password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

class RegisterModel: Codable {
    let name: String
    let email: String
    let password: String
    
    init(name: String, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
    }
}

class ProfileModel: Codable {
    let id: String
    let name: String
    let email: String
    let password: String
    
    init(id: String, name: String, email: String, password: String) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
    }
}

struct ErrorResponse: Codable {
    let message: String
}

class UserController {
    @ObservedObject var main = MainController.shared
    
    func register(name: String, email: String, password: String) {
        self.main.errorMessage = ""
        if let url = URL(string: "\(serverURL)/api/users") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Application/JSON", forHTTPHeaderField: "Content-Type")
            let registerDetails: RegisterModel = RegisterModel(name: name, email: email, password: password)
            
            let encodedData = try? JSONEncoder().encode(registerDetails)
            //print(String(data: encodedData!, encoding: .utf8)!)
            
            request.httpBody = encodedData
            URLSession.shared.dataTask(with: request) { (data, response, _) in
                if let webData = data {
                    if let json = try? JSONDecoder().decode(User.self, from: webData) {
                        DispatchQueue.global().async {
                            UserDefaults.standard.setValue(webData, forKey: "userData")
                            UserDefaults.standard.synchronize()
                        }

                        DispatchQueue.main.async {
                            self.main.user = json
                            self.main.isLoggedIn = true
                            if self.main.selectedIdOrScreen == "" {
                                self.main.selection = nil
                            } else {
                                self.main.selection = self.main.selectedIdOrScreen
                                self.main.selectedIdOrScreen = ""
                            }
                        }
                    } else if let error = try? JSONDecoder().decode(ErrorResponse.self, from: webData) {
                        DispatchQueue.main.async {
                            self.main.errorMessage = error.message
                        }
                    }
                }
            }
            .resume()
        }
    }
    
    func login(email: String, password: String) {
        self.main.errorMessage = ""
        if let url = URL(string: "\(serverURL)/api/users/login") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Application/JSON", forHTTPHeaderField: "Content-Type")
            let loginDetails: LoginModel = LoginModel(email: email, password: password)
            
            let encodedData = try? JSONEncoder().encode(loginDetails)
            //print(String(data: encodedData!, encoding: .utf8)!)
            
            request.httpBody = encodedData
            URLSession.shared.dataTask(with: request) { (data, response, _) in
                if let webData = data {
                    if let json = try? JSONDecoder().decode(User.self, from: webData) {
                        DispatchQueue.global().async {
                            UserDefaults.standard.setValue(webData, forKey: "userData")
                            UserDefaults.standard.synchronize()
                        }

                        DispatchQueue.main.async {
                            self.main.user = json
                            self.main.isLoggedIn = true
                            if self.main.selectedIdOrScreen == "" {
                                self.main.selection = nil
                            } else {
                                self.main.selection = self.main.selectedIdOrScreen
                                self.main.selectedIdOrScreen = ""
                            }
                        }
                    } else if let error = try? JSONDecoder().decode(ErrorResponse.self, from: webData) {
                        DispatchQueue.main.async {
                            self.main.errorMessage = error.message
                        }
                    }
                }
            }
            .resume()
        }
    }
    
    func logout() {
        self.main.user = User()
        self.main.isLoggedIn = false
        DispatchQueue.global().async {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(self.main.user) {
                UserDefaults.standard.setValue(encoded, forKey: "userData")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    func updateUserProfile(name: String, email: String, password: String) {
        self.main.errorMessage = ""
        if let url = URL(string: "\(serverURL)/api/users/profile") {
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("Bearer \(main.user.token)", forHTTPHeaderField: "Authorization")
            request.setValue("Application/JSON", forHTTPHeaderField: "Content-Type")
            let userProfileData: ProfileModel = ProfileModel(id: main.user._id, name: name, email: email, password: password)
            
            let encodedData = try? JSONEncoder().encode(userProfileData)
            //print(String(data: encodedData!, encoding: .utf8)!)
            
            request.httpBody = encodedData
            URLSession.shared.dataTask(with: request) { (data, response, _) in
                if let webData = data {
                    if let json = try? JSONDecoder().decode(User.self, from: webData) {
                        DispatchQueue.global().async {
                            UserDefaults.standard.setValue(webData, forKey: "userData")
                            UserDefaults.standard.synchronize()
                        }

                        DispatchQueue.main.async {
                            self.main.user = json
                            self.main.selection = "Profile"
                        }
                    } else if let error = try? JSONDecoder().decode(ErrorResponse.self, from: webData) {
                        DispatchQueue.main.async {
                            self.main.errorMessage = error.message
                        }
                    }
                }
            }
            .resume()
        }
    }
    
    func listUsers() {
        self.main.loading = true
        if let url = URL(string: "\(serverURL)/api/users") {
            var request = URLRequest(url: url)
            request.setValue("Bearer \(main.user.token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { (data, response, _) in
                if let webData = data {
                    if let json = try? JSONDecoder().decode([UserData].self, from: webData) {
                        DispatchQueue.main.async {
                            self.main.users = json
                            self.main.loading = false
                        }
                    } else if let error = try? JSONDecoder().decode(ErrorResponse.self, from: webData) {
                        DispatchQueue.main.async {
                            self.main.loading = false
                            self.main.errorMessage = error.message
                        }
                    }
                }
            }
            .resume()
        }
    }
    
    func getUserDetails(userId: String, completionHandler: @escaping (UserData) -> Void) {
        self.main.loading = true
        if let url = URL(string: "\(serverURL)/api/users/\(userId)") {
            var request = URLRequest(url: url)
            request.setValue("Bearer \(main.user.token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { (data, response, _) in
                if let webData = data {
                    if let json = try? JSONDecoder().decode(UserData.self, from: webData) {
                        DispatchQueue.main.async {
                            self.main.loading = false
                            completionHandler(json)
                        }
                    } else if let error = try? JSONDecoder().decode(ErrorResponse.self, from: webData) {
                        DispatchQueue.main.async {
                            self.main.loading = false
                            self.main.errorMessage = error.message
                        }
                    }
                }
            }
            .resume()
        }
    }
    
    func updateUser(user: UserData, completionHandler: @escaping () -> Void) {
        self.main.loading = true
        if let url = URL(string: "\(serverURL)/api/users/\(user._id)") {
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("Bearer \(main.user.token)", forHTTPHeaderField: "Authorization")
            request.setValue("Application/JSON", forHTTPHeaderField: "Content-Type")
            
            let encodedData = try? JSONEncoder().encode(user)
            //print(String(data: encodedData!, encoding: .utf8)!)
            
            request.httpBody = encodedData
            URLSession.shared.dataTask(with: request) { (data, response, _) in
                if let webData = data {
                    if let _ = try? JSONDecoder().decode(UserData.self, from: webData) {
                        DispatchQueue.main.async {
                            self.main.loading = false
                            completionHandler()
                        }
                    } else if let error = try? JSONDecoder().decode(ErrorResponse.self, from: webData) {
                        DispatchQueue.main.async {
                            self.main.errorMessage = error.message
                        }
                    }
                }
            }
            .resume()
        }
    }
    
    func deleteUser(userId: String) {
        if let url = URL(string: "\(serverURL)/api/users/\(userId)") {
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.setValue("Bearer \(main.user.token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { (data, response, _) in                if let webData = data {
                    if let json = try? JSONDecoder().decode([String : String].self, from: webData) {
                        DispatchQueue.main.async {
                            if json["message"]! == "User removed" {
                                self.listUsers()
                            } else {
                                self.main.errorMessage = json["message"]!
                            }
                        }
                    }
                }
            }
            .resume()
        }
    }
    
    func loadUserData() {
        DispatchQueue.global().async {
            if let data = UserDefaults.standard.data(forKey: "userData") {
                let decoder = JSONDecoder()
                if let decoded = try? decoder.decode(User.self, from: data) {
                    DispatchQueue.main.async {
                        if decoded.name != "" {
                            self.main.isLoggedIn = true
                        }
                        self.main.user = decoded
                    }
                }
            }
        }
    }
}
