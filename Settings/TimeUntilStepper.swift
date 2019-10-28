//
//  ViewController.swift
//  ClearMind
//
//  Created by summer on 2019/10/28.
//  Copyright © 2019 Summer. All rights reserved.
//
import UIKit
class TimeUntilStepper: UIStepper {
    var dateValues = [DateComponents]() {
        didSet {
            guard !dateValues.isEmpty else { fatalError("Nonempty `dateValues` is required.") }
            updateRange()
        }
    }
    var dateValue: DateComponents {
        get {
            guard dateValues.indices ~= index else { fatalError("Nonempty `dateValues` is required. Modifying `value`, `minimumValue`, `maximumValue` directly is not supported.")  }
            return dateValues[index]
        }
        set {
            if let index = dateValues.firstIndex(of: newValue) {
                self.index = index
            } else {
                dateValues.append(newValue)
                self.index = dateValues.indices.last!
            }
        }
    }
    private var index: Int {
        get { Int(value) }
        set { value = Double(newValue) }
    }
    private func updateRange() {
        minimumValue = 0
        maximumValue = Double(max(0, dateValues.count - 1))
        value = 0
    }
}
