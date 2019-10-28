//
//  ViewController.swift
//  ClearMind
//
//  Created by summer on 2019/10/28.
//  Copyright © 2019 Summer. All rights reserved.
//
import UIKit
class SlideAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private let type: TransitionType
    private let duration: TimeInterval = 0.25
    private var animator: UIViewPropertyAnimator?
    init(type: TransitionType) {
        self.type = type
        super.init()
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    func animateTransition(using context: UIViewControllerContextTransitioning) {
        animator(using: context).startAnimation()
    }
    func interruptibleAnimator(using context: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        animator(using: context)
    }
    private func animator(using context: UIViewControllerContextTransitioning) -> UIViewPropertyAnimator {
        if let animator = animator { return animator }
        guard let presentedView = context.presentedView(for: type),
            let presentedViewController = context.presentedViewController(for: type) else { fatalError("No presented view or controller in context.") }
        let duration = transitionDuration(using: context)
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut)
        let finalFrame: CGRect
        if type == .presentation {
            finalFrame = context.finalFrame(for: presentedViewController)
            let initialFrame = finalFrame.offsetBy(dx: -finalFrame.width, dy: 0)
            presentedView.frame = initialFrame
            context.containerView.addSubview(presentedView)
        } else {
            finalFrame = presentedView.frame.offsetBy(dx: -presentedView.frame.width, dy: 0)
        }
        animator.addAnimations {
            presentedView.frame = finalFrame
        }
        self.animator = animator
        animator.addCompletion { _ in
            context.completeTransition(!context.transitionWasCancelled)
            self.animator = nil
        }
        return animator
    }
}
private extension UIViewControllerContextTransitioning {
    func presentedView(for type: TransitionType) -> UIView? {
        (type == .presentation) ? view(forKey: .to) : view(forKey: .from)
    }
    func presentedViewController(for type: TransitionType) -> UIViewController? {
        (type == .presentation) ? viewController(forKey: .to) : viewController(forKey: .from)
    }
}
