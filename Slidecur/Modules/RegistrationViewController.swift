//
//  RegistrationViewController.swift
//  Slidecur
//
//  Created by Oleg Samoylov on 27.11.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit
import Toolkit

final class RegistrationViewController: UIViewController {

    // MARK: Private Propterties
    
    private let requestSender: RequestSenderProtocol = RequestSender()
    private let alertService: AlertServiceProtocol = AlertService()
    private let keyboardService: KeyboardServiceProtocol = KeyboardService()
    private var buttonValidationHelper: ButtonValidationHelper?
    
    
    // MARK: Outlets
    
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var repeatPasswordField: UITextField!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegates()
        setupNavigationBar()
        setupButtonValidationHelper()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        keyboardService.register()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        keyboardService.unregister()
    }
    
    
    // MARK: Private
    
    private func setupDelegates() {
        keyboardService.view = view
        keyboardService.scrollView = scrollView
        usernameField.delegate = keyboardService
        passwordField.delegate = keyboardService
        repeatPasswordField.delegate = keyboardService
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Регистрация"
    }
    
    private func setupButtonValidationHelper() {
        let textFields: [UITextField] = [usernameField, passwordField, repeatPasswordField]
        buttonValidationHelper = ButtonValidationHelper(textFields: textFields, button: doneButton)
    }

    @IBAction private func registrationDidTap() {
        guard
            let login = usernameField.text,
            let password = passwordField.text,
            let repeatPassword = repeatPasswordField.text
        else { return }
        
        guard password == repeatPassword else {
            let alert = alertService.alert("Введенные пароли не совпадают")
            present(alert, animated: true)
            return
        }
            
        let config = RequestFactory.register(username: login, password: password)
        
        requestSender.send(config: config) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let login):
                    if login.accessToken != nil, login.refreshToken != nil {
                        let scene = UIApplication.shared.connectedScenes.first
                        if let mySceneDelegate = scene?.delegate as? SceneDelegate {
                            let vc = MainViewController(login: login)
                            let nvc = UINavigationController(rootViewController: vc)
                            mySceneDelegate.window?.rootViewController = nvc
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
}
