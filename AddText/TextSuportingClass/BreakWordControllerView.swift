//
//  File.swift
//  DemoTextSticker
//
//  Created by Mehedi on 3/5/22.
//


import UIKit

class BreakWordControllerView: UIView {
    
    var textView: TextStickerView!
    var initialFrame: CGRect!
    var initialbounds: CGRect!
    var initialFontSize: CGFloat!
    var initialDist: CGFloat!
    var initialCenter: CGPoint!
    var panControllerSize: CGFloat = 25
    var maxCharWidth: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        panGesture.delegate = self
        self.addGestureRecognizer(panGesture)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension BreakWordControllerView {
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer){
        let location = gesture.location(in: self.superview!.superview)
        let center = self.superview!.center
        switch gesture.state {
        case .began:
            for sub in self.superview!.subviews  {
                if sub.tag == 1000{
                    self.textView = (sub as! TextStickerView)
                  //  print("HHH  ", self.textView.text)
                    let text =  self.prepareTextBeforeBreak(text: self.textView.text)
                  //  print("TB  ", text)
                    self.textView.text = text
                }
            }
            self.maxCharWidth = self.getMaxCharWidth(text: self.textView.text)
            self.initialDist = CGPointGetDistance(point1: center, point2: location)
            self.initialFontSize = self.textView.font!.pointSize
            self.initialFrame = self.superview!.frame
            self.initialbounds = self.superview?.bounds
            
            break
        case .changed:
            
            if textView != nil{
               // let scale = (area2 / area1)
                let scale = (CGPointGetDistance(point1: center, point2: location) / self.initialDist)
               // let diff = ((self.initialbounds.width * scale) - self.initialbounds.width)
                let pos = self.panControllerSize * 2
                
                gesture.view!.superview!.bounds.size = CGSize(width: max(self.maxCharWidth + 8 + pos, self.initialFrame.width * scale), height: self.initialFrame.height)
                
                self.textView.frame = CGRect(x: pos * 0.5, y: pos * 0.5, width: gesture.view!.superview!.bounds.size.width - pos, height: gesture.view!.superview!.bounds.size.height - pos)
              //  print("T1  ", self.textView.bounds.size)
                let sz = self.textView.sizeThatFits(CGSize(width: textView.bounds.size.width, height: CGFloat.greatestFiniteMagnitude))
              //  print("T2  ", self.textView.bounds.size,"  ", sz)
                
                gesture.view!.superview!.bounds.size = CGSize(width: sz.width + pos, height: sz.height + pos)
                self.textView.bounds.size = sz
                
                self.textView.frame.origin = CGPoint(x: gesture.view!.superview!.bounds.origin.x + self.panControllerSize, y: gesture.view!.superview!.bounds.origin.y + self.panControllerSize)
                
                gesture.view?.superview!.drawBorder(frame: CGRect(x: self.panControllerSize * 0.5, y: self.panControllerSize * 0.5, width: gesture.view!.superview!.bounds.width - (1 * self.panControllerSize), height: gesture.view!.superview!.bounds.height - (1 * self.panControllerSize)), zoomScale: UIScreen.main.scale)
            }
            break
        case .ended:
            if textView.text != nil {
                let text = self.textView.text
                var result = ""
                textView.layoutManager.enumerateLineFragments(forGlyphRange: NSRange(location: 0, length: text!.count)) { [self] (rect, usedRect, textContainer, glyphRange, stop) in

                    let characterRange = textView.layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
                    let line = (textView.text as NSString).substring(with: characterRange)
                    if result == "" {
                        result += line
                    }else{
                        result += "\n"
                        result += line
                    }
                }
                self.textView.text = result
            }
            print("End1")
            break
        default:
            print("Not Match1")
        }
    }
    
    func prepareTextBeforeBreak(text: String) -> String{
        var text1 = ""
        for char in text {
            if char != "\n"{
                text1 += String(char)
            }
        }
        return text1
    }
    
    func getMaxCharWidth(text: String) -> CGFloat{
        var maxi: CGFloat = 0
        for char in text {
            maxi = max(maxi, String(char).widthOfString(usingFont: self.textView.font!))
        }
        return maxi
    }
}

extension BreakWordControllerView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
