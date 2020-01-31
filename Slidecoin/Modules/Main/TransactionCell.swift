//
//  TransactionCell.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 24.01.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import Toolkit

final class TransactionCell: DetailCell {
    
    private var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSeparator = " "
        numberFormatter.groupingSize = 3
        return numberFormatter
    }
    
    func setup(transaction: Transaction, userIDs: [Int: String], user: User) {
        guard let amount = numberFormatter.string(from: transaction.amount as NSNumber) else { return }
        textLabel?.text = "\(amount) \(Global.currencySymbol)"
        
        let condition = transaction.amount < 0 || user.id == transaction.senderID || transaction.receiverID == 0
        textLabel?.textColor = condition ? .systemRed : .systemGreen
        
        if transaction.amount == 0 {
            textLabel?.textColor = nil
        }
        
        if transaction.receiverID == 0 {
            if user.id == transaction.senderID {
                detailTextLabel?.text = "Покупка"
            } else {
                let username = userIDs[transaction.senderID]
                detailTextLabel?.text = username != nil ? "Покупка \(username!)" : "Покупка"
            }
            
            return
        }
        
        switch user.id {
        case transaction.receiverID:
            let username = userIDs[transaction.senderID]!
            detailTextLabel?.text = "Пополнение от \(username)"
            
        case transaction.senderID:
            let username = userIDs[transaction.receiverID]
            detailTextLabel?.text = username != nil ? "Перевод \(username!)" : "Перевод"
            
        default:
            let senderUsername = userIDs[transaction.senderID]!
            let receiverUsername = userIDs[transaction.receiverID]!
            detailTextLabel?.text = "От \(senderUsername) к \(receiverUsername)"
        }
    }
}
