//
//  ViewController.swift
//  ClearMind
//
//  Created by summer on 2019/10/28.
//  Copyright © 2019 Summer. All rights reserved.
//
import UIKit
extension UIFont {
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(traits) else { return self }
        return UIFont(descriptor: descriptor, size: 0)
    }
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}
extension UIFont {
    func lineSpacing(matchingLineHeightMultiple multiple: CGFloat) -> CGFloat {
        lineHeight * multiple - lineHeight
    }
    func lineHeightMultiple(matchingLineSpacing lineSpacing: CGFloat) -> CGFloat {
        (lineHeight + lineSpacing) / lineHeight
    }
    func adjustedLineHeightMultipleAndSpacing(forPreferredMultiple multiple: CGFloat) -> (multiple: CGFloat, spacing: CGFloat) {
        let spacing = lineSpacing(matchingLineHeightMultiple: multiple) / 2
        let adjustedMultiple = lineHeightMultiple(matchingLineSpacing: spacing)
        return (adjustedMultiple, spacing)
    }
}
