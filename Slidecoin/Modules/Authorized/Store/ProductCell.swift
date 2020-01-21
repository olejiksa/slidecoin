//
//  ProductCell.swift
//  Slidecoin
//
//  Created by Oleg Samoylov on 18.01.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class ProductCell: UICollectionViewCell {
    
    @IBOutlet private weak var surroundingView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                surroundingView.backgroundColor = .systemFill
            } else {
                surroundingView.backgroundColor = .systemBackground
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                surroundingView.backgroundColor = .systemFill
            } else {
                surroundingView.backgroundColor = .systemBackground
            }
        }
    }
}
