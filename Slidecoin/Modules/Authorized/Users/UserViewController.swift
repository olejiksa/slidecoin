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
    @IBOutlet private weak var changePictureButton: BigButton!
    @IBOutlet private weak var changePasswordButton: BigButton!
    
    
    // MARK: Private Properties
    
    private let user: User
    private let accessToken: String
    private let refreshToken: String
    private let isCurrent: Bool
    
    private var imagePicker: ImagePicker?
    private let alertService = Assembly.alertService
    private let credentialsService = Assembly.credentialsService
    private let requestSender = Assembly.requestSender
    
    
    
    // MARK: Lifecycle
    
    init(user: User,
         accessToken: String,
         refreshToken: String,
         isCurrent: Bool) {
        self.user = user
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
        setupUserTile()
        setupView()
    }
    
    
    // MARK: Actions
    
    @IBAction private func transferMoneyDidTap() {
        let vc = TransferViewController(receiver: user)
        let nvc = UINavigationController(rootViewController: vc)
        present(nvc, animated: true)
    }
    
    @IBAction private func changeUserTileDidTap(_ sender: UIButton) {
        imagePicker?.present(from: sender)
    }
    
    @IBAction private func changePasswordDidTap() {
        let vc = RestoreViewController(accessToken: accessToken)
        let nvc = UINavigationController(rootViewController: vc)
        present(nvc, animated: true)
    }
    
    @IBAction private func logoutDidTap() {
        let message = "Вы действительно хотите выйти?"
        let alert = alertService.alert(message, title: "Внимание", isDestructive: true) { [weak self] _ in
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
        }
    }
    
    private func setupUserDescription() {
        nameLabel.text = "\(user.name) \(user.surname)"
        emailLabel.text = user.email
        balanceLabel.text = String(user.balance)
    }
    
    private func setupUserTile() {
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        imageView.layer.borderColor = UIColor.systemBlue.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
    }
    
    private func setupView() {
        if isCurrent {
            transferButton.isHidden = true
        } else {
            changePictureButton.isHidden = true
            changePasswordButton.isHidden = true
            logoutButton.isHidden = true
        }
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
                        self.credentialsService.removeCredentials()
                        
                        let scene = UIApplication.shared.connectedScenes.first
                        if let mySceneDelegate = scene?.delegate as? SceneDelegate {
                            let vc = AuthViewController()
                            let nvc = UINavigationController(rootViewController: vc)
                            mySceneDelegate.window?.rootViewController = nvc
                        }
                        
                    case .failure(let error):
                        let alert = self.alertService.alert(error.localizedDescription)
                        self.present(alert, animated: true)
                    }
                }
                
            case .failure(let error):
                self.logoutButton.hideLoading()
                
                let alert = self.alertService.alert(error.localizedDescription)
                self.present(alert, animated: true)
            }
        }
    }
    
    @objc private func close() {
        dismiss(animated: true)
    }
}


// MARK: - ImagePickerDelegate

extension UserViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        guard let image = image else { return }
        imageView.image = image
    }
}
