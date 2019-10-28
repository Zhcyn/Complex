//
//  ViewController.swift
//  ClearMind
//
//  Created by summer on 2019/10/28.
//  Copyright © 2019 Summer. All rights reserved.
//
func dprint(_ items: Any..., separator: String = " ", file: String = #file, function: String = #function, line: Int = #line) {
    let string = items.map(String.init(describing:)).joined(separator: separator)
    print("\(file) : \(function) : \(line):", string)
}
