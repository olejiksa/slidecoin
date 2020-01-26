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

    private let alertService = Assembly.alertService
    private let userDefaultsService = Assembly.userDefaultsService
    private let requestSender = Assembly.requestSender
    
    private let product: Product
    private let refreshToken: String
    private var accessToken: String
    private let alreadyPurchased: Bool
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var buyButton: BigButton!
    
    init(product: Product,
         refreshToken: String,
         accessToken: String,
         alreadyPurchased: Bool) {
        self.product = product
        self.refreshToken = refreshToken
        self.accessToken = accessToken
        self.alreadyPurchased = alreadyPurchased
        
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
    
    private func setupNavigationBar() {
        navigationItem.title = product.name
        navigationItem.largeTitleDisplayMode = .never
        
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
        buyButton.showLoading()
        
        let config = RequestFactory.buy(id: product.id, accessToken: accessToken)
        requestSender.send(config: config) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    self.buyButton.hideLoading()
                    
                    let alert = self.alertService.alert(message, title: .info, isDestructive: false ) { _ in
                        if message.contains("success") {
                            self.dismiss(animated: true)
                        }
                    }
                    
                    self.present(alert, animated: true)
                    
                case .failure(let error):
                    switch error {
                    case is ResponseError:
                        let refreshConfig = RequestFactory.tokenRefresh(refreshToken: self.refreshToken)
                        self.requestSender.send(config: refreshConfig) { [weak self] result in
                            guard let self = self else { return }
                            
                            switch result {
                            case .success(let accessToken):
                                self.accessToken = accessToken
                                let login = Login(refreshToken: self.refreshToken, accessToken: self.accessToken, message: "")
                                self.userDefaultsService.updateLogin(with: login)
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
}
