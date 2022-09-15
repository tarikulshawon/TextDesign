//
//  TextViewInfExtension.swift
//  TextViewDemo
//
//  Created by MacBook Pro on 12/13/20.
//

import UIKit

struct TextViewInformation {
    var text: String!
    var width: CGFloat!
    var height: CGFloat!
    var font: UIFont!
    var alignment: NSTextAlignment!
    var shadow: CGFloat!
    var background: UIColor!
    var textColor: UIColor!
    var bGColor: UIColor!
    
    init(text: String, width: CGFloat, height: CGFloat, font: UIFont, alignment: NSTextAlignment, shadow: CGFloat, background: UIColor, textColor: UIColor, bGColor: UIColor) {
        self.text = text
        self.width = width
        self.height = height
        self.font = font
        self.alignment = alignment
        self.shadow = shadow
        self.background = background
        self.textColor = textColor
        self.bGColor = bGColor
    }
    
}

extension UITextView {
    
func setCharacterSpacing(_ spacing: CGFloat){
    let attributedStr = NSMutableAttributedString(string: self.text ?? "")
    attributedStr.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSMakeRange(0, attributedStr.length))
    self.attributedText = attributedStr
 }
    
    func updateTextFont() {
        if text.isEmpty || bounds.size.equalTo(CGSize.zero) { return }
        
        let textViewSize = self.frame.size
        let fixedWidth = textViewSize.width
        let expectSize = self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)))
        
        var expectFont = self.font
        if (expectSize.height > textViewSize.height) {
            while (self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height > textViewSize.height) {
                expectFont = self.font!.withSize(self.font!.pointSize - 1)
                self.font = expectFont
            }
        }
        else {
            while (self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height < textViewSize.height) {
                expectFont = self.font
                self.font = self.font!.withSize(self.font!.pointSize + 1)
            }
            self.font = expectFont
        }
    }
}
