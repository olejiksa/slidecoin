//
//  AboutViewController.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 26.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import MessageUI
import SafariServices
import StoreKit
import UIKit

final class AboutViewController: UIViewController {

    private let alertService = Assembly.alertService
    
    @IBOutlet private weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupContent()
    }
    
    @IBAction private func rateMe() {
        SKStoreReviewController.requestReview()
    }
    
    @IBAction private func goWeb() {
        guard let url = URL(string: RequestFactory.endpointWeb) else { return }
        let svc = SFSafariViewController(url: url)
        svc.modalPresentationStyle = .currentContext
        present(svc, animated: true, completion: nil)
    }
    
    @IBAction private func email() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["slidecurrence@gmail.com"])
            mail.setSubject("Обращение")
            
            present(mail, animated: true)
        } else {
            let alert = alertService.alert("Не удалось отправить сообщение электронной почты. Пожалуйста, убедитесь, что на вашем устройстве установлено стандартное приложение для работы с почтой, и повторите попытку.")
            present(alert, animated: true)
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "О программе"
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(close))
        
        navigationItem.rightBarButtonItem = closeButton
    }
    
    private func setupContent() {
        guard let version = Bundle.main.releaseVersionNumber else { return }
        
        versionLabel.text = "Версия \(version)"
    }
    
    @objc private func close() {
        dismiss(animated: true)
    }
}


// MARK: - MFMailComposeViewControllerDelegate

extension AboutViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        controller.dismiss(animated: true)
    }
}


private extension Bundle {
    
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
