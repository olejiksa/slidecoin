//
//  RestoreViewController.swift
//  Slidecur
//
//  Created by Oleg Samoylov on 17.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit
import Toolkit

final class RestoreViewController: UIViewController {

    // MARK: Private Properties

    private let alertService: AlertServiceProtocol = AlertService()
    private let keyboardService: KeyboardServiceProtocol = KeyboardService()
    private var buttonValidationHelper: ButtonValidationHelper?
    
    
    // MARK: Outlets
    
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var repeatPasswordField: UITextField!
    @IBOutlet private weak var doneButton: BigButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboardService.view = view
        keyboardService.scrollView = scrollView
        passwordField.delegate = keyboardService
        repeatPasswordField.delegate = keyboardService
        
        navigationItem.title = "Сброс пароля"
        
        let textFields: [UITextField] = [passwordField, repeatPasswordField]
        buttonValidationHelper = ButtonValidationHelper(textFields: textFields, button: doneButton)
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
    
    
    // MARK: Private
    
    @IBAction private func changePasswordDidTap() {
        guard
            let password = passwordField.text,
            let repeatPassword = repeatPasswordField.text
        else { return }
        
        guard password == repeatPassword else {
            let alert = alertService.alert("Введенные пароли не совпадают")
            present(alert, animated: true)
            return
        }
        
        // TODO: network request
        let alert = alertService.alert("Not yet implemented")
        present(alert, animated: true)
    }
}
