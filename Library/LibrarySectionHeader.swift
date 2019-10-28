//
//  ViewController.swift
//  ClearMind
//
//  Created by summer on 2019/10/28.
//  Copyright © 2019 Summer. All rights reserved.
//
import UIKit
class LibrarySectionHeader: UITableViewHeaderFooterView {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var actionButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont.preferredFont(forTextStyle: .footnote).bold()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        actionButton.allTargets.forEach {
            actionButton.removeTarget($0, action: nil, for: .allEvents)
        }
    }
}
extension LibrarySectionHeader {
    func configure(with type: LibrarySectionType, numberOfItems: Int, actionTarget: Any?, action: Selector?) {
        switch type {
        case .pinned:
            imageView.image = #imageLiteral(resourceName: "pin-filled")
            imageView.tintColor = Style.orange
            titleLabel.text = NSLocalizedString("Pinned", comment: "")
            actionButton.alpha = 0
        case .unpinned:
            imageView.image = #imageLiteral(resourceName: "bulb-filled")
            imageView.tintColor = Style.mainTint
            titleLabel.text = NSLocalizedString("My Thoughts", comment: "")
            actionButton.alpha = 1
            if let action = action {
                actionButton.addTarget(actionTarget, action: action, for: .touchUpInside)
            }
        }
        titleLabel.text = titleLabel.text?.uppercased()
        detailLabel.text = NumberFormatter().string(from: numberOfItems as NSNumber)
        actionButton.backgroundColor = Style.mainTint.withAlphaComponent(0.1)
        actionButton.layer.cornerRadius = 12
    }
}
