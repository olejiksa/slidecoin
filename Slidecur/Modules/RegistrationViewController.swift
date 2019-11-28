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
    private let keyboardService: KeyboardServiceProtocol = KeyboardService()
    private var buttonValidationHelper: ButtonValidationHelper?
    
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var repeatPasswordField: UITextField!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        keyboardService.view = view
        keyboardService.scrollView = scrollView
        usernameField.delegate = keyboardService
        passwordField.delegate = keyboardService
        repeatPasswordField.delegate = keyboardService
        
        navigationItem.title = "Регистрация"
        
        let textFields: [UITextField] = [usernameField!, passwordField!, repeatPasswordField!]
        buttonValidationHelper = ButtonValidationHelper(textFields: textFields, button: doneButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillBeHidden),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillChangeFrameNotification,
                                                  object: nil)
    }
    
    
    // MARK: Private

    @IBAction private func registrationDidTap() {
        guard
            let login = usernameField.text,
            let password = passwordField.text,
            let repeatPassword = repeatPasswordField.text
        else { return }
        
        guard password == repeatPassword else {
            alert(title: "Сообщение", "Введенные пароли не совпадают")
            return
        }
            
        let config = RequestFactory.register(username: login, password: password)
        
        requestSender.send(config: config) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let login):
                    self?.alert(title: "Сообщение", login.message) {
                        if login.accessToken != nil, login.refreshToken != nil {
                            let scene = UIApplication.shared.connectedScenes.first
                            if let mySceneDelegate = scene?.delegate as? SceneDelegate {
                                let vc = MainViewController(login: login)
                                let nvc = UINavigationController(rootViewController: vc)
                                mySceneDelegate.window?.rootViewController = nvc
                            }
                        }
                    }
                    
                case .failure(let error):
                    self?.alert(title: "Сообщение", error.localizedDescription)
                }
            }
        }
    }
    
    private func alert(title: String, _ message: String, okAction: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            okAction?()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    @objc private func keyboardWillBeHidden() {
        keyboardService.keyboardWillBeHidden()
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        keyboardService.keyboardWillShow(notification: notification)
    }
}
