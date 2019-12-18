//
//  AuthViewController.swift
//  Slidecur
//
//  Created by Oleg Samoylov on 26.11.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import AuthenticationServices
import Toolkit
import UIKit

final class AuthViewController: UIViewController {

    // MARK: Private Properties
    
    private let requestSender: RequestSenderProtocol = RequestSender()
    private let alertService: AlertServiceProtocol = AlertService()
    private let keyboardService: KeyboardServiceProtocol = KeyboardService()
    private let credentialsService: CredentialsServiceProtocol = CredentialsService()
    private var buttonValidationHelper: ButtonValidationHelper?
    
    
    // MARK: Outlets
    
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registrationButton: UIButton!
    
    @IBOutlet private weak var containerView: UIStackView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        keyboardService.view = view
        keyboardService.scrollView = scrollView
        usernameField.delegate = keyboardService
        passwordField.delegate = keyboardService
        
        navigationItem.title = "Авторизация"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let button = ASAuthorizationAppleIDButton()
        button.addTarget(self, action: #selector(appleButtonDidTap), for: .touchUpInside)
        containerView.addArrangedSubview(button)
        
        let textFields: [UITextField] = [usernameField, passwordField]
        buttonValidationHelper = ButtonValidationHelper(textFields: textFields, button: loginButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(KeyboardService.self,
                                               selector: Selector(("keyboardWillBeHidden")),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: keyboardService)
        NotificationCenter.default.addObserver(KeyboardService.self,
                                               selector: Selector(("keyboardWillShow")),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: keyboardService)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(KeyboardService.self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: keyboardService)
        NotificationCenter.default.removeObserver(KeyboardService.self,
                                                  name: UIResponder.keyboardWillChangeFrameNotification,
                                                  object: keyboardService)
    }
    
    
    // MARK: Actions
    
    @IBAction private func loginDidTap() {
        guard
            let login = usernameField.text,
            let password = passwordField.text
        else { return }
            
        let config = RequestFactory.login(username: login, password: password)
        
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
    
    @IBAction private func registrationDidTap() {
        let vc = RegistrationViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func restoreDidTap() {
        let vc = PreRestoreViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: Private
    
    @objc private func appleButtonDidTap() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
}


// MARK: - ASAuthorizationControllerDelegate

extension AuthViewController: ASAuthorizationControllerDelegate {
    
    // unused
}
