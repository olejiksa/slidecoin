//
//  Token.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 19.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

struct Token: Decodable {
    
    let identity: User
    let type: TokenType
    let jti: String
}

enum TokenType: String, Decodable {
    
    case access
    case refresh
}

struct TokenRefresh: Decodable {
    
    let accessToken: String
}
