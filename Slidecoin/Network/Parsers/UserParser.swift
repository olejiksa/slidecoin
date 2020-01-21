//
//  UserParser.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 19.01.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import Toolkit

final class UserParser: ParserProtocol {
    
    func parse(data: Data) -> User? {
        do {
            let jsonDecorder = JSONDecoder()
            jsonDecorder.dateDecodingStrategy = .iso8601
            let response = try jsonDecorder.decode(UserResponse.self, from: data)
            return response.user
        } catch  {
            print(error)
            return nil
        }
    }
}
