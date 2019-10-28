//
//  ViewController.swift
//  ClearMind
//
//  Created by summer on 2019/10/28.
//  Copyright © 2019 Summer. All rights reserved.
//
import UIKit
extension UIResponder {
    func becomeFirstResponder(_ become: Bool) {
        if become {
            becomeFirstResponder()
        } else {
            resignFirstResponder()
        }
    }
}
