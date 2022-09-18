//
//  File.swift
//  DemoTextSticker
//
//  Created by Mehedi on 3/5/22.
//

import UIKit

//@inline(__always) func CGAffineTransformGetAngle(_ t:CGAffineTransform) -> CGFloat {
//    return atan2(t.b, t.a)
//}

//@inline(__always) func CGPointGetDistance(point1:CGPoint, point2:CGPoint) -> CGFloat {
//    let fx = point2.x - point1.x
//    let fy = point2.y - point1.y
//    return sqrt(fx * fx + fy * fy)
//}

class PanControllerImageView: UIImageView, UIGestureRecognizerDelegate {
    var textView: TextStickerView!
    var initialFrame: CGRect!
    var initialFontSize: CGFloat!
    var initialDist: CGFloat!
    var initialCenter: CGPoint!
    var deltaAngle: CGFloat!
    var panControllerSize: CGFloat = 25
    var pController: PanControllerImageView!
    var delegate: UpdateTextFontSize!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        self.image = UIImage(named: "Rotate")
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(panGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addDelegate(delegate: UpdateTextFontSize) {
        self.delegate = delegate
    }
}

extension PanControllerImageView: UpdateTextFontSize {
    func updateFontSize(to: CGFloat) {
        print("[UPDATE FONT DELEGATE CALLED]")
    }
}

extension PanControllerImageView {
    //MARK: Add Gesture
    func addGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        addGestureRecognizer(panGesture)
    }
    
    @objc
    func handlePanGesture(gesture: UIPanGestureRecognizer){
        let location = gesture.location(in: self.superview!.superview)
        let center = self.superview!.center
        switch gesture.state {
        case .began:
            for sub in self.superview!.subviews  {
                if sub.tag == 1000{
                    self.textView = (sub as! TextStickerView)
                }
            }
            //self.textView.text = self.
            self.deltaAngle = CGFloat(atan2f(Float(location.y - center.y), Float(location.x - center.x))) - CGAffineTransformGetAngle(self.superview!.transform)
            
            self.initialDist = CGPointGetDistance(point1: center, point2: location)
            self.initialFontSize = self.textView.font!.pointSize
            
            break
        case .changed:
            guard let textView = textView else {
                print("Text view is nil")
                return
            }
            
            let angle = atan2f(Float(location.y - center.y), Float(location.x - center.x))
            let angleDiff = Float (self.deltaAngle) - angle
            self.superview!.transform = CGAffineTransform(rotationAngle: CGFloat(-angleDiff))
            
            // let scale = (area2 / area1)
            let scale = (CGPointGetDistance(point1: center, point2: location) / self.initialDist)
            
            //self.distance(center, location) / self.initialDist
            //  print("Scale2  ; ", scale ,"  :  ")
            textView.font = UIFont(name: textView.font!.fontName, size: initialFontSize * scale)
            let newSize = textView.sizeThatFits(
                CGSize(
                    width: CGFloat.greatestFiniteMagnitude,
                    height: CGFloat.greatestFiniteMagnitude
                )
            )
            
            let containerSize = CGSize(
                width: newSize.width + panControllerSize * 2,
                height: newSize.height + panControllerSize * 2
            
            )
            let textviewSize = CGSize(width: newSize.width, height: newSize.height)
            
            textView.bounds.size = textviewSize
            textView.frame.origin = CGPoint(
                x: (gesture.view?.superview!.bounds.origin)!.x + panControllerSize,
                y: (gesture.view?.superview!.bounds.origin)!.y + panControllerSize
            )
            
            gesture.view?.superview!.bounds.size = containerSize
            
            gesture.view?
                .superview!
                .drawBorder(
                    frame: CGRect(x: panControllerSize * 0.5,
                                  y: panControllerSize * 0.5,
                                  width: containerSize.width - (1 * panControllerSize),
                                  height: containerSize.height - (1 * panControllerSize)),
                    zoomScale: UIScreen.main.scale
                )
            //self.frame.origin = CGPoint(x: containerFrame.width - 44, y: 0)
            textView.fontSize = textView.font?.pointSize
            
            break
        case .ended:
            //            gesture.view?.superview?.frame.size = CGSize(width: self.initialFrame.width + translation.x, height: self.initialFrame.height + translation.y)
            
            
            delegate.updateFontSize(to: textView.fontSize)
            print("End")
            break
        default:
            print("Not Match")
        }
    }
    
}
