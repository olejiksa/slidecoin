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
        
        switch transaction.type {
        case .purchase:
            textLabel?.textColor = .label
            detailTextLabel?.text = "Покупка"
        
        case .moneyAdding:
            textLabel?.textColor = .label
            detailTextLabel?.text = "Пополнение"
            
        case .transfer:
            textLabel?.textColor = .label
            detailTextLabel?.text = "Перевод"
        }
        
        if transaction.amount == 0 {
            textLabel?.textColor = .label
        }
    }
}
