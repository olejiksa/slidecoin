//
//  PreRestoreViewController.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 18.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit
import Toolkit

final class PreRestoreViewController: UIViewController {

    // MARK: Private Properties
    
    private let alertService = Assembly.alertService
    private let requestSender = Assembly.requestSender
    private var formValidationHelper: FormValidationHelper?
   
    
    // MARK: Outlets
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var doneButton: BigButton!
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
        navigationItem.title = "Восстановление доступа"
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(close))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    private func setupFormValidationHelper() {
        formValidationHelper = FormValidationHelper(textFields: [usernameField],
                                                    button: doneButton,
                                                    stackView: stackView)
    }

    @IBAction private func continueDidTap() {
//        guard let login = usernameField.text else { return }
        
        doneButton.showLoading()
            
//        let config = RequestFactory.users(accessToken: accessToken)
//        requestSender.send(config: config) { [weak self] result in
//            guard let self = self else { return }
//
//            self.doneButton.hideLoading()
//
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let users):
//                    let usernames = users.map { $0.username }
//                    if usernames.contains(login) {
                        let vc = AccessCodeViewController()
                        self.navigationController?.pushViewController(vc, animated: true)
//                    } else {
//                        let text = "User \(login) doesn't exist"
//                        let alert = self.alertService.alert(text)
//                        self.present(alert, animated: true)
//                    }
//
//                case .failure(let error):
//                    let alert = self.alertService.alert(error.localizedDescription)
//                    self.present(alert, animated: true)
//                }
//            }
//        }
    }
    
    @objc private func close() {
        dismiss(animated: true)
    }
}
