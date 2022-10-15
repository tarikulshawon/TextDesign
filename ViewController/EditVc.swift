//
//  EditVc.swift
//  TextArt
//
//  Created by Sadiqul Amin on 11/8/22.
//

import UIKit
import AVFoundation
import CoreImage
import MetalPetal
import Photos
import FlexColorPicker
import SwiftUI

protocol callDelegate: AnyObject {
    func reloadAllData()
}

class EditVc: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ColorPickerDelegate, sendTextValue, sendFrames, sendValueForAdjust, sendImageDelegate {
    
    
    @IBOutlet weak var watermarkView: UIImageView!
    @IBOutlet weak var colorPickerHolder: UIView!
    @IBOutlet weak var screenSortView: UIView!
    @IBOutlet weak var overLayVcHolder: UIView!
    @IBOutlet weak var drawHolderView: UIView!
    @IBOutlet weak var filterViewHolder: UIView!
    @IBOutlet weak var stickerViewHolder: UIView!
    @IBOutlet weak var HolderView: UIView!
    @IBOutlet weak var textViewHolderView: UIView!
    @IBOutlet weak var imageViewHolder: UIView!
    @IBOutlet weak var shapeHolderView: UIView!
    @IBOutlet weak var ajustVcHolder: UIView!
    @IBOutlet weak var frameVcHolder: UIView!
    @IBOutlet weak var transParentView: UIImageView!
    @IBOutlet weak var showingBubbleView: UIView!
    
    
    @IBOutlet weak var heightForColorPickerView: NSLayoutConstraint!
    @IBOutlet weak var bottomSpceOfMainView: NSLayoutConstraint!
    @IBOutlet weak var bottomSpaceForColorPicker: NSLayoutConstraint!
    @IBOutlet weak var bottomSpaceForFrame: NSLayoutConstraint!
    @IBOutlet weak var collectionViewForBackGround: UICollectionView!
    @IBOutlet weak var bottomSpaceForDrawer: NSLayoutConstraint!
    @IBOutlet weak var bottomSpaceForOverlay: NSLayoutConstraint!
    @IBOutlet weak var bottomSapceForShape: NSLayoutConstraint!
    @IBOutlet weak var bottomSpaceForImageViewHolder: NSLayoutConstraint!
    @IBOutlet weak var bottomSpaceForFilter: NSLayoutConstraint!
    @IBOutlet weak var bottomSpaceFoSticker: NSLayoutConstraint!
    @IBOutlet weak var bottomSpaceOfFontLoaderView: NSLayoutConstraint!
    @IBOutlet weak var bottomSpaceForAdjust: NSLayoutConstraint!
    @IBOutlet weak var widthForImv: NSLayoutConstraint!
    @IBOutlet weak var heightForImv: NSLayoutConstraint!
    @IBOutlet weak var heightForShapeVc: NSLayoutConstraint!
    
    
    @IBOutlet weak var bottomSpaceForBlur: NSLayoutConstraint!
    @IBOutlet weak var slider1: UISlider!
    @IBOutlet weak var slider2: UISlider!
    @IBOutlet weak var slider3: UISlider!
    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    
    var currentTextStickerView: TextStickerContainerView?
    var imageInfoObj = ImageInfoData()
    weak var delegateFor: callDelegate?
    var stickerObjList = [StickerValueObj]()
    var currentStickerView: StickerView?
    
    var isfromUpdate = false
    var currentlyActiveIndex = -1
    var currentFilterDic:Dictionary<String, Any>?
    var cellWidth:CGFloat = 60
    var cellGap:CGFloat =  0
    var ov:Float =  0.3
    var currentLookUpindex = 0
    var plistArray2:NSArray!
    var mainImage:UIImage!
    var currentBlurValue:Double = -1
    
    var Brightness: Float = 0.0
    var max_brightness:Float = 0.7
    var min_brightness:Float = -0.7
    
    var Saturation: Float = 1.0
    var max_saturation:Float = 3
    var min_saturation:Float = -1
    
    var hue: Float = 0.0
    var max_hue:Float = 1.0
    var min_hue:Float = -1.0
    
    var Contrast: Float = 1.0
    var max_contrast:Float = 1.5
    var min_contrast:Float = 0.5
    
    var sharpen:Float = 0
    var max_sharpen:Float = 4.0
    var min_sharpen:Float = -4.0
    
    var currentOverlayIndex = 0
    var currentBackGroundIndex  = 0
    var tagValue = 1000000
    
    @IBOutlet weak var bottomSpaceForBackGroundView: NSLayoutConstraint!
    @IBOutlet weak var btnCollectionView: UICollectionView!
    @IBOutlet weak var mainImv: UIImageView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var overLaySlider: CustomSlider!
    
