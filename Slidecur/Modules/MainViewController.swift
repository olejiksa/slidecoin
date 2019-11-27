//
//  MainViewController.swift
//  Slidecur
//
//  Created by Oleg Samoylov on 27.11.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {

    private let login: Login
    
    @IBOutlet private weak var messageLabel: UILabel!
    
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
        messageLabel.text = login.message
        let defaults = UserDefaults.standard
        defaults.set(login.message, forKey: "message")
        defaults.set(login.accessToken!, forKey: "access_token")
        defaults.set(login.refreshToken!, forKey: "refresh_token")
    }
    
    @IBAction func logoutDidTap() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "message")
        defaults.removeObject(forKey: "access_token")
        defaults.removeObject(forKey: "refresh_token")
        
        navigationController?.popViewController(animated: true)
    }
}
