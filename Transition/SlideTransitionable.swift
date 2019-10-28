//
//  ViewController.swift
//  ClearMind
//
//  Created by summer on 2019/10/28.
//  Copyright © 2019 Summer. All rights reserved.
//
protocol SlideTransitionable {
    func presentationTransitionWillBegin()
    func presentationTransitionDidEnd(completed: Bool)
    func dismissalTransitionWillBegin()
    func dismissalTransitionDidEnd(completed: Bool)
}
extension SlideTransitionable {
    func presentationTransitionWillBegin() {}
    func presentationTransitionDidEnd(completed: Bool) {}
    func dismissalTransitionWillBegin() {}
    func dismissalTransitionDidEnd(completed: Bool) {}
}
