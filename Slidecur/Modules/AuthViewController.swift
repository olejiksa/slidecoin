//
//  AuthViewController.swift
//  Slidecur
//
//  Created by Oleg Samoylov on 26.11.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class AuthViewController: UIViewController {

    // MARK: Private Properties
    
    private let requestSender: RequestSenderProtocol = RequestSender()
    private var buttonValidationHelper: ButtonValidationHelper?
    private var activeField: UITextField?
    
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registrationButton: UIButton!
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Авторизация"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let textFields: [UITextField] = [usernameField!, passwordField!]
        buttonValidationHelper = ButtonValidationHelper(textFields: textFields, button: loginButton)
        
        let defaults = UserDefaults.standard
        let message = defaults.string(forKey: "message")
        let accessToken = defaults.string(forKey: "access_token")
        let refreshToken = defaults.string(forKey: "refresh_token")
        
        if let message = message, let accessToken = accessToken, let refreshToken = refreshToken {
            let login = Login(refreshToken: refreshToken, accessToken: accessToken, message: message)
            let vc = MainViewController(login: login)
            navigationController?.pushViewController(vc, animated: true)
        }
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
    
    @IBAction private func loginDidTap() {
        guard
            let login = usernameField.text,
            let password = passwordField.text
        else { return }
            
        let config = RequestFactory.login(username: login, password: password)
        
        requestSender.send(config: config) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let login):
                    if login.accessToken != nil, login.refreshToken != nil {
                        let vc = MainViewController(login: login)
                        self?.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        self?.alert(title: "Сообщение", login.message)
                    }
                    
                case .failure(let error):
                    self?.alert(title: "Сообщение", error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction private func registrationDidTap() {
        let vc = RegistrationViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func keyboardWillBeHidden() {
        let contentInsets: UIEdgeInsets = .zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let activeField = activeField else { return }
        
        let value = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue
        let kbSize = (value?.cgRectValue.size)!
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        var aRect = view.frame
        aRect.size.height -= kbSize.height
        if !aRect.contains(activeField.frame.origin) {
            scrollView.scrollRectToVisible(activeField.frame, animated: true)
        }
    }
    
    private func alert(title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
}


// MARK: - UITextFieldDelegate

extension AuthViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        return true
    }
}
