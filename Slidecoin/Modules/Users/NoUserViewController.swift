//
//  NoUserViewController.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 23.01.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class NoUserViewController: UIViewController {
    
    @IBOutlet private weak var infoLabel: UILabel!
    
    private let message: String
    
    override func viewDidLoad() {
        super.viewDidLoad()

        infoLabel.text = "Чтобы посмотреть информацию о \(message)е, нажмите на него в левой части экрана"
    }

    init(_ message: String) {
        self.message = message
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
