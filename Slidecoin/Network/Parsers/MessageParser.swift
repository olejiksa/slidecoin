//
//  MessageParser.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 25.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Foundation
import Toolkit

final class MessageParser: ParserProtocol {
    
    func parse(data: Data) -> Message? {
        do {
            let jsonDecorder = JSONDecoder()
            jsonDecorder.dateDecodingStrategy = .iso8601
            return try jsonDecorder.decode(Message.self, from: data)
        } catch  {
            print(error)
            return nil
        }
    }
}
