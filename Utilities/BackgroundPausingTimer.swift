//
//  ViewController.swift
//  ClearMind
//
//  Created by summer on 2019/10/28.
//  Copyright © 2019 Summer. All rights reserved.
//
import UIKit
class BackgroundPausingTimer {
    var action: (() -> ())
    let interval: TimeInterval
    var tolerance: TimeInterval {
        didSet { timer?.tolerance = tolerance }
    }
    private let center: NotificationCenter
    private var timer: Timer?
    private var lastAction = Date()
    private var isStoppedExplicitly = false
    init(interval: TimeInterval, tolerance: TimeInterval, center: NotificationCenter = .default, action: @escaping () -> ()) {
        self.center = center
        self.interval = interval
        self.tolerance = tolerance
        self.action = action
        subscribeToNotifications()
        start()
    }
    deinit {
        timer?.invalidate()
    }
    func start() {
        isStoppedExplicitly = false
        performStart()
    }
    func stop() {
        isStoppedExplicitly = true
        performStop()
    }
    private func performAction() {
        lastAction = Date()
        action()
    }
    @objc private func performStart() {
        guard !isStoppedExplicitly,
            timer == nil else { return }
        if lastAction.addingTimeInterval(interval) <= Date() {
            performAction()
        }
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.performAction()
        }
        timer?.tolerance = tolerance
    }
    @objc private func performStop() {
        timer?.invalidate()
        timer = nil
    }
    private func subscribeToNotifications() {
        center.addObserver(self, selector: #selector(performStop), name: UIApplication.didEnterBackgroundNotification, object: nil)
        center.addObserver(self, selector: #selector(performStart), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
}
