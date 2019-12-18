//
//  SecretParser.swift
//  Slidecur
//
//  Created by Oleg Samoylov on 19.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Foundation
import Toolkit

final class SecretParser: ParserProtocol {
    
    func parse(data: Data) -> Secret? {
        do {
            let jsonDecorder = JSONDecoder()
            jsonDecorder.dateDecodingStrategy = .iso8601
            return try jsonDecorder.decode(Secret.self, from: data)
        } catch  {
            print(error)
            return nil
        }
    }
}
