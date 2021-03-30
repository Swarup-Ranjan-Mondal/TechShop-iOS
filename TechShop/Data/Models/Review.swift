//
//  Review.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 11/01/21.
//

import SwiftUI

class Review: ObservableObject, Identifiable, Codable {
    var _id: String = ""
    var name: String = ""
    var rating: Double = 0.0
    var comment: String = ""
    var user: String = ""
    var createdAt: String = ""
}

class CreateReview: Codable {
    var rating: Int
    var comment: String
    
    init(rating: Int, comment: String) {
        self.rating = rating
        self.comment = comment
    }
}
