//
//  AddItemViewController.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 26.01.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Toolkit
import UIKit

final class AddItemViewController: UIViewController {

    private var formValidationHelper: FormValidationHelper?
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var submitButton: BigButton!
    
    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var priceField: UITextField!
    @IBOutlet private weak var descriptionField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupFormValidationHelper()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Добавление товара"
        
        if presentingViewController != nil {
            let closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                              target: self,
                                              action: #selector(close))
            navigationItem.rightBarButtonItem = closeButton
        }
    }
    
    private func setupFormValidationHelper() {
        let textFields: [UITextField] = [nameField, priceField, descriptionField]
        formValidationHelper = FormValidationHelper(textFields: textFields,
                                                    button: submitButton,
                                                    stackView: stackView)
    }
    
    @objc private func close() {
        dismiss(animated: true)
    }
}
