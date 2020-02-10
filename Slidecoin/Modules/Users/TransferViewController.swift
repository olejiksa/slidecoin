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
    
    // MARK: Private Properties
    
    private let currentUser: User
    private let receiver: User
    private let withdrawMe: Bool
    private let alertService = Assembly.alertService
    private let requestSender = Assembly.requestSender
    private var formValidationHelper: FormValidationHelper?
    
    
    // MARK: Outlets
    
    @IBOutlet private weak var amountField: UITextField!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var submitButton: BigButton!
    
    var completionHandler: ((Int) -> ())?
    
    
    
    
    // MARK: Lifecycle
    
    init(currentUser: User, receiver: User, withdrawMe: Bool) {
        self.currentUser = currentUser
        self.receiver = receiver
        self.withdrawMe = withdrawMe
        
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
    
    
    // MARK: Private
    
    @IBAction private func submit() {
        guard
            let amount = amountField.text,
            let sum = Int(amount), sum > 0
        else {
            let alert = self.alertService.alert("В поле ввода суммы допущена ошибка. Убедитесь, что число является целым, положительным и не превышает текущий баланс.")
            present(alert, animated: true)
            return
        }
        
        self.submitButton.showLoading()
        
        if withdrawMe {
            let config = RequestFactory.transfer(receiver: receiver, amount: sum)
            requestSender.send(config: config) { [weak self] result in
                guard let self = self else { return }
                
                self.submitButton.hideLoading()
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let message):
                        self.completionHandler?(sum)
                        
                        let alert = self.alertService.alert(message,
                                                            title: .info,
                                                            isDestructive: false) { _ in
                            if message.contains("Transaction") {
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
        } else {
            let config = RequestFactory.addMoney(userID: receiver.id, amount: sum)
            requestSender.send(config: config) { [weak self] result in
                guard let self = self else { return }
                
                self.submitButton.hideLoading()
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let message):
                        self.completionHandler?(sum)
                        
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
    }
    
    private func setupFormValidationHelper() {
        let textFields: [UITextField] = [amountField]
        formValidationHelper = FormValidationHelper(textFields: textFields,
                                                    button: submitButton,
                                                    stackView: stackView)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = withdrawMe ? "Перевод" : "Пополнение"
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(close))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func close() {
        dismiss(animated: true)
    }
}
