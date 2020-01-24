//
//  Login.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 26.11.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

struct Login: Decodable {
    
    let refreshToken: String?
    var accessToken: String?
    var message: String
}
