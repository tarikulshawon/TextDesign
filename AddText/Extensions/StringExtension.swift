//
//  StringExtension.swift
//  TextViewDemo
//  M M Mehedi Hasan
//  Created by MacBook Pro on 11/25/20.
//

import UIKit

struct PresentInfo {
    var text: String!
    var font: UIFont!
    var backgroundColor: UIColor!
    var textColor: UIColor!
    var shadowRadius: CGFloat!
    var shadowColor: CGColor
    var shadowOpacity: Float!
    var alignment: NSTextAlignment!
}

extension String {
    
    func count(of needle: Character) -> Int {
        return reduce(0) {
            $1 == needle ? $0 + 1 : $0
        }
    }
    
    mutating func insert(string:String,ind:Int) {
        self.insert(contentsOf: string, at:self.index(self.startIndex, offsetBy: ind) )
    }
    
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }

    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }

    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
    
    subscript(i: Int) -> String {
            return String(self[index(startIndex, offsetBy: i)])
        }
}

extension UITextView {
    
    func increaseFontSize (fontSize: CGFloat) {
        let maxFontSize: CGFloat = fontSize
        self.font =  UIFont(name: self.font!.fontName, size: min( self.font!.pointSize + 1, CGFloat(maxFontSize)))
    }
    
    func sizeFit(width: CGFloat) -> CGSize {
            let fixedWidth = width
            let newSize = sizeThatFits(CGSize(width: fixedWidth, height: .greatestFiniteMagnitude))
            return CGSize(width: fixedWidth, height: newSize.height)
    }
    
    func numberOfLine() -> Int {
            let size = self.sizeFit(width: self.bounds.width)
            let numLines = Int(size.height / (self.font?.lineHeight ?? 1.0))
            return numLines
    }
    
}

extension Array where Element: Hashable {
    var uniques: Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}
