//
//  BigButton.swift
//  Toolkit
//
//  Created by Oleg Samoylov on 27.11.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
public final class BigButton: UIButton {
    
    // MARK: Public Properties
    
    @IBInspectable public var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    override public var backgroundColor: UIColor? {
        get {
            return isEnabled ? Assembly.userDefaultsService.getColor() : .systemFill
        }
        set {
            super.backgroundColor = isEnabled ? Assembly.userDefaultsService.getColor() : .systemFill
        }
    }
    
    override public var isEnabled: Bool {
        didSet {
            if isEnabled {
                UIView.animate(withDuration: 0) {
                    super.backgroundColor = Assembly.userDefaultsService.getColor()
                }
            } else {
                UIView.animate(withDuration: 0) {
                    super.backgroundColor = .systemFill
                }
            }
        }
    }
    
    override public var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.7) {
                    super.backgroundColor = super.backgroundColor?.withAlphaComponent(0.5)
                }
            } else {
                UIView.animate(withDuration: 0.7) {
                    super.backgroundColor = super.backgroundColor?.withAlphaComponent(1.0)
                }
            }
        }
    }
    
    
    // MARK: Private Properties
    
    private var originalButtonText: String?
    private var activityIndicator: UIActivityIndicatorView?
    
    
    // MARK: Public
    
    public func showLoading() {
        originalButtonText = titleLabel?.text
        setTitle("", for: .normal)

        if activityIndicator == nil {
            activityIndicator = createActivityIndicator()
        }

        showSpinning()
    }

    public func hideLoading() {
        setTitle(originalButtonText, for: .normal)
        activityIndicator?.stopAnimating()
    }
    
    
    // MARK: Private
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        return activityIndicator
    }

    private func showSpinning() {
        guard let activityIndicator = activityIndicator else { return }
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }

    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self,
                                                   attribute: .centerX,
                                                   relatedBy: .equal,
                                                   toItem: activityIndicator,
                                                   attribute: .centerX,
                                                   multiplier: 1,
                                                   constant: 0)
        addConstraint(xCenterConstraint)

        let yCenterConstraint = NSLayoutConstraint(item: self,
                                                   attribute: .centerY,
                                                   relatedBy: .equal,
                                                   toItem: activityIndicator,
                                                   attribute: .centerY,
                                                   multiplier: 1,
                                                   constant: 0)
        addConstraint(yCenterConstraint)
    }
}
