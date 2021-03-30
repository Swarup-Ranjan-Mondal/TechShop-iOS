//
//  User.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 12/01/21.
//

import SwiftUI

class User: Codable, Identifiable {
    var _id: String = ""
    var name: String = ""
    var email: String = ""
    var isAdmin: Bool = false
    var token: String = ""
}

class UserData: Codable, Identifiable {
    var _id: String = ""
    var name: String = ""
    var email: String = ""
    var isAdmin: Bool = false
}
