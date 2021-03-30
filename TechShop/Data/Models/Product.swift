//
//  Product.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 09/01/21.
//

import SwiftUI

class Product: ObservableObject, Identifiable, Codable {
    var _id: String = ""
    var name: String = ""
    var image: String = ""
    var imageData: Data?
    var description: String = ""
    var brand: String = ""
    var category: String = ""
    var price: Double = 0.0
    var countInStock: Int = 0
    var rating: Double = 0.0
    var numReviews: Int = 0
    var reviews: [Review] = []
    
    func getImage() -> Image? {
        if let data = imageData {
            if let uiImage = UIImage(data: data) {
                return Image(uiImage: uiImage)
            }
        }
        
        return nil
    }
}

class ProductData: ObservableObject, Codable {
    @Published var _id: String
    @Published var name: String
    @Published var price: Double
    @Published var image: String
    @Published var imageData: Data?
    @Published var brand: String
    @Published var category: String
    @Published var countInStock: Int
    @Published var description: String
    
    enum CodingKeys: CodingKey {
        case _id
        case name
        case price
        case image
        case imageData
        case brand
        case category
        case countInStock
        case description
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _id = try container.decode(String.self, forKey: ._id)
        name = try container.decode(String.self, forKey: .name)
        price = try container.decode(Double.self, forKey: .price)
        image = try container.decode(String.self, forKey: .image)
        imageData = try container.decode(Data?.self, forKey: .imageData)
        brand = try container.decode(String.self, forKey: .brand)
        category = try container.decode(String.self, forKey: .category)
        countInStock = try container.decode(Int.self, forKey: .countInStock)
        description = try container.decode(String.self, forKey: .description)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_id, forKey: ._id)
        try container.encode(name, forKey: .name)
        try container.encode(price, forKey: .price)
        try container.encode(image, forKey: .image)
        try container.encode(imageData, forKey: .imageData)
        try container.encode(brand, forKey: .brand)
        try container.encode(category, forKey: .category)
        try container.encode(countInStock, forKey: .countInStock)
        try container.encode(description, forKey: .description)
    }
    
    init(
        _id: String,
        name: String,
        price: Double,
        image: String,
        imageData: Data?,
        brand: String,
        category: String,
        countInStock: Int,
        description: String
    ) {
        self._id = _id
        self.name = name
        self.price = price
        self.image = image
        self.imageData = imageData
        self.brand = brand
        self.category = category
        self.countInStock = countInStock
        self.description = description
    }
}