    let filterVc =  Bundle.main.loadNibNamed("FilterVc", owner: nil, options: nil)![0] as! FilterVc
    let overLayVc = Bundle.main.loadNibNamed("OverLayVc", owner: nil, options: nil)![0] as! OverLayVc
    let shapeVc = Bundle.main.loadNibNamed("ShapeVc", owner: nil, options: nil)![0] as! ShapeVc
    let stickerVc = Bundle.main.loadNibNamed("StickerVc", owner: nil, options: nil)![0] as! StickerVc
    let adjustVc = Bundle.main.loadNibNamed("Adjust", owner: nil, options: nil)![0] as! Adjust
    let imageEditView = Bundle.main.loadNibNamed("ImageEditView", owner: nil, options: nil)![0] as! ImageEditView
    let drawVc =  Bundle.main.loadNibNamed("DrawVc", owner: nil, options: nil)![0] as! DrawVc
    let frameVc =  Bundle.main.loadNibNamed("FrameVc", owner: nil, options: nil)![0] as! FrameVc
    
    
    let TextEditVc: TextEditView = TextEditView.loadFromXib()
    let controller = DefaultColorPickerViewController()
    
    var isFromTextColor = true
    
    func sendImage() {
        self.processSnapShotPhotos()
    }
    
    func getImgae(br:Float,sat:Float,sha:Float,contr:Float,image:UIImage)->UIImage {
        
        
        if let currentFilter = CIFilter(name:"CIColorControls") {
            let beginImage = CIImage(image: image)
            let context = CIContext(options: nil)
            
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            currentFilter.setValue(br, forKey: kCIInputBrightnessKey)
            currentFilter.setValue(sat, forKey: kCIInputSaturationKey)
            currentFilter.setValue(contr, forKey: kCIInputContrastKey)
            
            if let output = currentFilter.outputImage {
                if let cgimg = context.createCGImage(output, from: output.extent) {
                    let processedImage = UIImage(cgImage: cgimg)
                    
                    let context = CIContext(options: nil)
                    if let currentFilter = CIFilter(name:"CISharpenLuminance") {
                        
                        let beginImage = CIImage(image: processedImage)
                        
                        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
                        currentFilter.setValue(sha, forKey: "inputSharpness")
                        if let output = currentFilter.outputImage {
                            if let cgimg = context.createCGImage(output, from: output.extent) {
                                let processedImage = UIImage(cgImage: cgimg)
                                 return processedImage
                            }
                        }
                    }
                    
                }
            }
        }
        return UIImage()
    }
    func chnageValue(value: Float, index:Int) {
        if currentStickerView?.pathType == "Image" {
            var lol  = getFileUrlWithName(fileName: currentStickerView?.pathName ?? "")
            
            guard let data = try? Data(contentsOf: lol as URL),let image = UIImage(data: data) else {
                return
            }
            
            
            if index == 0 {
                currentStickerView?.brightness = value
            } else if index == 1 {
                currentStickerView?.saturation = value
            }
            else if index == 2 {
                currentStickerView?.contrast = value
            }
            else if index == 3 {
                currentStickerView?.sharpen = value
            }
            
            currentStickerView?.contentView.image = self.getImgae(br: currentStickerView?.brightness ?? 0.0, sat: currentStickerView?.saturation ?? 1.0, sha: currentStickerView!.sharpen, contr:  currentStickerView?.contrast ?? 1.0, image: image)
            
        }
    }
    
    func updateStickerF(sticker:StickerView,selectedImage:UIImage) {
        if let value = currentStickerView {
            currentStickerView?.contentView.image = selectedImage
        }
    }
    
    func changeImageOpacity(value: Float) {
        if let valueF = currentStickerView {
            valueF.alpha = CGFloat(value)
            valueF.opacity = Double(value)
        }
    }
    
    func sendAdjustValue(value: Float, index: Int) {
        print(value)
        print(index)
        
        if index == 0 {
            Brightness = value
        }else if index == 1 {
            Saturation = value
        }
        else if index == 2 {
            hue = value
        }
        else if index == 3 {
            sharpen = value
        }
        else if index == 4 {
            hue = value
        }
        
        self.DoAdjustMent(inputImage: mainImage)
    }
    
    func sendFramesIndex(frames: String) {
        self.addSticker(test: UIImage(named: frames)!, type: "Image", pathName: frames)
    }
    
    func sendText(text: String) {
        if text.count > 1 {
            currentTextStickerView?.textView = currentTextStickerView?.textStickerView
            currentTextStickerView?.textStickerView.text = text
            
            currentTextStickerView?.UpdateTextStickerData(
                currentContainerView: currentTextStickerView!,
                currentTextView: currentTextStickerView!.textStickerView!,
                mainTextView: currentTextStickerView!.textView
            )
            currentTextStickerView?.scaleController.updateFrame()
        }
    }
    
