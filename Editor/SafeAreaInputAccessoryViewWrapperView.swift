//
//  ViewController.swift
//  ClearMind
//
//  Created by summer on 2019/10/28.
//  Copyright © 2019 Summer. All rights reserved.
//
import UIKit
public class SafeAreaInputAccessoryViewWrapperView: UIView {
    public init(for view: UIView) {
        super.init(frame: .zero)
        addSubview(view)
        autoresizingMask = .flexibleHeight
        view.translatesAutoresizingMaskIntoConstraints = false
        defer {
            view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        }
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override var intrinsicContentSize: CGSize {
        .zero
    }
}
