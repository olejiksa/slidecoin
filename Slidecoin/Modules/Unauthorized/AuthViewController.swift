//
//  AuthViewController.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 26.11.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import AuthenticationServices
import Toolkit
import UIKit

final class AuthViewController: UIViewController {

    // MARK: Private Properties
    
    private let alertService = Assembly.alertService
    private let credentialsService = Assembly.credentialsService
    private let keyboardService = Assembly.keyboardService
    private let requestSender = Assembly.requestSender

    private var formValidationHelper: FormValidationHelper?
    
    
    // MARK: Outlets
    
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    
    @IBOutlet private weak var loginButton: BigButton!
    @IBOutlet private weak var registrationButton: UIButton!
    
    @IBOutlet private weak var containerView: UIStackView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    @IBOutlet private weak var rememberSwitch: UISwitch!
    
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegates()
        setupNavigationBar()
        setupAppleIDAuthButton()
        setupButtonNavigationHelper()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        keyboardService.register()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        keyboardService.unregister()
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
        present(nvc, animated: true)
    }
    
    @IBAction func restoreDidTap() {
        let vc = PreRestoreViewController()
        let nvc = UINavigationController(rootViewController: vc)
        present(nvc, animated: true)
    }
    
    
    // MARK: Private
    
    private func setupDelegates() {
        keyboardService.view = view
        keyboardService.scrollView = scrollView
        usernameField.delegate = keyboardService
        passwordField.delegate = keyboardService
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Авторизация"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupAppleIDAuthButton() {
        let button = ASAuthorizationAppleIDButton()
        button.addTarget(self, action: #selector(appleButtonDidTap), for: .touchUpInside)
        containerView.addArrangedSubview(button)
    }
    
    private func setupButtonNavigationHelper() {
        let textFields: [UITextField] = [usernameField, passwordField]
        formValidationHelper = FormValidationHelper(textFields: textFields, button: loginButton)
    }
    
    private func login(username: String, password: String) {
        let config = RequestFactory.login(username: username, password: password)
        
        requestSender.send(config: config) { [weak self] result in
            guard let self = self else { return }
            
            self.loginButton.hideLoading()
            
            DispatchQueue.main.async {
                switch result {
                case .success(var login):
                    if login.accessToken != nil, login.refreshToken != nil {
                        let scene = UIApplication.shared.connectedScenes.first
                        if let mySceneDelegate = scene?.delegate as? SceneDelegate {
                            login.message = username
                            
                            if self.rememberSwitch.isOn {
                                self.credentialsService.updateCredentials(with: login)
                            }
                            
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
    
    @objc private func appleButtonDidTap() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}




// MARK: - ASAuthorizationControllerDelegate

extension AuthViewController: ASAuthorizationControllerDelegate {
    
    public func authorizationController(controller: ASAuthorizationController,
                                        didCompleteWithAuthorization authorization: ASAuthorization) {
        guard
            let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let code = appleIDCredential.authorizationCode,
            let codeStr = String(data: code, encoding: .utf8),
            let email = appleIDCredential.email
        else {
            let alert = alertService.alert("Не удалось выполнить авторизацию по Apple ID")
            present(alert, animated: true)
            return
        }
        
        login(username: email, password: codeStr)
    }
    
    public func authorizationController(controller: ASAuthorizationController,
                                        didCompleteWithError error: Error) {
        let alert = alertService.alert(error.localizedDescription)
        present(alert, animated: true)
    }
}




// MARK: - ASAuthorizationControllerPresentationContextProviding

extension AuthViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
