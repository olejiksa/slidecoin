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
            jsonDecorder.dateDecodingStrategy = .custom(customDateDecoder)
            let response = try jsonDecorder.decode(TransactionsResponse.self, from: data)
            return response.transactions
        } catch  {
            print(error)
            return nil
        }
    }
    
    private func customDateDecoder(decoder: Decoder) throws -> Date {
        let container = try decoder.singleValueContainer()
        let str = try container.decode(String.self)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        let date = dateFormatter.date(from: str)
        return date ?? Date()
    }
}
