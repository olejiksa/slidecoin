//
//  TasksViewController.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 31.01.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Toolkit
import UIKit

final class TasksViewController: UIViewController {
    
    private let alertService = Assembly.alertService
    private let userDefaultsService = Assembly.userDefaultsService
    private let requestSender = Assembly.requestSender
    
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var submitButton: BigButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Задания"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    @IBAction private func submitDidTap() {
        guard let text = textField.text else { return }
        
        submitButton.showLoading()
            
        let config = RequestFactory.feedback(body: text)
        requestSender.send(config: config) { [weak self] result in
            guard let self = self else { return }

            self.submitButton.hideLoading()

            DispatchQueue.main.async {
                switch result {
                case .success:
                    let alert = self.alertService.alert("Спасибо! В течение ближайших 2-3 дней мы закинем вам бонус",
                                                        title: .info,
                                                        isDestructive: false ) { _ in
                        self.dismiss(animated: true)
                    }
                    
                    self.present(alert, animated: true)

                case .failure(let error):
                    let alert = self.alertService.alert(error.localizedDescription)
                    self.present(alert, animated: true)
                }
            }
        }
    }
}
