//
//  User.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 18.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

struct User: Decodable {
    
    let id: Int
    var balance: Int
    let username: String
    let email: String
    let name: String
    let surname: String
    let isAdmin: Bool
}

struct UserResponse: Decodable {
    
    let user: User
}

struct UsersResponse: Decodable {
    
    let users: [User]
}
