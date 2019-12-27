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
        
        setupKeyboard()
        setupNavigationBar()
        setupFormValidationHelper()
    }
    
    
    // MARK: Private
    
    private func setupKeyboard() {
        scrollView.bottomAnchor.constraint(lessThanOrEqualTo: keyboardLayoutGuide.topAnchor).isActive = true
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
        doneButton.showLoading()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.doneButton.hideLoading()
            
            self.dismiss(animated: true)
        }
    }
    
    @objc private func close() {
        self.dismiss(animated: true)
    }
}
