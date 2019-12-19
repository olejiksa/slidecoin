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
    
    private let alertService: AlertServiceProtocol = AlertService()
    private let keyboardService: KeyboardServiceProtocol = KeyboardService()
    private let requestSender: RequestSenderProtocol = RequestSender()
    private var buttonValidationHelper: ButtonValidationHelper?
   
    
    // MARK: Outlets
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var doneButton: BigButton!
    
    
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
    
    
    // MARK: Private
    
    private func setupDelegates() {
        keyboardService.view = view
        keyboardService.scrollView = scrollView
        usernameField.delegate = keyboardService
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Восстановление"
    }
    
    private func setupButtonValidationHelper() {
        buttonValidationHelper = ButtonValidationHelper(textFields: [usernameField], button: doneButton)
    }

    @IBAction private func continueDidTap() {
        guard let login = usernameField.text else { return }
            
        let config = RequestFactory.users()
        requestSender.send(config: config) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    let usernames = users.map { $0.username }
                    if usernames.contains(login) {
                        let vc = RestoreViewController()
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let text = "Не удалось найти учетную запись с именем пользователя \(login)"
                        let alert = self.alertService.alert(text)
                        self.present(alert, animated: true)
                    }
                    
                case .failure(let error):
                    let alert = self.alertService.alert(error.localizedDescription)
                    self.present(alert, animated: true)
                }
            }
        }
    }
}
