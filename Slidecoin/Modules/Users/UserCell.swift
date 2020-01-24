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
    
    func setup(user: User) {
        usernameLabel?.text = user.username
        emailLabel?.text = user.email
        balanceLabel?.text = "\(user.balance) \(Global.currencySymbol)"
    }
}
