//
//  AuthViewController.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 26.11.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import JWTDecode
import KeyboardAdjuster
import Toolkit
import UIKit

final class AuthViewController: UIViewController {

    // MARK: Private Properties
    
    private let alertService = Assembly.alertService
    private let userDefaultsService = Assembly.userDefaultsService
    private let requestSender = Assembly.requestSender

    private var formValidationHelper: FormValidationHelper?
    
    
    // MARK: Outlets
    
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    
    @IBOutlet private weak var loginButton: BigButton!
    @IBOutlet private weak var registrationButton: UIButton!
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
    @IBOutlet private weak var rememberSwitch: UISwitch!
    
    @IBOutlet private weak var stackView: UIStackView!
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboard()
        setupNavigationBar()
        setupButtonNavigationHelper()
        rememberSwitch.onTintColor = Global.color
    }
    
    
    // MARK: - Actions
    
    @IBAction private func loginDidTap() {
        guard
            let username = usernameField.text,
            let password = passwordField.text
        else { return }
        
        loginButton.showLoading()
            
        login(username: username, password: password)
    }
    
    @IBAction private func registrationDidTap() {
        let vc = RegistrationViewController()
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .formSheet
        present(nvc, animated: true)
    }
    
    @IBAction func restoreDidTap() {
        let vc = PreRestoreViewController()
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .formSheet
        present(nvc, animated: true)
    }
    
    
    // MARK: Private
    
    private func setupKeyboard() {
        scrollView.bottomAnchor.constraint(lessThanOrEqualTo: keyboardLayoutGuide.topAnchor).isActive = true
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Авторизация"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupButtonNavigationHelper() {
        let textFields: [UITextField] = [usernameField, passwordField]
        formValidationHelper = FormValidationHelper(textFields: textFields,
                                                    button: loginButton,
                                                    stackView: stackView)
    }
    
    private func login(username: String, password: String) {
        let config = RequestFactory.login(username: username, password: password)
        
        requestSender.send(config: config) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(var login):
                    if let accessToken = login.accessToken,
                        let refreshToken = login.refreshToken,
                        let jwtAccess = try? decode(jwt: accessToken) {
                        
                        Global.accessToken = accessToken
                        Global.refreshToken = refreshToken
                        
                        guard
                            let accessBody = try? JSONSerialization.data(withJSONObject: jwtAccess.body, options: []),
                            let access = try? JSONDecoder().decode(Token.self, from: accessBody)
                        else { return }
                        
                        let scene = UIApplication.shared.connectedScenes.first
                        if let mySceneDelegate = scene?.delegate as? SceneDelegate {
                            login.message = username
                            
                            if self.rememberSwitch.isOn {
                                self.userDefaultsService.updateLogin(with: login)
                                self.userDefaultsService.updateUser(access.identity)
                            }
                            
                            let tabBarController = TabBarBuilder.build(login: login, user: access.identity)
                            mySceneDelegate.window?.rootViewController = tabBarController
                        }
                    } else {
                        self.loginButton.hideLoading()

                        let alert = self.alertService.alert(login.message)
                        self.present(alert, animated: true)
                    }
                    
                case .failure(let error):
                    self.loginButton.hideLoading()
                    
                    let alert = self.alertService.alert(error.localizedDescription)
                    self.present(alert, animated: true)
                }
            }
        }
    }
}
