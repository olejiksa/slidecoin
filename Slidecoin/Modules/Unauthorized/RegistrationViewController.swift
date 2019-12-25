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
    private let keyboardService = Assembly.keyboardService
    private let requestSender = Assembly.requestSender

    private var buttonValidationHelper: ButtonValidationHelper?
    
    
    // MARK: Outlets
    
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var repeatPasswordField: UITextField!
    @IBOutlet private weak var doneButton: BigButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var matchLabel: UILabel!
    
    
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
    
    
    // MARK: Actions

    @IBAction private func registrationDidTap() {
        guard
            let username = usernameField.text,
            let password = passwordField.text
        else { return }
            
        let config = RequestFactory.register(username: username, password: password)
        doneButton.showLoading()
        
        requestSender.send(config: config) { [weak self] result in
            guard let self = self else { return }
            
            self.doneButton.hideLoading()
            
            DispatchQueue.main.async {
                switch result {
                case .success(var login):
                    if login.accessToken != nil, login.refreshToken != nil {
                        let scene = UIApplication.shared.connectedScenes.first
                        if let mySceneDelegate = scene?.delegate as? SceneDelegate {
                            login.message = username
                            self.credentialsService.updateCredentials(with: login)
                            
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
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(close))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    private func setupButtonValidationHelper() {
        let textFields: [UITextField] = [usernameField, passwordField, repeatPasswordField]
        buttonValidationHelper = ButtonValidationHelper(textFields: textFields,
                                                        button: doneButton,
                                                        matchLabel: matchLabel)
    }
    
    @objc private func close() {
        dismiss(animated: true)
    }
}
