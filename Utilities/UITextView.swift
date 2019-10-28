//
//  ViewController.swift
//  ClearMind
//
//  Created by summer on 2019/10/28.
//  Copyright © 2019 Summer. All rights reserved.
//
import UIKit
extension UITextView {
    func scrollToBottom(animated: Bool) {
        let bottom = caretRect(for: endOfDocument)
        scrollRectToVisible(bottom, animated: animated)
    }
    func startEditing(animated: Bool) {
        becomeFirstResponder()
        scrollToBottom(animated: animated)
    }
}
