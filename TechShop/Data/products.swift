//
//  productData.swift
//  TechShop
//
//  Created by Swarup Ranjan Mondal on 09/01/21.
//

import Foundation

var product1: Product {
    let product = Product()
    
    product._id = "1"
    product.name = "Airpods Wireless Bluetooth Headphones"
    product.image = "airpods"
    product.description =
      "Bluetooth technology lets you connect it with compatible devices wirelessly High-quality AAC audio offers immersive listening experience Built-in microphone allows you to take calls while working"
    product.brand = "Apple"
    product.category = "Electronics"
    product.price = 89.99
    product.countInStock = 10
    product.rating = 4.5
    product.numReviews = 12
    
    return product
}

var product2: Product {
    let product = Product()
    
    product._id = "2"
    product.name = "iPhone 11 Pro 256GB Memory"
    product.image = "phone"
    product.description =
      "Introducing the iPhone 11 Pro. A transformative triple-camera system that adds tons of capability without complexity. An unprecedented leap in battery life"
    product.brand = "Apple"
    product.category = "Electronics"
    product.price = 599.99
    product.countInStock = 7
    product.rating = 4.0
    product.numReviews = 8
    
    return product
}

var product3: Product {
    let product = Product()
    
    product._id = "3"
    product.name = "Cannon EOS 80D DSLR Camera"
    product.image = "camera"
    product.description =
      "Characterized by versatile imaging specs, the Canon EOS 80D further clarifies itself using a pair of robust focusing systems and an intuitive design"
    product.brand = "Cannon"
    product.category = "Electronics"
    product.price = 929.99
    product.countInStock = 5
    product.rating = 3
    product.numReviews = 12
    
    return product
}

var product4: Product {
    let product = Product()
    
    product._id = "4"
    product.name = "Sony Playstation 4 Pro White Version"
    product.image = "playstation"
    product.description =
      "The ultimate home entertainment center starts with PlayStation. Whether you are into gaming, HD movies, television, music"
    product.brand = "Sony"
    product.category = "Electronics"
    product.price = 399.99
    product.countInStock = 11
    product.rating = 5
    product.numReviews = 12
    
    return product
}

var product5: Product {
    let product = Product()
    
    product._id = "5"
    product.name = "Logitech G-Series Gaming Mouse"
    product.image = "mouse"
    product.description =
      "Get a better handle on your games with this Logitech LIGHTSYNC gaming mouse. The six programmable buttons allow customization for a smooth playing experience"
    product.brand = "Logitech"
    product.category = "Electronics"
    product.price = 49.99
    product.countInStock = 7
    product.rating = 3.5
    product.numReviews = 10
    
    return product
}

var product6: Product {
    let product = Product()
    
    product._id = "6"
    product.name = "Amazon Echo Dot 3rd Generation"
    product.image = "alexa"
    product.description =
      "Meet Echo Dot - Our most popular smart speaker with a fabric design. It is our most compact smart speaker that fits perfectly into small space"
    product.brand = "Amazon"
    product.category = "Electronics"
    product.price = 29.99
    product.countInStock = 0
    product.rating = 4
    product.numReviews = 12
    
    return product
}

let testProducts: [Product] = [product1, product2, product3, product4, product5]
