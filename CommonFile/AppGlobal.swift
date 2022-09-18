//
//  AppGlobal.swift
//  LiveWallpaper
//
//  Created by Milan Mia on 9/9/17.
//  Copyright © 2017 Milan Mia. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import Photos
import PhotosUI
import CoreImage
import MetalPetal


var wallPaperJson = "http://www.blivestudio.com/OnlyWallpapers/wallpapers.json"
var titleColor = UIColor(red: 122.0/255.0, green: 48.0/255.0, blue: 231.0/255.0, alpha: 1)
var unselectedColor = UIColor(red: 152.0/255.0, green: 152.0/255.0, blue: 152.0/255.0, alpha: 1)
var cameraAccesMessge = "To make Live Photos, the app needs to access the Camera"
var galleryAccessMessge = "To make Live Photos from videos the app needs to access the gallery"
var arrayForFont: NSArray!
var plistArray1: NSArray!
var plistArray: NSArray!




enum BtnName:String {
    case Texts
    case Graphics
    case Quotes
    case Adjust
    case Filter
    case Overlay
    case Image
    case Shape
}

enum BtnNameInt:Int {
    case Texts
    case Graphics
    case Quotes
    case Adjust
    case Filter
    case Overlay
    case Image
    case Shape
}


enum TextEditingOption:String {
    case AddText
    case Fonts
    case Color
    case BackGround
    case Gradient
    case Draw
    case Shadow
    case Opacity
    case Align
    case Rotate
    case Texture
}


func doFilter(mainImage:UIImage,lookupImage:UIImage)->UIImage! {
    
    let cg = lookupImage.cgImage!
    let filter = MTIColorLookupFilter()
    filter.inputColorLookupTable = MTIImage(cgImage: cg, options: [MTKTextureLoader.Option.SRGB : true]).unpremultiplyingAlpha()
    if let value  = mainImage.cgImage {
        let imageFromCGImage = MTIImage(cgImage: value, isOpaque: true)
        filter.inputImage = imageFromCGImage
        
    }
    
    if let device = MTLCreateSystemDefaultDevice() {
        do {
            let context = try MTIContext(device: device)
            let filteredImage = try context.makeCGImage(from: filter.outputImage!)
            return UIImage(cgImage: filteredImage)
            
        } catch {
            
        }
        
    }
    return nil
    
    
}



func getColor(colorString: String) -> UIColor {
    
    var array = colorString.components(separatedBy: ",")
    if let firstNumber = array[0] as? String,
       let secondNumber = array[1] as? String,
       let thirdNumber = array[2] as? String {
        
        if let f1  = Double(firstNumber.trimmingCharacters(in: .whitespacesAndNewlines)),
           let f2 = Double (secondNumber.trimmingCharacters(in: .whitespacesAndNewlines)),
           let f3 = Double(thirdNumber.trimmingCharacters(in: .whitespacesAndNewlines)) {
            
            return UIColor(red: f1/255.0 , green: f2/255.0 , blue: f3/255.0 , alpha: 1.0)
        }
    }
    return UIColor.black
    
    
}


extension MTIImage {
    
    public func adjusting(saturation: Float, outputPixelFormat: MTLPixelFormat = .unspecified) -> MTIImage {
        let filter = MTISaturationFilter()
        filter.saturation = saturation
        filter.inputImage = self
        filter.outputPixelFormat = outputPixelFormat
        return filter.outputImage!
    }
    
    public func adjusting(exposure: Float, outputPixelFormat: MTLPixelFormat = .unspecified) -> MTIImage {
        let filter = MTIExposureFilter()
        filter.exposure = exposure
        filter.inputImage = self
        filter.outputPixelFormat = outputPixelFormat
        return filter.outputImage!
    }
    
    public func adjusting(brightness: Float, outputPixelFormat: MTLPixelFormat = .unspecified) -> MTIImage {
        let filter = MTIBrightnessFilter()
        filter.brightness = brightness
        filter.inputImage = self
        filter.outputPixelFormat = outputPixelFormat
        return filter.outputImage!
    }
    
    public func adjusting(contrast: Float, outputPixelFormat: MTLPixelFormat = .unspecified) -> MTIImage {
        let filter = MTIContrastFilter()
        filter.contrast = contrast
        filter.inputImage = self
        filter.outputPixelFormat = outputPixelFormat
        return filter.outputImage!
    }
    
    public func adjusting(hue: Float, outputPixelFormat: MTLPixelFormat = .unspecified) -> MTIImage {
        let filter = MTIContrastFilter()
        filter.contrast = hue
        filter.inputImage = self
        filter.outputPixelFormat = outputPixelFormat
        return filter.outputImage!
    }
    
    public func adjusting(vibrance: Float, outputPixelFormat: MTLPixelFormat = .unspecified) -> MTIImage {
        let filter = MTIVibranceFilter()
        filter.amount = vibrance
        filter.inputImage = self
        filter.outputPixelFormat = outputPixelFormat
        return filter.outputImage!
    }
    
    /// Returns a MTIImage object that specifies a subimage of the image. If the `region` parameter defines an empty area, returns nil.
    public func cropped(to region: MTICropRegion, outputPixelFormat: MTLPixelFormat = .unspecified) -> MTIImage? {
        let filter = MTICropFilter()
        filter.cropRegion = region
        filter.inputImage = self
        filter.outputPixelFormat = outputPixelFormat
        return filter.outputImage
    }
    
    /// Returns a MTIImage object that specifies a subimage of the image. If the `rect` parameter defines an empty area, returns nil.
    public func cropped(to rect: CGRect, outputPixelFormat: MTLPixelFormat = .unspecified) -> MTIImage? {
        let filter = MTICropFilter()
        filter.cropRegion = MTICropRegion(bounds: rect, unit: .pixel)
        filter.inputImage = self
        filter.outputPixelFormat = outputPixelFormat
        return filter.outputImage
    }
    
    /// Returns a MTIImage object that is resized to a specified size. If the `size` parameter has zero/negative width or height, returns nil.
    public func resized(to size: CGSize, outputPixelFormat: MTLPixelFormat = .unspecified) -> MTIImage? {
        assert(size.width >= 1 && size.height >= 1)
        guard size.width >= 1 && size.height >= 1 else { return nil }
        return MTIUnaryImageRenderingFilter.image(byProcessingImage: self, orientation: .up, parameters: [:], outputPixelFormat: outputPixelFormat, outputImageSize: size)
    }
    
    /// Returns a MTIImage object that is resized to a specified size. If the `size` parameter has zero/negative width or height, returns nil.
    public func resized(to target: CGSize, resizingMode: MTIDrawableRenderingResizingMode, outputPixelFormat: MTLPixelFormat = .unspecified) -> MTIImage? {
        let size: CGSize
        switch resizingMode {
        case .aspect:
            size = MTIMakeRect(aspectRatio: self.size, insideRect: CGRect(origin: .zero, size: target)).size
        case .aspectFill:
            size = MTIMakeRect(aspectRatio: self.size, fillRect: CGRect(origin: .zero, size: target)).size
        case .scale:
            size = target
        @unknown default:
            fatalError()
        }
        assert(size.width >= 1 && size.height >= 1)
        guard size.width >= 1 && size.height >= 1 else { return nil }
        return MTIUnaryImageRenderingFilter.image(byProcessingImage: self, orientation: .up, parameters: [:], outputPixelFormat: outputPixelFormat, outputImageSize: size)
    }
}


extension UIColor {

    func rgb() -> (red:Int, green:Int, blue:Int, alpha:Int)? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)

            return (red:iRed, green:iGreen, blue:iBlue, alpha:iAlpha)
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
}
