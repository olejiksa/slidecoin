//
//  Product.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 18.01.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

struct Product: Decodable {
    
    let id: Int?
    let name: String
    let price: Int
    let description: String
    let amount: Int?
}

struct ShopResponse: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case items
    }
    
    let items: [Product]
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let array = try? values.decode([Product].self, forKey: .items)
        items = array ?? []
    }
}
