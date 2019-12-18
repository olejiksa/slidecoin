//
//  MainViewController.swift
//  Slidecur
//
//  Created by Oleg Samoylov on 27.11.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit
import Toolkit

final class MainViewController: UIViewController {

    // MARK: Private Properties
    
    private let credentialsService: CredentialsServiceProtocol = CredentialsService()
    private let login: Login
    
    
    // MARK: Outlets
    
    @IBOutlet private weak var messageLabel: UILabel!
    
    
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

        navigationItem.title = "Главная"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        messageLabel.text = login.message
        credentialsService.updateCredentials(with: login)
    }
    
    
    // MARK: Private
    
    @IBAction private func logoutDidTap() {
        credentialsService.removeCredentials()
        
        let scene = UIApplication.shared.connectedScenes.first
        if let mySceneDelegate = scene?.delegate as? SceneDelegate {
            let vc = AuthViewController()
            let nvc = UINavigationController(rootViewController: vc)
            mySceneDelegate.window?.rootViewController = nvc
        }
    }
    
    @IBAction private func changePasswordDidTap() {
        let vc = RestoreViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction private func allUsersDidTap() {
        let vc = UsersViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
