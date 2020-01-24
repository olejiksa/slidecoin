//
//  AccessTokenParser.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 19.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Foundation
import Toolkit

final class AccessTokenParser: ParserProtocol {
    
    func parse(data: Data) -> String? {
        do {
            let jsonDecorder = JSONDecoder()
            jsonDecorder.dateDecodingStrategy = .iso8601
            jsonDecorder.keyDecodingStrategy = .convertFromSnakeCase
            let response = try jsonDecorder.decode(AccessToken.self, from: data)
            return response.accessToken
        } catch  {
            print(error)
            return nil
        }
    }
}
