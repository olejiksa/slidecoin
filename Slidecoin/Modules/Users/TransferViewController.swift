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
    
    private let accessToken: String
    private let currentUser: User
    private let receiver: User
    private let alertService = Assembly.alertService
    private let requestSender = Assembly.requestSender
    private var formValidationHelper: FormValidationHelper?
    
    @IBOutlet private weak var amountField: UITextField!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var submitButton: BigButton!
    
    init(accessToken: String, currentUser: User, receiver: User) {
        self.accessToken = accessToken
        self.currentUser = currentUser
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
            let sum = Int(amount), sum > 0
        else {
            let alert = self.alertService.alert("В поле ввода суммы допущена ошибка. Убедитесь, что число является целым, положительным и не превышает текущий баланс.")
            present(alert, animated: true)
            return
        }
        
        let config = RequestFactory.transfer(accessToken: accessToken,
                                             receiver: receiver,
                                             amount: sum)
        requestSender.send(config: config) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    let alert = self.alertService.alert(message,
                                                        title: .info,
                                                        isDestructive: false) { _ in
                        if message.contains("success") {
                            self.dismiss(animated: true)
                        }
                    }
                    
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
