//
//  Login.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 26.11.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

struct Login: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case refreshToken
        case accessToken
        case message
    }
    
    let refreshToken: String?
    var accessToken: String?
    var message: String
    
    init(refreshToken: String?, accessToken: String?, message: String) {
        self.refreshToken = refreshToken
        self.accessToken = accessToken
        self.message = message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let refreshToken = try? container.decode(String.self, forKey: .refreshToken)
        let accessToken = try? container.decode(String.self, forKey: .accessToken)
        
        if let messageString = try? container.decode(String.self, forKey: .message) {
            self.init(refreshToken: refreshToken, accessToken: accessToken, message: messageString)
        } else {
            let message = try container.decode([String: String].self, forKey: .message).description
            self.init(refreshToken: refreshToken, accessToken: accessToken, message: message)
        }
    }
}
