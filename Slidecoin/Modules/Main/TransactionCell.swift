//
//  TransactionCell.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 24.01.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Toolkit

final class TransactionCell: DetailCell {
    
    func setup(transaction: Transaction, user: User) {
        textLabel?.text = "\(transaction.amount) \(Global.currencySymbol)"
        
        let condition = transaction.amount < 0 || user.id == transaction.senderID || transaction.receiverID == 0
        textLabel?.textColor = condition ? .systemRed : .systemGreen
        
        switch user.id {
        case transaction.receiverID:
            detailTextLabel?.text = "Пополнение (от кого): \(transaction.senderID)"
            
        case transaction.senderID:
            detailTextLabel?.text = "Перевод (кому): \(transaction.receiverID)"
            
        default:
            detailTextLabel?.text = "От \(transaction.senderID) к \(transaction.receiverID)"
        }
        
        if transaction.receiverID == 0 {
            detailTextLabel?.text = "Покупка (кем): \(transaction.senderID)"
        }
    }
}
