//
//  UsersParser.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 18.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Foundation
import Toolkit

final class UsersParser: ParserProtocol {
    
    func parse(data: Data) -> [User]? {
        do {
            let jsonDecorder = JSONDecoder()
            jsonDecorder.dateDecodingStrategy = .iso8601
            let response = try jsonDecorder.decode(UsersResponse.self, from: data)
            return response.users
        } catch  {
            print(error)
            return nil
        }
    }
}
