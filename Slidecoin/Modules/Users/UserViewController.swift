//
//  UserViewController.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 23.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit
import Toolkit

final class UserViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var balanceLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var logoutButton: BigButton!
    @IBOutlet private weak var transferButton: BigButton!
    @IBOutlet private weak var changePasswordButton: BigButton!
    @IBOutlet private weak var addMoneyButton: BigButton!
    
    var completionHandler: (() -> ())?
    
    
    // MARK: Private Properties
    
    private var user: User
    private let currentUser: User
    private var accessToken: String
    private let refreshToken: String
    private let isCurrent: Bool
    
    private let alertService = Assembly.alertService
    private let userDefaultsService = Assembly.userDefaultsService
    private let requestSender = Assembly.requestSender
    
    private var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSeparator = " "
        numberFormatter.groupingSize = 3
        return numberFormatter
    }
    
    
    
    
    // MARK: Lifecycle
    
    init(user: User,
         currentUser: User,
         accessToken: String,
         refreshToken: String,
         isCurrent: Bool) {
        self.user = user
        self.currentUser = currentUser
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.isCurrent = isCurrent
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupUserDescription()
        setupView()
    }
    
    
    // MARK: Actions
    
    @IBAction private func transferMoneyDidTap() {
        let vc = TransferViewController(accessToken: accessToken,
                                        currentUser: currentUser,
                                        receiver: user)
        vc.completionHandler = { [weak self] amount in
            guard let self = self else { return }
            
            self.user.balance += amount
            self.balanceLabel.text = "\(self.user.balance) \(Global.currencySymbol)"
        }
        
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .formSheet
        present(nvc, animated: true)
    }
    
    @IBAction private func changePasswordDidTap() {
        let vc = RestoreViewController(accessToken: accessToken)
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .formSheet
        present(nvc, animated: true)
    }
    
    @IBAction private func logoutDidTap() {
        let message = "Вы действительно хотите выйти?"
        let alert = alertService.alert(message,
                                       title: .attention,
                                       isDestructive: true) { [weak self] _ in
            guard let self = self else { return }
            
            self.requestLogout()
        }
        
        present(alert, animated: true)
    }
    
    
    // MARK: Private
    
    private func setupNavigationBar() {
        navigationItem.title = user.username
        navigationItem.largeTitleDisplayMode = .never
        
        if presentingViewController != nil {
            let closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                              target: self,
                                              action: #selector(close))
            navigationItem.rightBarButtonItem = closeButton
        } else if currentUser.isAdmin && user.id != currentUser.id {
            let deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(deleteUser))
            navigationItem.rightBarButtonItem = deleteButton
        }
        
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
    }
    
    private func setupUserDescription() {
        nameLabel.text = "\(user.name) \(user.surname)"
        emailLabel.text = user.email
        
        guard let balance = numberFormatter.string(from: user.balance as NSNumber) else { return }
        balanceLabel.text = "\(balance) \(Global.currencySymbol)"
    }
    
    private func setupView() {
        if isCurrent {
            transferButton.isHidden = true
            
            let interaction = UIContextMenuInteraction(delegate: self)
            logoutButton.addInteraction(interaction)
        } else {
            changePasswordButton.isHidden = true
            logoutButton.isHidden = true
        }
        
        addMoneyButton.isHidden = !currentUser.isAdmin
    }
    
    private func requestLogout() {
        logoutButton.showLoading()
        
        let accessConfig = RequestFactory.logoutAccess(accessToken: accessToken)
        requestSender.send(config: accessConfig) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                let refreshConfig = RequestFactory.logoutRefresh(refreshToken: self.refreshToken)
                self.requestSender.send(config: refreshConfig) { [weak self] result in
                    guard let self = self else { return }
                    
                    self.logoutButton.hideLoading()
                    
                    switch result {
                    case .success:
                        self.doLogout()
                        
                    case .failure(let error):
                        let alert = self.alertService.alert(error.localizedDescription)
                        self.present(alert, animated: true)
                    }
                }
                
            case .failure(let error):
                switch error {
                case is ResponseError:
                    let refreshConfig = RequestFactory.logoutRefresh(refreshToken: self.refreshToken)
                    self.requestSender.send(config: refreshConfig) { [weak self] result in
                        guard let self = self else { return }
                        
                        self.logoutButton.hideLoading()
                        
                        switch result {
                        case .success:
                            self.doLogout()
                            
                        case .failure(let error):
                            let alert = self.alertService.alert(error.localizedDescription)
                            self.present(alert, animated: true)
                        }
                    }
                    
                default:
                    self.logoutButton.hideLoading()
                    
                    let alert = self.alertService.alert(error.localizedDescription)
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    private func doLogout() {
        self.userDefaultsService.removeCredentials()
        
        let scene = UIApplication.shared.connectedScenes.first
        if let mySceneDelegate = scene?.delegate as? SceneDelegate {
            let vc = AuthViewController()
            let nvc = UINavigationController(rootViewController: vc)
            mySceneDelegate.window?.rootViewController = nvc
        }
    }
    
    @objc private func close() {
        dismiss(animated: true)
    }
    
    @objc private func deleteUser() {
        let message = "Удалить данного пользователя?"
        let alert = alertService.alert(message,
                                       title: .attention,
                                       isDestructive: true) { [weak self] _ in
            guard let self = self else { return }
                                        
            let config = RequestFactory.deleteUser(by: self.user.id, accessToken: self.accessToken)
            self.requestSender.send(config: config) { [weak self] result in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let message):
                        if message.contains("success") {
                            self.navigationController?.popViewController(animated: true)
                            self.completionHandler?()
                        }
                        
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
                                    self.deleteUser()
                                    
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
}




// MARK: - UIContextMenuInteractionDelegate

extension UserViewController: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in
            let forceLogout = UIAction(title: "Выйти принудительно",
                                       image: UIImage(systemName: "power"),
                                       attributes: .destructive) { [weak self] action in
                guard let self = self else { return }
                                    
                self.userDefaultsService.removeCredentials()
                
                let scene = UIApplication.shared.connectedScenes.first
                if let mySceneDelegate = scene?.delegate as? SceneDelegate {
                    let vc = AuthViewController()
                    let nvc = UINavigationController(rootViewController: vc)
                    mySceneDelegate.window?.rootViewController = nvc
                }
            }

            // Creating main context menu
            return UIMenu(title: "", children: [forceLogout])
        }
        return configuration
    }
}
