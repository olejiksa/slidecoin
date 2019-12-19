//
//  Login.swift
//  Slidecur
//
//  Created by Oleg Samoylov on 26.11.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

struct Login: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
        case accessToken = "access_token"
        case message
    }
    
    let refreshToken: String?
    var accessToken: String?
    let message: String
}
