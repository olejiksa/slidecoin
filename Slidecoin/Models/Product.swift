//
//  Product.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 18.01.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

struct Product: Decodable {
    
    let id: Int
    let name: String
    let price: Int
    let description: String
    let amount: Int?
}

struct ShopResponse: Decodable {
    
    let items: [Product]
}
