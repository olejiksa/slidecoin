//
//  ShopParser.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 24.01.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import Toolkit

final class ShopParser: ParserProtocol {
    
    func parse(data: Data) -> [Product]? {
        do {
            let jsonDecorder = JSONDecoder()
            jsonDecorder.dateDecodingStrategy = .iso8601
            let response = try jsonDecorder.decode(ShopResponse.self, from: data)
            return response.items
        } catch  {
            print(error)
            return nil
        }
    }
}