    func rgbComponents(color:UIColor)-> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        if color.getRed(&r, green: &g, blue: &b, alpha: &a) {
            
            let iRed = Int(r * 255.0)
            let iGreen = Int(g * 255.0)
            let iBlue = Int(b * 255.0)
            let iAlpha = Int(a * 255.0)
            return  "\(iRed),\(iGreen),\(iBlue)"
        }
        return "0,0,0,0"
    }
    
    func colorPicker(_ colorPicker: FlexColorPicker.ColorPickerController, selectedColor: UIColor, usingControl: FlexColorPicker.ColorControl) {
        
        
        var value =  rgbComponents(color: selectedColor)
        colorValue(color: value)
        print(value)
        
    }
    
    func colorPicker(_ colorPicker: FlexColorPicker.ColorPickerController, confirmedColor: UIColor, usingControl: FlexColorPicker.ColorControl) {
        
    }
    
    
    
    @IBAction func segmentValueHasChanged(_ sender: UISegmentedControl) {
        
        currentBackGroundIndex = sender.selectedSegmentIndex
        collectionViewForBackGround.reloadData()
        
    }
    
    @IBAction func hideBackgorundView(_ sender: Any) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.bottomSpaceForBackGroundView.constant = -1000
            self.view.layoutIfNeeded()
        }, completion: {_ in
        })
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.hideALL()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        controller.view.frame = CGRect(x: 0, y: 45, width: colorPickerHolder.frame.width, height: colorPickerHolder.frame.height - 50)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller.useRadialPalette = false
        controller.colorPreview.isHidden = false
        controller.brightnessSlider.isHidden  = false
        controller.delegate = self
        controller.rectangularPaletteBorderOn = true
        colorPickerHolder.addSubview(controller.view)
        controller.selectedColor = UIColor.red
        controller.view.backgroundColor = UIColor.white
        self.addChild(controller)
        controller.didMove(toParent: self)
        
