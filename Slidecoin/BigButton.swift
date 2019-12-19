//
//  BigButton.swift
//  Slidecur
//
//  Created by Oleg Samoylov on 27.11.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

final class BigButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue }
        get { return layer.cornerRadius  }
    }
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                UIView.animate(withDuration: 0.7) {
                    self.backgroundColor = .systemBlue
                }
            } else {
                UIView.animate(withDuration: 0.7) {
                    self.backgroundColor = .lightGray
                }
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.7) {
                    self.backgroundColor = self.backgroundColor?.withAlphaComponent(0.5)
                }
            }
            else {
                UIView.animate(withDuration: 0.7) {
                    self.backgroundColor = self.backgroundColor?.withAlphaComponent(1.0)
                }
            }
        }
    }
}
