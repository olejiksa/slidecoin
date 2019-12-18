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

    private let alertService: AlertServiceProtocol = AlertService()
    private let requestSender: RequestSenderProtocol = RequestSender()
    private var buttonValidationHelper: ButtonValidationHelper?
   
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var doneButton: BigButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Восстановление"
        
        buttonValidationHelper = ButtonValidationHelper(textFields: [usernameField], button: doneButton)
    }

    @IBAction private func continueDidTap() {
        guard let login = usernameField.text else { return }
            
        let config = RequestFactory.users()
        requestSender.send(config: config) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    let usernames = users.map { $0.username }
                    if usernames.contains(login) {
                        let vc = RestoreViewController()
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let alert = self.alertService.alert("Не удалось найти учетную запись с именем пользователя \(login)")
                        self.present(alert, animated: true)
                    }
                    
                case .failure(let error):
                    let alert = self.alertService.alert(error.localizedDescription)
                    self.present(alert, animated: true)
                }
            }
        }
    }
}
