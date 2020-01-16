//
//  StoreViewController.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 27.12.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class StoreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
    }

    private func setupNavigationBar() {
        navigationItem.title = "Магазин"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
