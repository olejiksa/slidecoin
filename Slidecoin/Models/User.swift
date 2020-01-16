//
//  User.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 18.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

struct User: Decodable {
    
    let username: String
}

struct UsersResponse: Decodable {
    
    let users: [User]
}
