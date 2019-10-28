//
//  ViewController.swift
//  ClearMind
//
//  Created by summer on 2019/10/28.
//  Copyright © 2019 Summer. All rights reserved.
//
import UIKit
class TransitionController {
    private lazy var libraryTransitionController = SlideTransitionController()
    var libraryInteractionController: SlideInteractor {
        libraryTransitionController.interactionController
    }
    func prepareForSettingsTransition(for presented: UIViewController) {
        if #available(iOS 13.0, *) { }
        else {
            presented.modalPresentationStyle = .custom
        }
    }
    func prepareForLibraryTransition(for presented: UIViewController) {
        libraryTransitionController.prepareTransition(for: presented)
    }
}
