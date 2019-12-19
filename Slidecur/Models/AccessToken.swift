//
//  AccessToken.swift
//  Slidecur
//
//  Created by Oleg Samoylov on 19.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

struct AccessToken: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
    
    let accessToken: String
}
