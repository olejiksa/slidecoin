//
//  RegistrationViewController.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 27.11.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit
import Toolkit

final class RegistrationViewController: UIViewController {

    // MARK: Private Propterties
    
    private let alertService = Assembly.alertService
    private let credentialsService = Assembly.credentialsService
    private let requestSender = Assembly.requestSender

    private var formValidationHelper: FormValidationHelper?
    
    
    // MARK: Outlets
    
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var surnameField: UITextField!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var repeatPasswordField: UITextField!
    @IBOutlet private weak var doneButton: BigButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var stackView: UIStackView!
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboard()
        setupNavigationBar()
        setupFormValidationHelper()
    }
    
    
    // MARK: Actions

    @IBAction private func registrationDidTap() {
        guard
            let username = usernameField.text,
            let password = passwordField.text,
            let email = emailField.text,
            let name = nameField.text,
            let surname = surnameField.text
        else { return }
            
        let config = RequestFactory.register(username: username,
                                             password: password,
                                             email: email,
                                             name: name,
                                             surname: surname)
        doneButton.showLoading()
        
        requestSender.send(config: config) { [weak self] result in
            guard let self = self else { return }
            
            self.doneButton.hideLoading()
            
            DispatchQueue.main.async {
                switch result {
                case .success(var login):
                    if let accessToken = login.accessToken, login.refreshToken != nil {
                        let usersConfig = RequestFactory.users(accessToken: accessToken)
                        self.requestSender.send(config: usersConfig) { result in
                            switch result {
                            case .success(let users):
                                guard let user = users.first(where: { $0.username == username }) else {
                                    let alert = self.alertService.alert("User \(username) doesn't exist")
                                    self.present(alert, animated: true)
                                    return
                                }
                                
                                let scene = UIApplication.shared.connectedScenes.first
                                if let mySceneDelegate = scene?.delegate as? SceneDelegate {
                                    login.message = username
                                    self.credentialsService.updateLogin(with: login)
                                    self.credentialsService.updateUser(user)
                                    
                                    let tabBarController = TabBarBuilder.build(login: login, user: user)
                                    mySceneDelegate.window?.rootViewController = tabBarController
                                }
                            
                            case .failure(let error):
                                let alert = self.alertService.alert(error.localizedDescription)
                                self.present(alert, animated: true)
                            }
                        }
                    } else {
                        let alert = self.alertService.alert(login.message)
                        self.present(alert, animated: true)
                    }
                    
                case .failure(let error):
                    let alert = self.alertService.alert(error.localizedDescription)
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    
    // MARK: Private
    
    private func setupKeyboard() {
        scrollView.bottomAnchor.constraint(lessThanOrEqualTo: keyboardLayoutGuide.topAnchor).isActive = true
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Регистрация"
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(close))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    private func setupFormValidationHelper() {
        let textFields: [UITextField] = [usernameField,
                                         nameField,
                                         surnameField,
                                         emailField,
                                         passwordField,
                                         repeatPasswordField]
        formValidationHelper = FormValidationHelper(textFields: textFields,
                                                    button: doneButton,
                                                    stackView: stackView)
    }
    
    @objc private func close() {
        dismiss(animated: true)
    }
}
