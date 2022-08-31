//
//  UIColor+Extension.swift
//  Photo Collage
//
//  Created by Mac mini on 27/10/20.
//

import Foundation
import UIKit
import Photos
//import MetalPetal

extension UIColor{
//    func getAllMetarialColor() -> Array<UIColor> {
//        var array = Array<UIColor>()
//        //black
//        array.append(MDCPalette.grey.tint100)
//        array.append(MDCPalette.grey.tint200)
//        array.append(MDCPalette.grey.tint300)
//        array.append(MDCPalette.grey.tint700)
//        array.append(UIColor.black)
//        array.append(UIColor.white)
//
//        array.append(MDCPalette.amber.tint100)
//        array.append(MDCPalette.amber.tint300)
//        array.append(MDCPalette.amber.tint500)
//        array.append(MDCPalette.amber.tint700)
//        array.append(MDCPalette.amber.tint900)
//
//        array.append(MDCPalette.blue.tint100)
//        array.append(MDCPalette.blue.tint300)
//        array.append(MDCPalette.blue.tint500)
//        array.append(MDCPalette.blue.tint700)
//        array.append(MDCPalette.blue.tint900)
//
//        array.append(MDCPalette.lightBlue.tint100)
//        array.append(MDCPalette.lightBlue.tint300)
//        array.append(MDCPalette.lightBlue.tint500)
//        array.append(MDCPalette.lightBlue.tint700)
//        array.append(MDCPalette.lightBlue.tint900)
//
//        array.append(MDCPalette.blueGrey.tint100)
//        array.append(MDCPalette.blueGrey.tint300)
//        array.append(MDCPalette.blueGrey.tint500)
//        array.append(MDCPalette.blueGrey.tint700)
//        array.append(MDCPalette.blueGrey.tint900)
//
//        array.append(MDCPalette.brown.tint100)
//        array.append(MDCPalette.brown.tint300)
//        array.append(MDCPalette.brown.tint500)
//        array.append(MDCPalette.brown.tint700)
//        array.append(MDCPalette.brown.tint900)
//
//        array.append(MDCPalette.cyan.tint100)
//        array.append(MDCPalette.cyan.tint300)
//        array.append(MDCPalette.cyan.tint500)
//        array.append(MDCPalette.cyan.tint700)
//        array.append(MDCPalette.cyan.tint900)
//
//
//
//        array.append(MDCPalette.green.tint100)
//        array.append(MDCPalette.green.tint300)
//        array.append(MDCPalette.green.tint500)
//        array.append(MDCPalette.green.tint700)
//        array.append(MDCPalette.green.tint900)
//
//        array.append(MDCPalette.lightGreen.tint100)
//        array.append(MDCPalette.lightGreen.tint300)
//        array.append(MDCPalette.lightGreen.tint500)
//        array.append(MDCPalette.lightGreen.tint700)
//        array.append(MDCPalette.lightGreen.tint900)
//
//
//        array.append(MDCPalette.indigo.tint100)
//        array.append(MDCPalette.indigo.tint300)
//        array.append(MDCPalette.indigo.tint500)
//        array.append(MDCPalette.indigo.tint700)
//        array.append(MDCPalette.indigo.tint900)
//
//        array.append(MDCPalette.lime.tint100)
//        array.append(MDCPalette.lime.tint300)
//        array.append(MDCPalette.lime.tint500)
//        array.append(MDCPalette.lime.tint700)
//        array.append(MDCPalette.lime.tint900)
//
//        array.append(MDCPalette.orange.tint100)
//        array.append(MDCPalette.orange.tint300)
//        array.append(MDCPalette.orange.tint500)
//        array.append(MDCPalette.orange.tint700)
//        array.append(MDCPalette.orange.tint900)
//
//        array.append(MDCPalette.deepOrange.tint100)
//        array.append(MDCPalette.deepOrange.tint300)
//        array.append(MDCPalette.deepOrange.tint500)
//        array.append(MDCPalette.deepOrange.tint700)
//        array.append(MDCPalette.deepOrange.tint900)
//
//        array.append(MDCPalette.pink.tint100)
//        array.append(MDCPalette.pink.tint300)
//        array.append(MDCPalette.pink.tint500)
//        array.append(MDCPalette.pink.tint700)
//        array.append(MDCPalette.pink.tint900)
//
//        array.append(MDCPalette.purple.tint100)
//        array.append(MDCPalette.purple.tint300)
//        array.append(MDCPalette.purple.tint500)
//        array.append(MDCPalette.purple.tint700)
//        array.append(MDCPalette.purple.tint900)
//
//        array.append(MDCPalette.deepPurple.tint100)
//        array.append(MDCPalette.deepPurple.tint300)
//        array.append(MDCPalette.deepPurple.tint500)
//        array.append(MDCPalette.deepPurple.tint700)
//        array.append(MDCPalette.deepPurple.tint900)
//
//        array.append(MDCPalette.red.tint100)
//        array.append(MDCPalette.red.tint300)
//        array.append(MDCPalette.red.tint500)
//        array.append(MDCPalette.red.tint700)
//        array.append(MDCPalette.red.tint900)
//
//        array.append(MDCPalette.teal.tint100)
//        array.append(MDCPalette.teal.tint300)
//        array.append(MDCPalette.teal.tint500)
//        array.append(MDCPalette.teal.tint700)
//        array.append(MDCPalette.teal.tint900)
//
//        array.append(MDCPalette.yellow.tint100)
//        array.append(MDCPalette.yellow.tint300)
//        array.append(MDCPalette.yellow.tint500)
//        array.append(MDCPalette.yellow.tint700)
//        array.append(MDCPalette.yellow.tint900)
//
//
//
//        return array
//    }
    
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
}

extension UIView {
    
    func colorOfPoint(point : CGPoint) -> UIColor {
        let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        var pixelData:[UInt8] = [0, 0, 0, 0]
        
        let context = CGContext(data: &pixelData, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        context!.translateBy(x: -point.x, y: -point.y);
        self.layer.render(in: context!)
        
        let red:CGFloat = CGFloat(pixelData[0])/CGFloat(255.0)
        let green:CGFloat = CGFloat(pixelData[1])/CGFloat(255.0)
        let blue:CGFloat = CGFloat(pixelData[2])/CGFloat(255.0)
        let alpha:CGFloat = CGFloat(pixelData[3])/CGFloat(255.0)
        
        let color:UIColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        
        return color
    }
}
