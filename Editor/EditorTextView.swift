//
//  ViewController.swift
//  ClearMind
//
//  Created by summer on 2019/10/28.
//  Copyright © 2019 Summer. All rights reserved.
//
import UIKit
class EditorTextView: UITextView {
    private let textInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    private let baseFont = UIFont.systemFont(ofSize: 16)
    private let lineHeightMultiple: CGFloat = 1.2
    private let notificationCenter: NotificationCenter = .default
    override func awakeFromNib() {
        super.awakeFromNib()
        subscribeToNotifications()
        textContainerInset = textInsets
        let font = UIFontMetrics(forTextStyle: .body).scaledFont(for: baseFont)
        adjustsFontForContentSizeCategory = true
        let style = NSMutableParagraphStyle()
        let (multiple, spacing) = font.adjustedLineHeightMultipleAndSpacing(forPreferredMultiple: lineHeightMultiple)
        style.lineHeightMultiple = multiple
        style.lineSpacing = spacing
        typingAttributes = [
            .font: font,
            .paragraphStyle: style
        ]
    }
}
private extension EditorTextView {
    func subscribeToNotifications() {
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey],
            let keyboardHeight = (keyboardFrame as? NSValue)?.cgRectValue.size.height else { return }
        contentInset.bottom = keyboardHeight
        if #available(iOS 11.1, *) {
            verticalScrollIndicatorInsets.bottom = keyboardHeight
        } else {
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        contentInset = .zero
        scrollIndicatorInsets = .zero
    }
}
