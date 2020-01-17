//
//  TransferViewController.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 22.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Toolkit
import UIKit

final class TransferViewController: UIViewController {
    
    private let receiver: User
    private let alertService = Assembly.alertService
    private let requestSender = Assembly.requestSender
    private var formValidationHelper: FormValidationHelper?
    
    @IBOutlet private weak var amountField: UITextField!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var submitButton: BigButton!
    
    init(receiver: User) {
        self.receiver = receiver
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupFormValidationHelper()
    }
    
    @IBAction private func submit() {
        guard
            let amount = amountField.text,
            let sum = Int(amount)
        else { return }
        
        let me = User(id: 16, balance: 0, username: "", email: "", name: "", surname: "")
        
        let config = RequestFactory.transfer(sender: me, receiver: receiver, amount: sum)
        requestSender.send(config: config) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    let alert = self.alertService.alert(message.message)
                    self.present(alert, animated: true)
                    
                case .failure(let error):
                    let alert = self.alertService.alert(error.localizedDescription)
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    
    private func setupFormValidationHelper() {
        let textFields: [UITextField] = [amountField]
        formValidationHelper = FormValidationHelper(textFields: textFields,
                                                    button: submitButton,
                                                    stackView: stackView)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Перевод"
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(close))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func close() {
        dismiss(animated: true)
    }
}
