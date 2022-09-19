//
//  BorderExtenstion.swift
//  TextEditor
//
//  Created by M M MEHEDI HASAN on 1/21/21.
//

import UIKit

class BorderExtenstion: NSObject {

}

extension UIView {
    //MARK: Draw Border On View
    func drawBorder(frame: CGRect, zoomScale: CGFloat){
        if self.layer.sublayers?.count ?? 0 > 0 {
            for temp in self.layer.sublayers! {
                if temp.name == "BorderLine"{
                    temp.removeFromSuperlayer()
                }
            }
        }
        
        let layer = CAShapeLayer.init()
        layer.name = "BorderLine"
        let path = UIBezierPath(roundedRect: frame, cornerRadius: 5)
        layer.path = path.cgPath
        layer.strokeColor = UIColor.white.cgColor
       // layer.lineDashPattern = [2,1]
        layer.backgroundColor = UIColor.clear.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 3.0 / zoomScale
        self.layer.addSublayer(layer)
        
        for sub in self.subviews{
            if sub.tag == 101 || sub.tag == 102 || sub.layer.name == "hide"{
                self.bringSubviewToFront(sub)
            }
        }
    }
    
   
}
