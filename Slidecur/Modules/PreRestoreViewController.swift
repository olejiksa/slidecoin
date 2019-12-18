//
//  PreRestoreViewController.swift
//  Slidecur
//
//  Created by Oleg Samoylov on 18.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit
import Toolkit

final class PreRestoreViewController: UIViewController {

    private let requestSender: RequestSenderProtocol = RequestSender()
    private var buttonValidationHelper: ButtonValidationHelper?
   
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var doneButton: BigButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Восстановление"
        
        buttonValidationHelper = ButtonValidationHelper(textFields: [usernameField!], button: doneButton)
    }

    @IBAction private func continueDidTap() {
        guard let login = usernameField.text else { return }
            
        let config = RequestFactory.users()
        requestSender.send(config: config) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    let usernames = users.map { $0.username }
                    if usernames.contains(login) {
                        let vc = RestoreViewController()
                        self?.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        self?.alert("Не удалось найти учетную запись с именем пользователя \(login)")
                    }
                    
                case .failure(let error):
                    self?.alert(error.localizedDescription)
                }
            }
        }
    }
    
    private func alert(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
