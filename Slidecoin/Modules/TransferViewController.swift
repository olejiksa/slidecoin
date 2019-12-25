//
//  TransferViewController.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 22.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class TransferViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
    }
    
    @IBAction private func submit() {
        close()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Перевод"
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(close))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc private func close() {
        dismiss(animated: true)
    }
}
