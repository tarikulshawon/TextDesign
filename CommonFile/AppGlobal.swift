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
var fliterArray:NSArray!
var dataArr:NSArray? = nil
var dataArrRoot:NSArray? = nil
var dataDicRoot:NSDictionary? = nil
var imageDetailsArray = NSMutableArray()
var shouldRemove =  true

var imageDetailArrayFilter = [ImageType]()
var activeDownloads = [String: DownloadManager]()
let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
var dataTask: URLSessionDataTask?

var weeklyPrice = "$3.99/week"
var monthlyPrice = "$10.99/month"
var yearlyPrice = "Try 3-days for free, then $28.99/Year"




struct AppURL {
    static let baseUrl = "http://www.blivestudio.com/OnlyWallpapers/"
    static let newAppUrl = "https://itunes.apple.com/us/app/live-wallpapers-hd-for-iphone/id1141625538?mt=8"
}
struct ServerFileName {
    static let menuName = "wallpapers.json"
    static let settingName = "settings.json"
}
enum BtnName:String {
    case Texts
    case Graphics
    case Frames
    case Quotes
    case Adjust
    case Filter
    case Overlay
    case Image
    case Shape
    case Blur
}


struct ImageType {
    var typeName = ""
    var imageDetailArray = [ImageDetails]()
    init(typeName: String = "", imageDetailArray: [ImageDetails] = [ImageDetails]()) {
        self.typeName = typeName
        self.imageDetailArray = imageDetailArray
    }
}

enum BtnNameInt:Int {
    case Texts
    case Graphics
    case Frames
    case Quotes
    case Adjust
    case Filter
    case Overlay
    case Image
    case Shape
    case Blur
}


enum TextEditingOption: String, CaseIterable {
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
func getFilteredImage(withInfo dict: [String : Any]?, for img: UIImage?) -> UIImage? {
    let filterName = dict?["filter"] as? String
    
    let context = CIContext(options: nil)
    var currentFilter = CIFilter(name: filterName ?? "")
    currentFilter?.setDefaults()
    
    var sourceCIImage: CIImage? = nil
    if let img {
        sourceCIImage = CIImage(image: img)
    }
    
    currentFilter?.setValue(
        sourceCIImage,
        forKey: kCIInputImageKey)
    let keys = dict?.keys
    keys?.forEach { key in
        let value = dict?[key ?? ""] as? String
        if (key != "name") && (key != "filter") && (key != "color") && (key != "ImageName") {
            currentFilter?.setValue(
                NSNumber(value: Double(value ?? "") ?? 0.0),
                forKey: key ?? "")
        }
        if key == "color" {
            let colorValue = value?.components(separatedBy: ",")
            var r: Float
            var g: Float
            var b: Float
            r = Float(colorValue?[0] ?? "") ?? 0.0
            g = Float(colorValue?[1] ?? "") ?? 0.0
            b = Float(colorValue?[2] ?? "") ?? 0.0
            
            let color = CIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue: CGFloat(b / 255.0))
            
            currentFilter?.setValue(color, forKey: "inputColor")
        }
        
    }
    let adjustedImage = currentFilter?.value(forKey: kCIOutputImageKey) as? CIImage
    var cgimg: CGImage? = nil
    if let adjustedImage {
        cgimg = context.createCGImage(adjustedImage, from: adjustedImage.extent ?? CGRect.zero)
    }
    var newImg: UIImage? = nil
    if let cgimg {
        newImg = UIImage(cgImage: cgimg)
    }
    return newImg
}

func getFileUrlWithName(fileName:String) -> URL {
    let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    let path = documentsDirectoryURL?.appendingPathComponent(fileName)
    return path!
}

func getFilePathWithName(fileName:String) -> String {
    guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return ""}
    let path = documentsDirectoryURL.appendingPathComponent(fileName).path
    return path
}

func isConnectedToNetwork() -> Bool {
    guard let flags = getFlags() else { return false }
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    return (isReachable && !needsConnection)
}

func getFlags() -> SCNetworkReachabilityFlags? {
    guard let reachability = ipv4Reachability() ?? ipv6Reachability() else {
        return nil
    }
    var flags = SCNetworkReachabilityFlags()
    if !SCNetworkReachabilityGetFlags(reachability, &flags) {
        return nil
    }
    return flags
}

func ipv6Reachability() -> SCNetworkReachability? {
    var zeroAddress = sockaddr_in6()
    zeroAddress.sin6_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin6_family = sa_family_t(AF_INET6)
    
    return withUnsafePointer(to: &zeroAddress, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }
    })
}

func isFileAvailable(fileName:String) -> Bool {
    guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return false }
    let path = documentsDirectoryURL.appendingPathComponent(fileName).path
    if FileManager.default.fileExists(atPath: path) {
        return true
    }else {
        return false
    }
}

func saveToJsonFile(data:Data) {
    // Get the url of Persons.json in document directory
    guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
    let fileUrl = documentDirectoryUrl.appendingPathComponent("wallpapers.json")
    
    let fileManager = FileManager.default
    do {
        try fileManager.removeItem(at: fileUrl)
    } catch {
        // Non-fatal: file probably doesn't exist
    }
    
    do {
        try data.write(to: fileUrl, options: [])
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DataReived"), object: nil)
        })
        
    } catch {
        print(error)
    }
}



func ipv4Reachability() -> SCNetworkReachability? {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    return withUnsafePointer(to: &zeroAddress, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }
    })
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



func blurEffect(imageF:UIImage)->UIImage {
    
    var context = CIContext(options: nil)
    let currentFilter = CIFilter(name: "CIGaussianBlur")
    let beginImage = CIImage(image: imageF)
    currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
    currentFilter!.setValue(10, forKey: kCIInputRadiusKey)
    
    let cropFilter = CIFilter(name: "CICrop")
    cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
    cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")
    
    let output = cropFilter!.outputImage
    let cgimg = context.createCGImage(output!, from: output!.extent)
    let processedImage = UIImage(cgImage: cgimg!)
    return processedImage
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

extension UIImage {
    
    func blur(_ radius: Double) -> UIImage? {
        if let img = CIImage(image: self) {
            return UIImage(ciImage: img.applyingGaussianBlur(sigma: radius))
        }
        return nil
    }
}
extension UIApplication {
    /// The top most view controller
    static var topMostViewController: UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController?.visibleViewController
    }
}

extension UIViewController {
    /// The visible view controller from a given view controller
    var visibleViewController: UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.visibleViewController
        } else if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.visibleViewController
        } else if let presentedViewController = presentedViewController {
            return presentedViewController.visibleViewController
        } else {
            return self
        }
    }
}
