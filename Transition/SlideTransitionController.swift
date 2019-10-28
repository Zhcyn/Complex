//
//  ViewController.swift
//  ClearMind
//
//  Created by summer on 2019/10/28.
//  Copyright © 2019 Summer. All rights reserved.
//
import UIKit
enum TransitionType {
    case presentation
    case dismissal
}
class SlideTransitionController: NSObject, UIViewControllerTransitioningDelegate {
    private(set) lazy var interactionController: SlideInteractor = {
        let interactor = SlideInteractor()
        interactor.wantsInteractiveStart = false
        return interactor
    }()
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        SlidePresentationController(presentedViewController: presented, presenting: presenting, source: source, interactor: interactionController)
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        SlideAnimator(type: .presentation)
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        SlideAnimator(type: .dismissal)
    }
    func interactionControllerForPresentation(using _animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        interactionController.wantsInteractiveStart ? interactionController : nil
    }
    func interactionControllerForDismissal(using _animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        interactionController.wantsInteractiveStart ? interactionController : nil
    }
}
extension SlideTransitionController {
    func prepareTransition(for presented: UIViewController) {
        presented.transitioningDelegate = self
        presented.modalPresentationStyle = .custom
        presented.modalPresentationCapturesStatusBarAppearance = true
    }
}
