//
//  MainViewController.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 27.11.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit
import Toolkit

final class MainViewController: UIViewController {

    // MARK: Private Properties
    
    private let alertService = Assembly.alertService
    private let credentialsService = Assembly.credentialsService
    private let requestSender = Assembly.requestSender
    
    private var login: Login
    
    private var sum: Decimal = 0.0
    
    
    // MARK: Outlets
    
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var sumLabel: UILabel!
    @IBOutlet private weak var secretButton: BigButton!
    @IBOutlet private weak var earnButton: BigButton!
    
    
    // MARK: Lifecycle
    
    init(login: Login) {
        self.login = login
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        messageLabel.text = login.message
        
        if let money = credentialsService.getMoney() {
            sum = money
        }
        
        sumLabel.text = "\(sum) ₿"
    }
    
    
    // MARK: Actions
    
    @IBAction private func secretDidTap() {
        guard
            let accessToken = login.accessToken,
            let refreshToken = login.refreshToken
        else { return }
        
        obtainSecret(accessToken, refreshToken)
    }
    
    @IBAction private func earnDidTap() {
        sum += 0.01
        sumLabel.text = "\(sum) ₿"
        credentialsService.updateMoney(with: sum)
    }
    
    @IBAction private func allUsersDidTap() {
        let vc = UsersViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: Private
    
    private func setupNavigationBar() {
        navigationItem.title = "Главная"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let image = UIImage(systemName: "person.crop.circle")
        let userButton = UIBarButtonItem(image: image,
                                         style: .done,
                                         target: self,
                                         action: #selector(userDidTap))
        navigationItem.rightBarButtonItem = userButton
    }
    
    private func obtainSecret(_ accessToken: String, _ refreshToken: String) {
        secretButton.showLoading()
        
        let accessConfig = RequestFactory.secret(accessToken: accessToken)
        requestSender.send(config: accessConfig) { [weak self] result in
            guard let self = self else { return }
            
            self.secretButton.hideLoading()
            
            switch result {
            case .success(let secret):
                if let answer = secret.answer {
                    let alert = self.alertService.alert(String(answer),
                                                        title: "Secret")
                    self.present(alert, animated: true)
                } else {
                    let refreshConfig = RequestFactory.tokenRefresh(refreshToken)
                    self.requestSender.send(config: refreshConfig) { [weak self] result in
                        guard let self = self else { return }
                        
                        switch result {
                        case .success(let accessToken):
                            self.login.accessToken = accessToken
                            self.credentialsService.updateCredentials(with: self.login)
                            self.obtainSecret(accessToken, refreshToken)
                            
                        case .failure(let error):
                            let alert = self.alertService.alert(error.localizedDescription)
                            self.present(alert, animated: true)
                        }
                    }
                }
                
            case .failure(let error):
                let alert = self.alertService.alert(error.localizedDescription)
                self.present(alert, animated: true)
            }
        }
    }
    
    @objc private func userDidTap() {
        guard
            let accessToken = login.accessToken,
            let refreshToken = login.refreshToken
        else { return }
        
        let vc = UserViewController(username: login.message,
                                    accessToken: accessToken,
                                    refreshToken: refreshToken)
        let nvc = UINavigationController(rootViewController: vc)
        present(nvc, animated: true)
    }
}