//        let childView = UIHostingController(rootView: SwiftUIView())
//        addChild(childView)
//        childView.view.frame = watermarkView.bounds
//        watermarkView.addSubview(childView.view)
//        childView.view.backgroundColor = .clear
//        childView.didMove(toParent: self)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        screenSortView.addGestureRecognizer(tap)
        
        mainImv.image = mainImage
        
        mainImv.contentMode = .scaleAspectFit
        
        if isfromUpdate {
            saveBtn.setTitle("Update", for: .normal)
        } else {
            saveBtn.setTitle("Save", for: .normal)
        }
        saveBtn.setTitleColor(titleColor, for: .normal)
        
        
        if let data = UserDefaults.standard.data(forKey: imageInfoObj.id),
           let scoreList = NSKeyedUnarchiver.unarchiveObject(with: data) as? Dictionary<String, Any> {
            
             currentFilterDic = scoreList
         }
        
        
        if isfromUpdate {
            stickerObjList = DBmanager.shared.getStickerInfo(fileName: imageInfoObj.id)
            let defaults = UserDefaults.standard
            if let data2 = defaults.object(forKey: imageInfoObj.id) as? NSData {
                
                do {
                    
                }
                catch let error {
                    
                }
                
            }
            
            for item in stickerObjList {
                updateSticker(obj: item)
            }
            
            Brightness = imageInfoObj.Bri.floatValue
            Saturation = imageInfoObj.Sat.floatValue
            Contrast = imageInfoObj.Cont.floatValue
            hue = imageInfoObj.Hue.floatValue
            sharpen = imageInfoObj.sh.floatValue
            print(sharpen)
            currentOverlayIndex = Int(imageInfoObj.OverLay) ?? 0
            ov = imageInfoObj.ov.floatValue
        }
        
        
        
        let emptyAutomationsCell = RatioCell.nib
        btnCollectionView?.register(emptyAutomationsCell, forCellWithReuseIdentifier: RatioCell.reusableID)
        
        let nibName = UINib(nibName: ColorCell.reusableID, bundle: nil)
        collectionViewForBackGround.register(nibName, forCellWithReuseIdentifier:  ColorCell.reusableID)
        
        let path = Bundle.main.path(forResource: "btn", ofType: "plist")
        plistArray2 = NSArray(contentsOfFile: path!)
        self.perform(#selector(self.targetMethod1), with: self, afterDelay:0.1)
        
        if isfromUpdate {
            
            DispatchQueue.main.async {
                self.DoAdjustMent(inputImage: self.mainImage)
            }

            overLayVc.delegateForOverlay = self
            overLayVc.setOverLay(index: currentOverlayIndex)
            transParentView.alpha = CGFloat(ov)
        }
        hideALL()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.updateHeight(heightNeedToBeRemoved: 0)
    }
    
    
    
    
    @IBAction func mamama(_ sender: Any) {
        currentFilterDic = nil
        DoAdjustMent(inputImage: mainImage)

    }
    
    @IBAction func blurValueChange(_ sender: UISlider) {
        
        currentBlurValue = Double(sender.value)
    }
    func updateHeight (heightNeedToBeRemoved: CGFloat) {
        widthForImv.constant = HolderView.frame.width
        heightForImv.constant = HolderView.frame.height - heightNeedToBeRemoved
        
        print(HolderView.frame.width)
        print(HolderView.frame.height)
        print(mainImage.size)
        print(malloc_size(Unmanaged.passUnretained(mainImage).toOpaque()))
        
        var size = AVMakeRect(aspectRatio: mainImage!.size, insideRect: CGRect(x: 0, y: 0, width:  widthForImv.constant, height:   heightForImv.constant))
        
        widthForImv.constant = size.width
        heightForImv.constant = size.height
    }
    
    func getFileUrlWithName(fileName: String) -> NSURL {
        var fileURL:NSURL!
        let fileManager = FileManager.default
        
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            fileURL = documentDirectory.appendingPathComponent(fileName as String) as NSURL
            
        } catch {
            Swift.print(error)
        }
        
        return  fileURL
    }
    
    func DoAdjustMent(inputImage: UIImage) {
        let context = CIContext(options: nil)
        if let currentFilter = CIFilter(name:"CIColorControls") {
            let beginImage = CIImage(image: inputImage)
            
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            currentFilter.setValue(Brightness, forKey: kCIInputBrightnessKey)
            currentFilter.setValue(Saturation, forKey: kCIInputSaturationKey)
            currentFilter.setValue(Contrast, forKey: kCIInputContrastKey)
            
            if let output = currentFilter.outputImage {
                if let cgimg = context.createCGImage(output, from: output.extent) {
                    let processedImage = UIImage(cgImage: cgimg)
                    self.sharpenValue(inputImage: processedImage)
                }
            }
        }
        
    }
    
    func sharpenValue (inputImage:UIImage) {
        let context = CIContext(options: nil)
        
        if let currentFilter = CIFilter(name:"CISharpenLuminance") {
            
            let beginImage = CIImage(image: inputImage)
            
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            currentFilter.setValue(sharpen, forKey: "inputSharpness")
            if let output = currentFilter.outputImage {
                if let cgimg = context.createCGImage(output, from: output.extent) {
                    let processedImage = UIImage(cgImage: cgimg)
                    self.hueAdjust(inputImage: processedImage)
                }
            }
        }
    }
    
    
    
    
    
    func hueAdjust(inputImage: UIImage) {
        let context = CIContext(options: nil)
        
        if let currentFilter = CIFilter(name: "CIHueAdjust") {
            let beginImage = CIImage(image: inputImage)
            
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            currentFilter.setValue(hue, forKey: "inputAngle")
            
            if let output = currentFilter.outputImage {
                if let cgimg = context.createCGImage(output, from: output.extent) {
                    let processedImage = UIImage(cgImage: cgimg)
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        if self.currentFilterDic != nil {
                            self.mainImv.image = getFilteredImage(withInfo: self.currentFilterDic, for: processedImage)
                            
                        } else if self.currentBlurValue > 0 {
                            self.mainImv.image = processedImage.blur(self.currentBlurValue)
                        }
                        else  {
                            // Memory warning
                            self.mainImv.image = processedImage
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func dismissColorPicker(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            
            self.bottomSpaceForColorPicker.constant = -10000
            self.bottomSpceOfMainView.constant = 0
            self.updateHeight(heightNeedToBeRemoved: 0)
            self.view.layoutIfNeeded()
            
        }, completion: {_ in
            
        })
        
    }
    
    @IBAction func gotoBri(_ sender: UISlider) {
        DispatchQueue.main.async {
            self.Brightness = sender.value
            self.DoAdjustMent(inputImage: self.mainImage)
        }
    }
    
    @IBAction func changeHue(_ sender: UISlider) {
        hue  = sender.value
        self.DoAdjustMent(inputImage: mainImage)
        
    }
    
    @IBAction func chnageSat(_ sender: UISlider) {
        Saturation = sender.value
        self.DoAdjustMent(inputImage: mainImage)
    }
    
    @IBAction func cont(_ sender: UISlider) {
        Contrast = sender.value
        self.DoAdjustMent(inputImage: mainImage)
        
    }
    
    @IBAction func sliderValueChnaged(_ sender: UISlider) {
        
        ov = sender.value
        transParentView.alpha = CGFloat(sender.value)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if !shouldRemove {
            return
        }
        DispatchQueue.main.async {
            for view in self.screenSortView.subviews{
                view.removeFromSuperview()
            }
            
        }
        shouldRemove = true
    }
    
    @IBAction func gotoSave(_ sender: Any) {
        DBmanager.shared.initDB()
        hideALL()
        imageInfoObj.Bri = "\(Brightness)"
        imageInfoObj.Sat = "\(Saturation)"
        imageInfoObj.Cont = "\(Contrast)"
        imageInfoObj.sh = "\(sharpen)"
        imageInfoObj.Hue =  "\(hue)"
        imageInfoObj.filter = "\(0)"
        imageInfoObj.ov = "\(ov)"
        imageInfoObj.OverLay = "\(currentOverlayIndex)"
        
        if isfromUpdate {
            DBmanager.shared.updateTableData(id: imageInfoObj.id, fileObj: imageInfoObj)
            DBmanager.shared.insertmergeFile(fileObj: imageInfoObj)
            let ma1 = DBmanager.shared.getMaxIdForMerge()
            
            let data = NSKeyedArchiver.archivedData(withRootObject: currentFilterDic ?? nil)
            let defaults = UserDefaults.standard
            defaults.set(data, forKey: "\(imageInfoObj.id)")
            
            let images = screenSortView.takeScreenshot()
            createFile(fileName: "FileNameS" + "\(imageInfoObj.id)" + ".jpg",cropImage: images.resizeImage(targetSize: CGSize(width: 300, height: 300)))
            
            for (index,view) in (screenSortView.subviews.filter{($0 is StickerView) || ($0 is TextStickerContainerView)}).enumerated(){
                print(index)
                
                switch view {
                case is StickerView:
                    //guard let ma = view as? StickerView else { return }
                    let ma = view as! StickerView
                    
                    let obj = StickerValueObj()
                    obj.pathName = ma.pathName ?? ""
                    obj.type = ma.pathType ?? ""
                    obj.x = "\(ma.transform.a)"
                    obj.y = "\(ma.transform.b)"
                    obj.inset = "\(ma.defaultInset)"
                    obj.opacity = "\(ma.opacity)"
                    obj.width = "\(ma.bounds.size.width)"
                    obj.height = "\(ma.bounds.size.height)"
                    obj.fileName = "\(imageInfoObj.id)"
                    obj.centerx = "\(ma.center.x)"
                    obj.centery = "\(ma.center.y)"
                    obj.saturation = "\(ma.saturation)"
                    obj.contrast = "\(ma.contrast)"
                    obj.sharpen = "\(ma.sharpen)"
                    obj.border = "\(ma.border)"
                    obj.brightness = "\(ma.brightness)"
                    
                    
                    print(obj)
                    if ma.tag > 0 {
                        DBmanager.shared.updateStickerData(id: "\(ma.tag)", fileObj: obj)
                    }
                    else {
                        DBmanager.shared.insertStickerile(fileObj: obj)
                    }
                    
                case is TextStickerContainerView:
                    let ma = view as! TextStickerContainerView
                    
                    let obj = StickerValueObj()
                    obj.pathName = ma.pathName ?? ""
                    obj.type = ma.pathType ?? ""
                    obj.x = "\(ma.transform.a)"
                    obj.y = "\(ma.transform.b)"
                    obj.inset = "\(11)"
                    
                    obj.width = "\(ma.bounds.size.width)"
                    obj.height = "\(ma.bounds.size.height)"
                    obj.fileName = "\(imageInfoObj.id)"
                    obj.centerx = "\(ma.center.x)"
                    obj.centery = "\(ma.center.y)"
                    
                    
                    let objV = TextInfoData()
                    objV.color = ma.currentColorSting
                    objV.file = obj.fileName
                    objV.text =  ma.textStickerView.text
                    objV.font = "\(ma.currentFontIndex)"
                    objV.texture = "\(ma.currentTextureIndex)"
                    objV.gradient = "\(ma.currentGradientIndex)"
                    objV.opacity = "\(ma.opacity)"
                    objV.shadow = "\(ma.shadow)"
                    objV.align = "\(ma.align)"
                    objV.rotate = "\(ma.rotate)"
                    objV.bcColor = "\(ma.bcColor)"
                    objV.bcGradient = "\(ma.bcGradient)"
                    objV.texture = "\(ma.bcTexture)"
                    
                    if let fontSize = ma.textStickerView?.fontSize {
                        objV.fontSize = "\(fontSize)"
                        
                    }
                    
                    
                    print("Sticker info: \(ma.tag)")
                    
                    
                    if ma.tag > 0 {
                        DBmanager.shared.updateStickerData(id: "\(ma.tag)", fileObj: obj)
                        DBmanager.shared.updateTextData(fileNAME: "\(ma.tag)", fileObj: objV)
                    }
                    else {
                        DBmanager.shared.insertStickerile(fileObj: obj)
                        var getMax = DBmanager.shared.getMaxIdForSticker()
                        objV.id = "\(getMax)"
                        DBmanager.shared.insertTextFile(fileObj: objV)
                    }
                default:
                    return
                }
            }
            
        }
        
        else {
            DBmanager.shared.insertmergeFile(fileObj: imageInfoObj)
            let ma1 = DBmanager.shared.getMaxIdForMerge()
            
            let data = NSKeyedArchiver.archivedData(withRootObject: currentFilterDic ?? nil)
            let defaults = UserDefaults.standard
            defaults.set(data, forKey: "\(ma1)")
            
            createFile(fileName: "FileName" + "\(ma1)" + ".jpg", cropImage: mainImage)
            let images = screenSortView.takeScreenshot()
            createFile(fileName: "FileNameS" + "\(ma1)" + ".jpg", cropImage: images)
            
            for (index, view) in screenSortView.subviews.filter({ ($0 is StickerView) || ($0 is TextStickerContainerView) }).enumerated() {
                print(index)
                
                switch view {
                case is StickerView:
                    //guard let ma = view as? StickerView else { return }
                    let ma = view as! StickerView
                    
                    let obj = StickerValueObj()
                    obj.pathName = ma.pathName ?? ""
                    obj.type = ma.pathType ?? ""
                    obj.x = "\(ma.transform.a)"
                    obj.y = "\(ma.transform.b)"
                    obj.inset = "\(ma.defaultInset)"
                    
                    obj.width = "\(ma.bounds.size.width)"
                    obj.height = "\(ma.bounds.size.height)"
                    obj.fileName = "\(ma1)"
                    obj.centerx = "\(ma.center.x)"
                    obj.centery = "\(ma.center.y)"
                    print("Sticker info: \(obj)")
                    obj.opacity = "\(ma.opacity)"
                    obj.saturation = "\(ma.saturation)"
                    obj.contrast = "\(ma.contrast)"
                    obj.sharpen = "\(ma.sharpen)"
                    obj.border = "\(ma.border)"
                    obj.brightness = "\(ma.brightness)"
                    DBmanager.shared.insertStickerile(fileObj: obj)
                    
                case is TextStickerContainerView:
                    let ma = view as! TextStickerContainerView
                    
                    let obj = StickerValueObj()
                    obj.pathName = ma.pathName ?? ""
                    obj.type = ma.pathType ?? ""
                    obj.x = "\(ma.transform.a)"
                    obj.y = "\(ma.transform.b)"
                    obj.inset = "\(11)"
                    
                    obj.width = "\(ma.bounds.size.width)"
                    obj.height = "\(ma.bounds.size.height)"
                    obj.fileName = "\(ma1)"
                    obj.centerx = "\(ma.center.x)"
                    obj.centery = "\(ma.center.y)"
                    print("Sticker info: \(obj)")
                    DBmanager.shared.insertStickerile(fileObj: obj)
                    
                    let getMax = DBmanager.shared.getMaxIdForSticker()
                    
                    
                    let objV = TextInfoData()
                    objV.color = ma.currentColorSting
                    objV.file = obj.fileName
                    objV.id = "\(getMax)"
                    objV.text =  ma.textStickerView.text
                    objV.font = "\(ma.currentFontIndex)"
                    objV.texture = "\(ma.currentTextureIndex)"
                    objV.gradient = "\(ma.currentGradientIndex)"
                    objV.opacity = "\(ma.opacity)"
                    objV.shadow = "\(ma.shadow)"
                    objV.align = "\(ma.align)"
                    objV.rotate = "\(ma.rotate)"
                    objV.bcColor = "\(ma.bcColor)"
                    objV.bcGradient = "\(ma.bcGradient)"
                    objV.bcTexture = "\(ma.bcTexture)"
                    
                    if let fontSize = ma.textStickerView?.fontSize {
                        objV.fontSize = "\(fontSize)"
                        
                    }
                    
                    DBmanager.shared.insertTextFile(fileObj: objV)
                    
                    
                default:
                    return
                }
            }
        }
        //self.perform(#selector(self.targetMethod), with: self, afterDelay: 2.0)
        
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
        
        
        
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        
    }
    
    @objc fileprivate func targetMethod(){
        self.view.window!.rootViewController?.dismiss(animated: true, completion: {
        })
        
    }
    
    @IBAction func gotoPreviousView(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            
        }
        
        guard var selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            
        }
        
        selectedImage = selectedImage.makeFixOrientation()
        selectedImage = selectedImage.resizeImage(targetSize: CGSize(width: 400, height: 400))
        
        
        
        var deletedMailsCount = UserDefaults.standard.integer(forKey: "Image")
        deletedMailsCount += 1;
        UserDefaults.standard.set(deletedMailsCount, forKey: "Image")
        UserDefaults.standard.synchronize()
        createFile(fileName: "Image" + "\(deletedMailsCount)", cropImage: selectedImage)
        addSticker(test: selectedImage, type: "Image", pathName: "Image" + "\(deletedMailsCount)")
        
        
        dismiss(animated: true) {
            self.bottomSpaceForImageViewHolder.constant = 0
        }
        
    }
    
    @objc func targetMethod1() {
        let totalCellWidth = cellWidth * CGFloat(plistArray2.count)
        let totalSpacingWidth = cellGap * CGFloat((plistArray2.count - 1))
        
        let leftInset = (btnCollectionView.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.minimumInteritemSpacing = cellGap
        layout.minimumLineSpacing = cellGap
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        btnCollectionView?.collectionViewLayout = layout
        
        layout.scrollDirection = .horizontal
        btnCollectionView?.reloadData()
        
        TextEditVc.frame = CGRect(x: 0,y: 0,width: textViewHolderView.frame.width,height: textViewHolderView.frame.height)
        TextEditVc.delegateForText = self
        textViewHolderView.addSubview(TextEditVc)
        
        
        filterVc.frame = CGRect(x: 0,y: 0,width: filterViewHolder.frame.width,height: filterViewHolder.frame.height)
        filterVc.delegateForFilter = self
        filterViewHolder.addSubview(filterVc)
        
        
        frameVc.frame = CGRect(x: 0,y: 0,width: frameVcHolder.frame.width,height: frameVcHolder.frame.height)
        frameVc.delegateForFramesr = self
        frameVcHolder.addSubview(frameVc)
        
        
        adjustVc.frame = CGRect(x: 0,y: 0,width: ajustVcHolder.frame.width,height: ajustVcHolder.frame.height)
        adjustVc.delegate = self
        ajustVcHolder.addSubview(adjustVc)
        
        
        stickerVc.frame = CGRect(x: 0,y: 0,width: stickerViewHolder.frame.width,height: stickerViewHolder.frame.height)
        stickerVc.delegateForSticker = self
        stickerViewHolder.addSubview(stickerVc)
        
        
        drawVc.frame = CGRect(x: 0,y: 0,width: drawHolderView.frame.width,height: drawHolderView.frame.height)
        drawHolderView.addSubview(drawVc)
        
        overLayVc.frame = CGRect(x: 0,y: 50,width: overLayVcHolder.frame.width,height: overLayVcHolder.frame.height-50)
        overLayVc.delegateForOverlay = self
        
        overLayVcHolder.addSubview(overLayVc)
        
        imageEditView.frame = CGRect(x: 0,y: 0,width: imageViewHolder.frame.width,height: imageViewHolder.frame.height)
        imageEditView.delegateForImage = self
        imageViewHolder.addSubview(imageEditView)
        
        
        shapeVc.frame = CGRect(x: 0,y: 0,width: shapeHolderView.frame.width,height: shapeHolderView.frame.height)
        shapeVc.delegateForShape = self
        shapeHolderView.addSubview(shapeVc)
        
    }
    
    func createFile(fileName: String,cropImage: UIImage) {
        
        
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            if let imageData = cropImage.jpegData(compressionQuality: 1.0) {
                try imageData.write(to: fileURL)
                
            }
        } catch {
            print(error)
        }
    }
    
    func processSnapShotPhotos () {
        
        DispatchQueue.main.async {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func updateValue () {
        UIView.animate(withDuration: 0.2, animations: { [self] in
            
            if self.currentlyActiveIndex != BtnNameInt.Frames.rawValue {
                self.bottomSpaceForFrame.constant = -1000
            }
            
            if self.currentlyActiveIndex != BtnNameInt.Blur.rawValue {
                self.bottomSpaceForBlur.constant = -1000
            }
            
            if self.currentlyActiveIndex != BtnNameInt.Texts.rawValue {
                self.bottomSpaceOfFontLoaderView.constant = -1000
            }
            if self.currentlyActiveIndex != BtnNameInt.Filter.rawValue {
                bottomSpaceForFilter.constant = -1000
            }
            if self.currentlyActiveIndex != BtnNameInt.Adjust.rawValue {
                bottomSpaceForAdjust.constant = -1000
            }
            if self.currentlyActiveIndex != BtnNameInt.Graphics.rawValue {
                bottomSpaceFoSticker.constant = -1000
            }
            if self.currentlyActiveIndex != BtnNameInt.Quotes.rawValue {
                bottomSpaceForDrawer.constant = -1000
            }
            
            if self.currentlyActiveIndex != BtnNameInt.Overlay.rawValue {
                bottomSpaceForOverlay.constant = -1000
            }
            if self.currentlyActiveIndex != BtnNameInt.Shape.rawValue {
                bottomSapceForShape.constant = -1000
            }
            if self.currentlyActiveIndex != BtnNameInt.Image.rawValue {
                bottomSpaceForImageViewHolder.constant = -1000
            }
            
            
            if currentlyActiveIndex >= 0 {
                if self.currentlyActiveIndex == BtnNameInt.Blur.rawValue {
                    self.bottomSpaceForBlur.constant = 0
                }
                if self.currentlyActiveIndex == BtnNameInt.Texts.rawValue {
                    self.bottomSpaceOfFontLoaderView.constant = 0
                }
                if self.currentlyActiveIndex == BtnNameInt.Filter.rawValue {
                    bottomSpaceForFilter.constant = 0
                }
                if self.currentlyActiveIndex == BtnNameInt.Adjust.rawValue {
                    bottomSpaceForAdjust.constant = 0
                }
                if self.currentlyActiveIndex == BtnNameInt.Graphics.rawValue {
                    bottomSpaceFoSticker.constant = 0
                }
                if self.currentlyActiveIndex == BtnNameInt.Quotes.rawValue {
                    bottomSpaceForDrawer.constant = 0
                }
                if self.currentlyActiveIndex == BtnNameInt.Overlay.rawValue {
                    bottomSpaceForOverlay.constant = 0
                }
                if self.currentlyActiveIndex == BtnNameInt.Shape.rawValue {
                    bottomSapceForShape.constant = 0
                }
                if self.currentlyActiveIndex == BtnNameInt.Frames.rawValue {
                    bottomSpaceForFrame.constant = 0
                }
                if self.currentlyActiveIndex == BtnNameInt.Image.rawValue {
                    bottomSpaceForImageViewHolder.constant = 0
                }
            }
            self.view.layoutIfNeeded()
            
        }, completion: {_ in
            
        })
    }
}

extension EditVc {
    struct SwiftUIView : View {
        @State private var isAnimating = false
        @State private var showProgress = false
        var foreverAnimation: Animation {
            Animation.linear(duration: 5.0)
                .repeatForever(autoreverses: false)
        }

        var body: some View {
            Button(action: { self.showProgress.toggle() }, label: {
                if showProgress {
                    Image("watermark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .rotation3DEffect(Angle.degrees(isAnimating ? 360 : 0), axis: (x: 1, y: 0, z: 0))
                        .animation(self.isAnimating ? foreverAnimation : .default)
                        .onAppear { self.isAnimating = true }
                        .onDisappear { self.isAnimating = false }
                } else {
                    Image("watermark")
                }
            })
            .onAppear { self.showProgress = true }
        }
    }
}

extension EditVc: TextStickerContainerViewDelegate {
    func showKeyBoard() {
        shouldRemove = false
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: TextEditViewController = storyboard.instantiateViewController(withIdentifier: "TextEditViewController") as! TextEditViewController
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
        
    }
    
    func moveViewPosition(textStickerContainerView: TextStickerContainerView) {
        
        print("mamamma")
    }
    
    func setCurrentTextStickerView(textStickerContainerView: TextStickerContainerView) {
        hideALL()
        currentTextStickerView = textStickerContainerView
        guard let textStickerView = currentTextStickerView else {
            print("[EditVC] currentTextStickerView is nill")
            return
        }
        
        textStickerView.deleteController.isHidden = false
        textStickerView.scaleController.isHidden = false
        textStickerView.extendBarView.isHidden = false
        textStickerView.hideTextBorder(isHide: false)
    }
    
    func editTextStickerView(textStickerContainerView: TextStickerContainerView) {
        print("EDIT TEXT DELEGATE")
        currentTextStickerView?.textStickerView.isUserInteractionEnabled = true
        currentTextStickerView?.textStickerView.isEditable = false
        currentTextStickerView?.textStickerView.becomeFirstResponder()
        
    }
    
    func deleteTextStickerView(textStickerContainerView: TextStickerContainerView) {
        //screenSortView.subviews
        currentTextStickerView?.removeFromSuperview()
    }
}

extension EditVc: sendSticker, imageIndexDelegate, filterIndexDelegate, sendShape {
    func filterNameWithIndex(dic: Dictionary<String, Any>?) {
        currentBlurValue = -1
        if let value =  dic {
            DispatchQueue.main.async { [self] in
                
                currentFilterDic = value
                self.DoAdjustMent(inputImage: mainImage)
            }
        }
        
    }
    
    func imageNameWithIndex(tag: String, image: UIImage) {
        
        _ = image
        currentOverlayIndex = Int(tag) ?? 0
        
        
        if currentOverlayIndex  == -1 {
            transParentView.isHidden = true
        }
        
        DispatchQueue.main.async {
            self.overLaySlider.setValue(self.ov, animated: true)
            self.transParentView.alpha = CGFloat(self.ov)
            if self.currentOverlayIndex == 0 {
                self.transParentView.isHidden = true
            } else{
                self.transParentView.isHidden = false
            }
        }
        
        DispatchQueue.main.async {
            self.transParentView.image = image
        }
    }
    
    func sendSticker(sticker: String) {
        guard let image = UIImage(named: sticker) else { return }
        addSticker(test: image, type: "STICKER", pathName: sticker)
    }
    
    func addSticker(test: UIImage, type: String, pathName: String) {
        let testImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        testImage.image = test
        
        let stickerView3 = StickerView.init(contentView: testImage)
        stickerView3.backgroundColor = UIColor.clear
        stickerView3.center = CGPoint.init(x: 50, y: 50)
        stickerView3.delegate = self
        stickerView3.setImage(UIImage.init(named: "Close")!, forHandler: StickerViewHandler.close)
        stickerView3.setImage(UIImage.init(named: "Rotate")!, forHandler: StickerViewHandler.rotate)
        stickerView3.setImage(UIImage.init(named: "Flip")!, forHandler: StickerViewHandler.flip)
        stickerView3.showEditingHandlers = false
        stickerView3.pathName = pathName
        stickerView3.pathType = type
        stickerView3.tag = -1
        screenSortView.addSubview(stickerView3)
        screenSortView.clipsToBounds = true
        stickerView3.showEditingHandlers = true
        
        tagValue = tagValue + 1
        
        hideALL()
        
        stickerView3.showEditingHandlers = true
        
        
        
    }
    
    func hideALL() {
        
        
        currentStickerView = nil
        for (index,view) in (screenSortView.subviews.filter{($0 is StickerView) || ($0 is TextStickerContainerView)}).enumerated(){
            switch view {
            case is StickerView:
                //guard let ma = view as? StickerView else { return }
                let ma = view as! StickerView
                ma.showEditingHandlers = false
            case is TextStickerContainerView:
                let ma = view as! TextStickerContainerView
                ma.deleteController.isHidden = true
                ma.scaleController.isHidden = true
                ma.extendBarView?.isHidden = true
                ma.hideTextBorder(isHide: true)
            default:
                break
            }
            
        }
    }
    
    func colorIndex(tag: Int, colorV: UIColor) {
        
    }
    func sendShape(sticker: String) {
        self.addSticker(test: UIImage(named: sticker) ?? UIImage(), type: "shape", pathName: sticker)
    }
    
}

extension EditVc: StickerViewDelegate,quotesDelegate {
    func sendText1(text: String) {
        self.addText(text: text, font: UIFont.systemFont(ofSize: 20.0))
    }
    
    func stickerViewDidBeginMoving(_ stickerView: StickerView) {
        currentStickerView = stickerView
        stickerView.showEditingHandlers = true
    }
    func stickerViewDidChangeMoving(_ stickerView: StickerView) {
        currentStickerView = stickerView
        stickerView.showEditingHandlers = true
        
    }
    func stickerViewDidEndMoving(_ stickerView: StickerView) {
        currentStickerView = stickerView
        stickerView.showEditingHandlers = true
    }
    func stickerViewDidBeginRotating(_ stickerView: StickerView) {
        currentStickerView = stickerView
        stickerView.showEditingHandlers = true
    }
    func stickerViewDidChangeRotating(_ stickerView: StickerView) {
        currentStickerView = stickerView
        stickerView.showEditingHandlers = true
    }
    func stickerViewDidEndRotating(_ stickerView: StickerView) {
        currentStickerView = stickerView
        stickerView.showEditingHandlers = true
    }
    func stickerViewDidClose(_ stickerView: StickerView) {
        
    }
    func stickerViewDidTap(_ stickerView: StickerView) {
        hideALL()
        currentStickerView = stickerView
        stickerView.showEditingHandlers = true
    }
}


