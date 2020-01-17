//
//  AccessCodeViewController.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 22.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Toolkit
import UIKit

final class AccessCodeViewController: UIViewController {
    
    // MARK: Private Properties
    
    private let alertService = Assembly.alertService
    private let requestSender = Assembly.requestSender
    private var formValidationHelper: FormValidationHelper?
    
    
    // MARK: Outlets
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var doneButton: BigButton!
    @IBOutlet private weak var urlField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var repeatPasswordField: UITextField!
    @IBOutlet private weak var stackView: UIStackView!
    
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboard()
        setupNavigationBar()
        setupFormValidationHelper()
    }
    
    
    // MARK: Private
    
    private func setupKeyboard() {
        scrollView.bottomAnchor.constraint(lessThanOrEqualTo: keyboardLayoutGuide.topAnchor).isActive = true
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Новый пароль"
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(close))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    private func setupFormValidationHelper() {
        formValidationHelper = FormValidationHelper(textFields: [urlField],
                                                    button: doneButton,
                                                    stackView: stackView)
    }
    
    @IBAction private func continueDidTap() {
        guard
            let url = urlField.text,
            let newPassword = passwordField.text
        else { return }
        
        doneButton.showLoading()
            
        let token = String(url.split(separator: "=")[1])
        let config = RequestFactory.reset(newPassword: newPassword, token: token)
        requestSender.send(config: config) { [weak self] result in
            guard let self = self else { return }

            self.doneButton.hideLoading()

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
    
    @objc private func close() {
        self.dismiss(animated: true)
    }
}
