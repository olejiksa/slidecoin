//
//  ProductViewController.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 18.01.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class ProductViewController: UIViewController {

    private let alertService = Assembly.alertService
    private let product: Product
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    
    init(product: Product) {
        self.product = product
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = product.name
        navigationItem.largeTitleDisplayMode = .never
        imageView.image = product.image
        
        self.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        self.navigationItem.leftItemsSupplementBackButton = true
    }
    
    @IBAction private func buyDidTap() {
        let alert = alertService.alert("Доступ запрещен")
        present(alert, animated: true)
    }
}
