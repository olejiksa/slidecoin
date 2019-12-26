//
//  TransferViewController.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 22.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import Toolkit
import UIKit

final class TransferViewController: UIViewController {
    
    private var formValidationHelper: FormValidationHelper?
    
    @IBOutlet private weak var amountField: UITextField!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var submitButton: BigButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupFormValidationHelper()
    }
    
    @IBAction private func submit() {
        submitButton.showLoading()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.submitButton.hideLoading()
            self.close()
        }
    }
    
    private func setupFormValidationHelper() {
        let textFields: [UITextField] = [amountField]
        formValidationHelper = FormValidationHelper(textFields: textFields,
                                                    button: submitButton,
                                                    stackView: stackView)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Перевод"
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(close))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func close() {
        dismiss(animated: true)
    }
}
