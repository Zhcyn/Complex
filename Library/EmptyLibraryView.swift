//
//  ViewController.swift
//  ClearMind
//
//  Created by summer on 2019/10/28.
//  Copyright © 2019 Summer. All rights reserved.
//
import UIKit
class EmptyLibraryView: UIView {
    @IBOutlet var button: UIButton!
    private lazy var formatter = ThoughtSuggestionFormatter()
    override func awakeFromNib() {
        super.awakeFromNib()
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.titleLabel?.allowsDefaultTighteningForTruncation = true
        button.setTitleColor(Style.mainTint, for: .normal)
        button.tintColor = Style.mainTint
        button.layer.borderColor = Style.mainTint.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 12
        configure(with: nil, isEmpty: true)
    }
    func configure(with suggestion: String?, isEmpty: Bool) {
        self.isHidden = !isEmpty
        UIView.performWithoutAnimation {
            button.setTitle(formatter.localizedString(from: suggestion), for: .normal)
            button.layoutIfNeeded()
        }
    }
}
