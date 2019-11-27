//
//  LoginParser.swift
//  Slidecur
//
//  Created by Oleg Samoylov on 26.11.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Foundation

final class LoginParser: ParserProtocol {
    
    func parse(data: Data) -> Login? {
        do {
            let jsonDecorder = JSONDecoder()
            jsonDecorder.dateDecodingStrategy = .iso8601
            return try jsonDecorder.decode(Login.self, from: data)
        } catch  {
            print(error)
            return nil
        }
    }
}
