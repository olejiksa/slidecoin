//
//  TransactionsParser.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 19.01.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import Toolkit

final class TransactionsParser: ParserProtocol {
    
    func parse(data: Data) -> [Transaction]? {
        do {
            let jsonDecorder = JSONDecoder()
            jsonDecorder.dateDecodingStrategy = .iso8601
            let response = try jsonDecorder.decode(TransactionsResponse.self, from: data)
            return response.transactions
        } catch  {
            print(error)
            return nil
        }
    }
}
