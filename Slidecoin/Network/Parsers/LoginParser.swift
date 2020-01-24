//
//  LoginParser.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 26.11.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Foundation
import Toolkit

final class LoginParser: ParserProtocol {
    
    func parse(data: Data) -> Login? {
        do {
            let jsonDecorder = JSONDecoder()
            jsonDecorder.dateDecodingStrategy = .iso8601
            jsonDecorder.keyDecodingStrategy = .convertFromSnakeCase
            return try jsonDecorder.decode(Login.self, from: data)
        } catch  {
            print(error)
            return nil
        }
    }
}
