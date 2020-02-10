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

    enum Mode {
        
        case add
        case edit(Int, String, Int, String)
    }
    
    private let alertService = Assembly.alertService
    private let userDefaultsService = Assembly.userDefaultsService
    private let requestSender = Assembly.requestSender
    private var formValidationHelper: FormValidationHelper?
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var submitButton: BigButton!
    
    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var priceField: UITextField!
    @IBOutlet private weak var descriptionField: UITextField!
    
    private let isAdd: Mode
    
    var completionHandler: (() -> ())?
    
    init(isAdd: Mode) {
        self.isAdd = isAdd
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupFormValidationHelper()
    }
    
    private func setupNavigationBar() {
        switch isAdd {
        case .add:
            navigationItem.title = "Добавление товара"
        case .edit(_, let title, let price, let description):
            navigationItem.title = "Изменение товара"
            nameField.text = title
            priceField.text = String(price)
            descriptionField.text = description
        }
        
        if presentingViewController != nil {
            let closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                              target: self,
                                              action: #selector(close))
            navigationItem.rightBarButtonItem = closeButton
        }
    }
    
    private func setupFormValidationHelper() {
        let textFields: [UITextField] = [nameField, priceField]
        formValidationHelper = FormValidationHelper(textFields: textFields,
                                                    button: submitButton,
                                                    stackView: stackView)
    }
    
    @IBAction private func didTapSubmit() {
        guard
            let name = nameField.text,
            let priceString = priceField.text,
            let price = Int(priceString), price >= 0,
            let description = descriptionField.text
        else { return }
        
        submitButton.showLoading()
        
        let config: RequestConfig<MessageParser>
        
        switch isAdd {
        case .add:
            config = RequestFactory.addItem(name: name, price: price, description: description)
        case .edit(let id, _, _, _):
            config = RequestFactory.updateItem(by: id, name: name, price: price, description: description)
        }
        
        requestSender.send(config: config) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.submitButton.hideLoading()
                    
                    self.dismiss(animated: true)
                    self.completionHandler?()
                    
                case .failure(let error):
                    switch error {
                    case is ResponseError:
                        let refreshConfig = RequestFactory.tokenRefresh()
                        self.requestSender.send(config: refreshConfig) { [weak self] result in
                            guard let self = self else { return }
                            
                            switch result {
                            case .success(let accessToken):
                                Global.accessToken = accessToken
                                self.userDefaultsService.updateToken(access: accessToken)
                                self.didTapSubmit()
                                
                            case .failure(let error):
                                self.submitButton.hideLoading()
                                let alert = self.alertService.alert(error.localizedDescription)
                                self.present(alert, animated: true)
                            }
                        }
                        
                    default:
                        self.submitButton.hideLoading()
                        let alert = self.alertService.alert(error.localizedDescription)
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
    @objc private func close() {
        dismiss(animated: true)
    }
}
