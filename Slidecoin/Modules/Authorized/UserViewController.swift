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
    
    @IBOutlet private weak var imageView: UIImageView!
    
    
    // MARK: Private Properties
    
    private let username: String
    private var imagePicker: ImagePicker?
    private let alertService = Assembly.alertService
    private let credentialsService = Assembly.credentialsService
    
    
    
    // MARK: Lifecycle
    
    init(username: String) {
        self.username = username
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupUserTile()
    }
    
    
    // MARK: Actions
    
    @IBAction private func changeUserTileDidTap(_ sender: UIButton) {
        imagePicker?.present(from: sender)
    }
    
    @IBAction private func changePasswordDidTap() {
        let vc = RestoreViewController()
        let nvc = UINavigationController(rootViewController: vc)
        present(nvc, animated: true)
    }
    
    @IBAction private func logoutDidTap() {
        let message = "Вы действительно хотите выйти?"
        let alert = alertService.alert(message,
                                       title: "Внимание",
                                       isDestructive: true) { [weak self] _ in
            guard let self = self else { return }
                                        
            self.credentialsService.removeCredentials()
            
            let scene = UIApplication.shared.connectedScenes.first
            if let mySceneDelegate = scene?.delegate as? SceneDelegate {
                let vc = AuthViewController()
                let nvc = UINavigationController(rootViewController: vc)
                mySceneDelegate.window?.rootViewController = nvc
            }
        }
        
        present(alert, animated: true)
    }
    
    
    // MARK: Private
    
    private func setupNavigationBar() {
        navigationItem.title = username
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(close))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    private func setupUserTile() {
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
    }
    
    @objc private func close() {
        dismiss(animated: true)
    }
}


// MARK: - ImagePickerDelegate

extension UserViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        imageView.image = image
    }
}
