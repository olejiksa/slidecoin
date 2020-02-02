//
//  Message.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 25.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

struct Message: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case message = "message"
    }
    
    let message: String
    
    init(message: String) {
        self.message = message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let messageString = try? container.decode(String.self, forKey: .message) {
            self.init(message: messageString)
        } else {
            let message = try container.decode([String: String].self, forKey: .message).description
            self.init(message: message)
        }
    }
}
