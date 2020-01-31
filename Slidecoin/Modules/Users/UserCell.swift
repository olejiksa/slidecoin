//
//  UserCell.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 20.01.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class UserCell: UITableViewCell {

    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var balanceLabel: UILabel!
    
    private var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSeparator = " "
        numberFormatter.groupingSize = 3
        return numberFormatter
    }
    
    func setup(user: User) {
        usernameLabel?.text = user.username
        emailLabel?.text = user.email
        
        guard let balance = numberFormatter.string(from: user.balance as NSNumber) else { return }
        balanceLabel?.text = "\(balance) \(Global.currencySymbol)"
    }
}
