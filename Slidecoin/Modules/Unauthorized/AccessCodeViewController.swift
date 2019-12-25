//
//  AccessCodeViewController.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 22.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Toolkit
import UIKit

final class AccessCodeViewController: UIViewController {
    
    // MARK: Private Properties
    
    private let alertService = Assembly.alertService
    private let keyboardService = Assembly.keyboardService
    private let requestSender = Assembly.requestSender
    private var formValidationHelper: FormValidationHelper?
    
    
    // MARK: Outlets
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var doneButton: BigButton!
    @IBOutlet private weak var accessCodeField: UITextField!
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
        accessCodeField.delegate = keyboardService
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Код доступа"
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(close))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    private func setupFormValidationHelper() {
        formValidationHelper = FormValidationHelper(textFields: [accessCodeField],
                                                    button: doneButton,
                                                    stackView: stackView)
    }
    
    @IBAction private func continueDidTap() {
        doneButton.showLoading()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.doneButton.hideLoading()
            
            let vc = RestoreViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func close() {
        self.dismiss(animated: true)
    }
}
