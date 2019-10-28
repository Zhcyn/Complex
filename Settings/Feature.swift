//
//  ViewController.swift
//  ClearMind
//
//  Created by summer on 2019/10/28.
//  Copyright © 2019 Summer. All rights reserved.
//
struct Feature<T> {
    var isEnabled: Bool = true
    var value: T
}
extension Feature: Equatable, Hashable, Codable where T: Hashable, T: Codable { }
