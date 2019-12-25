//
//  RestoreViewController.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 17.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit
import Toolkit

final class RestoreViewController: UIViewController {

    // MARK: Private Properties

    private let alertService = Assembly.alertService
    private let keyboardService = Assembly.keyboardService
    private var formValidationHelper: FormValidationHelper?
    
    
    // MARK: Outlets
    
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var repeatPasswordField: UITextField!
    @IBOutlet private weak var doneButton: BigButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var stackView: UIStackView!
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegates()
        setupNavigationBar()
        setupFormValidationHelper()
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
        passwordField.delegate = keyboardService
        repeatPasswordField.delegate = keyboardService
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Сброс пароля"
        
        if presentingViewController != nil {
            let closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                              target: self,
                                              action: #selector(close))
            navigationItem.rightBarButtonItem = closeButton
        }
    }
    
    private func setupFormValidationHelper() {
        let textFields: [UITextField] = [passwordField, repeatPasswordField]
        formValidationHelper = FormValidationHelper(textFields: textFields,
                                                    button: doneButton,
                                                    stackView: stackView)
    }
    
    @IBAction private func changePasswordDidTap() {
        close()
    }
    
    @objc private func close() {
        dismiss(animated: true)
    }
}
