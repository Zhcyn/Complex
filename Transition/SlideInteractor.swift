//
//  ViewController.swift
//  ClearMind
//
//  Created by summer on 2019/10/28.
//  Copyright © 2019 Summer. All rights reserved.
//
import UIKit
class SlideInteractor: UIPercentDrivenInteractiveTransition {
    let thresholdProgress: CGFloat = 0.1
    let thresholdVelocity: CGFloat = 700
    private var didTransition: Bool = false
    func handlePan(for gesture: UIPanGestureRecognizer, transitionType: TransitionType, performTransition: () -> ()) {
        let progress = gesture.progress(forDirection: transitionType)
        let velocity = gesture.progressVelocity(forDirection: transitionType).x
        switch gesture.state {
        case .began where velocity > 0:
            wantsInteractiveStart = true
            didTransition = true
            performTransition()
        case .began:
            wantsInteractiveStart = true
            didTransition = false
        case .changed where velocity > 0 && !didTransition:
            didTransition = true
            gesture.setTranslation(.zero, in: gesture.view)
            performTransition()
        case .changed:
            update(progress)
        case .cancelled:
            wantsInteractiveStart = false
            cancel()
        case .ended where didTransition:
            wantsInteractiveStart = false
            let hasSufficientVelocity = velocity >= thresholdVelocity
            let hasSufficientDistanceAndCorrectDirection = (progress >= thresholdProgress) && (velocity > 0)
            if hasSufficientVelocity || hasSufficientDistanceAndCorrectDirection {
                finish()
            } else {
                cancel()
            }
        default:
            didTransition = false
            wantsInteractiveStart = false
        }
    }
}
private extension UIPanGestureRecognizer {
    func progress(forDirection direction: TransitionType) -> CGFloat {
        guard let view = view else { return .zero }
        let fraction = translation(in: view).x / view.bounds.width
        switch direction {
        case .presentation: return min(max(fraction, 0), 1)
        case .dismissal: return -max(min(fraction, 0), -1)
        }
    }
    func progressVelocity(forDirection direction: TransitionType) -> CGPoint {
        let velocity = self.velocity(in: view)
        switch direction {
        case .presentation: return velocity
        case .dismissal: return CGPoint(x: -velocity.x, y: velocity.y)
        }
    }
}
