//
//  Transaction.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 19.01.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

struct Transaction: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case amount
        case receiverID = "receiver_id"
        case senderID = "sender_id"
        case date
    }
    
    let identifier: Int
    let amount: Int
    let receiverID: Int
    let senderID: Int
    let date: Date
}

struct TransactionsResponse: Decodable {
    
    let transactions: [Transaction]
}
