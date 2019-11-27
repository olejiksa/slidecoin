//
//  KeyboardService.swift
//  Slidecur
//
//  Created by Oleg Samoylov on 27.11.2019.
//  Copyright © 2019 Oleg Samoylov. All rights reserved.
//

import UIKit


protocol KeyboardServiceProtocol: UITextFieldDelegate {
    
    var view: UIView? { get set }
    var scrollView: UIScrollView? { get set }
    
    func keyboardWillBeHidden()
    func keyboardWillShow(notification: Notification)
}


final class KeyboardService: NSObject, KeyboardServiceProtocol {
    
    private var activeField: UITextField?
    
    weak var view: UIView?
    weak var scrollView: UIScrollView?
    
    func keyboardWillBeHidden() {
        guard let scrollView = scrollView else { return }
        
        let contentInsets: UIEdgeInsets = .zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func keyboardWillShow(notification: Notification) {
        guard
            let activeField = activeField,
            let scrollView = scrollView,
            let view = view
        else { return }
        
        let key = UIResponder.keyboardFrameBeginUserInfoKey
        let value = notification.userInfo?[key] as? NSValue
        let kbSize = (value?.cgRectValue.size)!
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        var aRect = view.frame
        aRect.size.height -= kbSize.height
        if !aRect.contains(activeField.frame.origin) {
            scrollView.scrollRectToVisible(activeField.frame, animated: true)
        }
    }
}


// MARK: - UITextFieldDelegate

extension KeyboardService {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        return true
    }
}
