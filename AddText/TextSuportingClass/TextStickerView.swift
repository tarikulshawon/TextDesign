//
//  File.swift
//  DemoTextSticker
//
//  Created by Mehedi on 3/5/22.
//

import UIKit

class TextStickerView: UITextView, UIGestureRecognizerDelegate {
    
    var fontSize: CGFloat!
    var initOrigin: CGPoint!
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.backgroundColor = UIColor.clear
        self.isScrollEnabled = false
        self.isEditable = false
        self.isSelectable = false
        self.layer.cornerRadius = 10
    }
    
    override func canPerformAction(
        _ action: Selector,
        withSender sender: Any?
    ) -> Bool {
        
        return false
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
