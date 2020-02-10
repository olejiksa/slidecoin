//
//  ProductViewController.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 18.01.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Toolkit
import UIKit

final class ProductViewController: UIViewController {

    // MARK: Private Properties
    
    private let alertService = Assembly.alertService
    private let userDefaultsService = Assembly.userDefaultsService
    private let requestSender = Assembly.requestSender
    
    private let product: Product
    private let alreadyPurchased: Bool
    private let isAdmin: Bool
    
    var completionHandler: (() -> ())?
    
    
    // MARK: Outlets
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var buyButton: BigButton!
    
    
    // MARK: Lifecycle
    
    init(product: Product,
         alreadyPurchased: Bool,
         isAdmin: Bool) {
        self.product = product
        self.alreadyPurchased = alreadyPurchased
        self.isAdmin = isAdmin
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupView()
    }
    
    
    // MARK: Private
    
    private func setupNavigationBar() {
        navigationItem.title = product.name
        navigationItem.largeTitleDisplayMode = .never
        
        if isAdmin {
            let deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash"),
                                               style: .plain,
                                               target: self,
                                               action: #selector(deleteItem))
            
            let editButton = UIBarButtonItem(barButtonSystemItem: .edit,
                                             target: self,
                                             action: #selector(editItem))
            
            navigationItem.rightBarButtonItems = [deleteButton, editButton]
        }
        
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
    }
    
    private func setupView() {
        descriptionLabel.text = product.description
        buyButton.setTitle("\(product.price) \(Global.currencySymbol)", for: .normal)
        buyButton.isHidden = alreadyPurchased
        
        if let count = product.amount {
            countLabel.text = "Куплено штук: \(count)"
        } else {
            countLabel.isHidden = true
        }
    }
    
    @IBAction private func buyDidTap() {
        guard let id = product.id else { return }
        
        buyButton.showLoading()
        
        let config = RequestFactory.buy(by: id)
        requestSender.send(config: config) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    self.buyButton.hideLoading()
                    
                    let alert = self.alertService.alert(message, title: .info, isDestructive: false ) { _ in
                        if message.contains("success") {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    
                    self.present(alert, animated: true)
                    
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
                                self.buyDidTap()
                                
                            case .failure(let error):
                                self.buyButton.hideLoading()
                                let alert = self.alertService.alert(error.localizedDescription)
                                self.present(alert, animated: true)
                            }
                        }
                        
                    default:
                        self.buyButton.hideLoading()
                        let alert = self.alertService.alert(error.localizedDescription)
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
    @objc private func deleteItem() {
        guard let id = product.id else { return }
        
        let message = "Удалить данный товар?"
        let alert = alertService.alert(message,
                                       title: .attention,
                                       isDestructive: true) { [weak self] _ in
            guard let self = self else { return }
                                        
            let config = RequestFactory.deleteItem(by: id)
            self.requestSender.send(config: config) { [weak self] result in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let message):
                        if message.contains("success") {
                            self.navigationController?.popViewController(animated: true)
                            let nvc = UINavigationController(rootViewController: NoUserViewController("товар"))
                            self.showDetailViewController(nvc, sender: self)
                            self.completionHandler?()
                        }
                        
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
                                    self.deleteItem()
                                    
                                case .failure(let error):
                                    let alert = self.alertService.alert(error.localizedDescription)
                                    self.present(alert, animated: true)
                                }
                            }
                            
                        default:
                            let alert = self.alertService.alert(error.localizedDescription)
                            self.present(alert, animated: true)
                        }
                    }
                }
            }
        }
        
        present(alert, animated: true)
    }
    
    @objc private func editItem() {
        let vc = AddItemViewController(isAdd: .edit(product.id!, product.name, product.price, product.description))
//        vc.completionHandler = { [weak self] in
//            // self?.refresh()
//        }
        
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .formSheet
        present(nvc, animated: true)
    }
}
