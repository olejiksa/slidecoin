//
//  TransactionViewController.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 10.02.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class TransactionViewController: UIViewController {

    @IBOutlet private weak var datetimeLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var senderLabel: UILabel!
    @IBOutlet private weak var receiverLabel: UILabel!
    
    private let dateFormatter = DateFormatter()
    private var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSeparator = " "
        numberFormatter.groupingSize = 3
        return numberFormatter
    }
    
    private let transaction: Transaction
    private let senderName: String?
    private let receiverName: String?
    
    init(transaction: Transaction, senderName: String?, receiverName: String?) {
        self.transaction = transaction
        self.senderName = senderName
        self.receiverName = receiverName
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupView()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = transaction.type.description
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "printer"),
//                                                            style: .plain,
//                                                            target: nil, action: nil)
    }
    
    private func setupView() {
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        
        datetimeLabel.text = dateFormatter.string(from: transaction.date)
        amountLabel.text = numberFormatter.string(from: transaction.amount as NSNumber)! + " y.e."
        senderLabel.text = senderName ?? "Нет отправителя"
        receiverLabel.text = receiverName ?? "Нет получателя"
    }
}
