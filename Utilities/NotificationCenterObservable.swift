//
//  ViewController.swift
//  ClearMind
//
//  Created by summer on 2019/10/28.
//  Copyright © 2019 Summer. All rights reserved.
//
import Foundation
protocol NotificationCenterObservable {
    var center: NotificationCenter { get }
}
extension NotificationCenterObservable {
    func addObserver(_ observer: Any, selector: Selector, name: Notification.Name) {
        center.addObserver(observer, selector: selector, name: name, object: self)
    }
    func removeObserver(_ observer: Any, name: Notification.Name) {
        center.removeObserver(observer, name: name, object: self)
    }
    func post(_ name: Notification.Name) {
        center.post(name: name, object: self)
    }
}
