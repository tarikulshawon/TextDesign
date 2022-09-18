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

protocol callDelegate: AnyObject {
    func reloadAllData()
}

class EditVc: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var screenSortView: UIView!
    @IBOutlet weak var overLayVcHolder: UIView!
    @IBOutlet weak var drawHolderView: UIView!
    @IBOutlet weak var filterViewHolder: UIView!
    @IBOutlet weak var stickerViewHolder: UIView!
    @IBOutlet weak var HolderView: UIView!
    @IBOutlet weak var textViewHolderView: UIView!
    @IBOutlet weak var imageViewHolder: UIView!
    @IBOutlet weak var shapeHolderView: UIView!
    
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
    
    @IBOutlet weak var slider1: UISlider!
    @IBOutlet weak var slider2: UISlider!
    @IBOutlet weak var slider3: UISlider!
    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    
    @IBOutlet weak var transParentView: UIImageView!
    var currentTextStickerView: TextStickerContainerView?
    var imageInfoObj = ImageInfoData()
    weak var delegateFor: callDelegate?
    var stickerObjList = [StickerValueObj]()
    
    var isfromUpdate = false
    var currentlyActiveIndex = -1
    var currentFilterIndex = 0
    var cellWidth:CGFloat = 60
    var cellGap:CGFloat =  0
    var ov:Float =  0.3
    var currentLookUpindex = 0
    var plistArray2:NSArray!
    var mainImage:UIImage!
    
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
    
    var currentOverlayIndex = 0
    var tagValue = 1000000
    
    
    @IBOutlet weak var bottomSpaceForBackGroundView: NSLayoutConstraint!
    @IBOutlet weak var btnCollectionView: UICollectionView!
    @IBOutlet weak var mainImv: UIImageView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var overLaySlider: CustomSlider!
    var currentBackGroundIndex  = 0
    
    let TextEditVc: TextEditView = TextEditView.loadFromXib()
    let filterVc =  Bundle.main.loadNibNamed("FilterVc", owner: nil, options: nil)![0] as! FilterVc
    let overLayVc = Bundle.main.loadNibNamed("OverLayVc", owner: nil, options: nil)![0] as! OverLayVc
    let shapeVc = Bundle.main.loadNibNamed("ShapeVc", owner: nil, options: nil)![0] as! ShapeVc
    let stickerVc = Bundle.main.loadNibNamed("StickerVc", owner: nil, options: nil)![0] as! StickerVc
    let imageEditView = Bundle.main.loadNibNamed("ImageEditView", owner: nil, options: nil)![0] as! ImageEditView
    let drawVc =  Bundle.main.loadNibNamed("DrawVc", owner: nil, options: nil)![0] as! DrawVc
    
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainImv.image = mainImage
        mainImv.contentMode = .scaleAspectFit
        
        if isfromUpdate {
            saveBtn.setTitle("Update", for: .normal)
        } else {
            saveBtn.setTitle("Save", for: .normal)
        }
        saveBtn.setTitleColor(titleColor, for: .normal)
        slider1.maximumTrackTintColor = unselectedColor
        slider1.minimumTrackTintColor = titleColor
        slider2.maximumTrackTintColor = unselectedColor
        slider2.minimumTrackTintColor = titleColor
        slider3.maximumTrackTintColor = unselectedColor
        slider3.minimumTrackTintColor = titleColor
        lbl1.textColor = unselectedColor
        lbl2.textColor = unselectedColor
        lbl3.textColor = unselectedColor
        
        DoAdjustMent(inputImage: mainImage)
        
        if isfromUpdate {
            stickerObjList = DBmanager.shared.getStickerInfo(fileName: imageInfoObj.id)
            
            for item in stickerObjList {
                updateSticker(obj: item)
            }
            
            Brightness = imageInfoObj.Bri.floatValue
            Saturation = imageInfoObj.Sat.floatValue
            Contrast = imageInfoObj.Cont.floatValue
            currentFilterIndex = Int(imageInfoObj.filter) ?? 0
            currentOverlayIndex = Int(imageInfoObj.OverLay) ?? 0
            ov = imageInfoObj.ov.floatValue
        }
        
        slider1.maximumValue = max_brightness
        slider1.minimumValue = min_brightness;
        slider1.value = Brightness
        
        slider2.maximumValue = max_saturation
        slider2.minimumValue = min_saturation
        slider2.value = Saturation
        
        slider3.maximumValue = max_contrast
        slider3.maximumValue = min_contrast
        slider3.value = Contrast
        
        let emptyAutomationsCell = RatioCell.nib
        btnCollectionView?.register(emptyAutomationsCell, forCellWithReuseIdentifier: RatioCell.reusableID)
        
        let nibName = UINib(nibName: ColorCell.reusableID, bundle: nil)
        collectionViewForBackGround.register(nibName, forCellWithReuseIdentifier:  ColorCell.reusableID)
        
        let path = Bundle.main.path(forResource: "btn", ofType: "plist")
        plistArray2 = NSArray(contentsOfFile: path!)
        self.perform(#selector(self.targetMethod1), with: self, afterDelay:0.1)
        
        if isfromUpdate {
            self.DoAdjustMent(inputImage: mainImage)
            overLayVc.delegateForOverlay = self
            overLayVc.setOverLay(index: currentOverlayIndex)
            transParentView.alpha = CGFloat(ov)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        widthForImv.constant = HolderView.frame.width
        heightForImv.constant = HolderView.frame.height
        
        print(HolderView.frame.width)
        print(HolderView.frame.height)
        print(mainImage.size)
        
        
        var size = AVMakeRect(aspectRatio: mainImage!.size, insideRect: HolderView.frame)
        
        widthForImv.constant = size.width
        heightForImv.constant = size.height
        
        print(size.width)
        print(size.height)
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
    
    
    func updateSticker(obj: StickerValueObj) {
        let id = obj.id.floatValue
        let type1 = obj.type
        let x = obj.x.floatValue
        let y = obj.y.floatValue
        let width = obj.width.floatValue
        let height = obj.height.floatValue
        let inset = obj.inset.floatValue
        var pathName = obj.pathName
        let centerx = obj.centerx
        let centery = obj.centery
        let radians = atan2(CGFloat(y), CGFloat(x))
        _ = radians * 180 / .pi
        let center = CGPoint(x: Double(centerx) ?? 0, y: Double(centery) ?? 0)
        let size = CGSize(width: CGFloat(width), height: CGFloat(height))
        let padding = CGFloat(CGFloat(inset)) * 2.0
        let testImage = UIImageView(frame: CGRect(x: 0, y: 0, width: size.width - padding, height: size.height - padding))
        testImage.center = center
        testImage.image = UIImage(named: pathName)
        
        if type1.contains("Image") {
            var lol  = getFileUrlWithName(fileName: pathName)
            if let data = try? Data(contentsOf: lol as URL) {
                if let image = UIImage(data: data) {
                    testImage.image = image
                }
            }
        }
        
        if type1.contains("TEXT") {
            let textObj = DBmanager.shared.getTextInfo(id: obj.id)
            let frame = CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height))
            let sticker = TextStickerContainerView(frame: frame)
            sticker.center = center
            sticker.tag = Int(id)
            sticker.delegate = self
            
            sticker.textStickerView.text = textObj.text
            sticker.textStickerView.font = UIFont(name: pathName, size: 15)
            
            let fontIndex = Int(textObj.font)!
            
            let fontSize = Double(textObj.fontSize)!
            if fontIndex < 0 {
                sticker.textStickerView.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
            }
            else {
                sticker.textStickerView.font =  UIFont(
                    name: arrayForFont[fontIndex] as! String,
                    size: CGFloat(fontSize)
                )
            }
            sticker.fontSize = fontSize
            sticker.currentFontIndex = fontIndex
            
            if textObj.color.count > 1 {
                sticker.textStickerView.textColor = getColor(colorString: textObj.color)
                sticker.currentColorSting = textObj.color
                sticker.currentGradientIndex = -1
                sticker.currentTextureIndex = -1
            }
            let textureIndex = Int(textObj.texture)!
            let gradientIndex = Int(textObj.gradient)!
            
            if textureIndex >= 0 {
                var value =  "Texture" + String(textureIndex) + ".png"
                sticker.textStickerView.textColor = UIColor(patternImage: UIImage(named: value)!)
                sticker.currentColorSting = ""
                sticker.currentGradientIndex = -1
                sticker.currentTextureIndex = textureIndex
            }
            
            if gradientIndex >= 0 {
                if let objArray = plistArray1[gradientIndex] as? NSArray {
                    var allcolors: [CGColor] = []
                    for item in objArray {
                        let color = getColor(colorString: item as? String ?? "")
                        allcolors.append(color.cgColor)
                    }
                    
                    let uimage = UIImage.gradientImageWithBounds(bounds: CGRect(x: 0,y: 0,width: 200,height: 200), colors: allcolors)
                    sticker.textStickerView.textColor = UIColor(patternImage: uimage)
                }
                sticker.currentColorSting = ""
                sticker.currentGradientIndex = gradientIndex
                sticker.currentTextureIndex = -1
            }
            
            
            
            sticker.textStickerView.updateTextFont()
            sticker.transform = sticker.transform.rotated(by: radians)
            
            sticker.initilizeTextStickerData(mainTextView: sticker.textStickerView)
            sticker.tag = Int(id)
            screenSortView.addSubview(sticker)
            screenSortView.clipsToBounds = true
        } else {
            
            let stickerView3 = StickerView.init(contentView: testImage)
            
            stickerView3.backgroundColor = UIColor.clear
            stickerView3.center = center
            stickerView3.delegate = self
            stickerView3.setImage(UIImage.init(named: "Close")!, forHandler: StickerViewHandler.close)
            stickerView3.setImage(UIImage.init(named: "Rotate")!, forHandler: StickerViewHandler.rotate)
            stickerView3.setImage(UIImage.init(named: "Flip")!, forHandler: StickerViewHandler.flip)
            stickerView3.showEditingHandlers = false
            stickerView3.tag = Int(id)
            
            stickerView3.transform = stickerView3.transform.rotated(by: radians)
            stickerView3.clipsToBounds = true
            screenSortView.clipsToBounds  = true
            screenSortView.addSubview(stickerView3)
            stickerView3.showEditingHandlers = true
        }
    }
    
    
    func  DoAdjustMent (inputImage:UIImage) {
        var tempImage = inputImage
        
        if currentFilterIndex > 0 {
            guard let image = UIImage(named: "Filter" + "\(currentFilterIndex)") else { return  }
            tempImage = doFilter(mainImage: tempImage, lookupImage: image)
        } else {
            tempImage = inputImage
        }
        
        
        // var lol = CIImage(cgImage: inputImage.cgImage)
        
        if let value =  tempImage.cgImage {
            
            let imageFromCGImage = MTIImage(cgImage: value, isOpaque: true)
            let outputImage = imageFromCGImage.adjusting(contrast: Contrast).adjusting(brightness: Brightness).adjusting(saturation: Saturation)
            
            if let device = MTLCreateSystemDefaultDevice() {
                do {
                    let context = try MTIContext(device: device)
                    let filteredImage = try context.makeCGImage(from: outputImage)
                    mainImv.image = UIImage(cgImage: filteredImage)
                    
                } catch {
                    print(error)
                }
                
            }
            
        }
        
        
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
    
    @IBAction func gotoSave(_ sender: Any) {
        DBmanager.shared.initDB()
        
        imageInfoObj.Bri = "\(Brightness)"
        imageInfoObj.Sat = "\(Saturation)"
        imageInfoObj.Cont = "\(Contrast)"
        imageInfoObj.filter = "\(currentFilterIndex)"
        imageInfoObj.ov = "\(ov)"
        imageInfoObj.OverLay = "\(currentOverlayIndex)"
        
        if isfromUpdate {
            DBmanager.shared.updateTableData(id: imageInfoObj.id, fileObj: imageInfoObj)
            let images = screenSortView.takeScreenshot()
            createFile(fileName: "FileNameS" + "\(imageInfoObj.id)" + ".jpg",cropImage: images)
            
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
                    
                    obj.width = "\(ma.bounds.size.width)"
                    obj.height = "\(ma.bounds.size.height)"
                    obj.fileName = "\(imageInfoObj.id)"
                    obj.centerx = "\(ma.center.x)"
                    obj.centery = "\(ma.center.y)"
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
                    
                    if let fontSize = ma.textStickerView?.fontSize {
                        objV.fontSize = "\(fontSize)"

                    }
                    
                    
                    print("Sticker info: \(ma.tag)")
                    
                    
                    if ma.tag > 0 {
                        DBmanager.shared.updateStickerData(id: "\(ma.tag)", fileObj: obj)
                        DBmanager.shared.updateTextData(fileNAME: obj.id, fileObj: objV)
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
                    
                    var getMax = DBmanager.shared.getMaxIdForSticker()
                  

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
                    
                    if let fontSize = ma.textStickerView?.fontSize {
                        objV.fontSize = "\(fontSize)"

                    }
                    
                    DBmanager.shared.insertTextFile(fileObj: objV)
                    
                    
                default:
                    return
                }
            }
        }
        
        
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
        
        self.view.window!.rootViewController?.dismiss(animated: true, completion: {
            
        })
        
        //self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        
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
        let rightInset = leftInset
        
        
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
        
        
        stickerVc.frame = CGRect(x: 0,y: 0,width: stickerViewHolder.frame.width,height: stickerViewHolder.frame.height)
        stickerVc.delegateForSticker = self
        stickerViewHolder.addSubview(stickerVc)
        
        drawVc.frame = CGRect(x: 0,y: 0,width: drawHolderView.frame.width,height: drawHolderView.frame.height)
        drawHolderView.addSubview(drawVc)
        
        overLayVc.frame = CGRect(x: 0,y: 50,width: overLayVcHolder.frame.width,height: overLayVcHolder.frame.height-50)
        overLayVc.delegateForOverlay = self
        
        overLayVcHolder.addSubview(overLayVc)
        
        imageEditView.frame = CGRect(x: 0,y: 0,width: imageViewHolder.frame.width,height: imageViewHolder.frame.height)
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
            
            
            if currentlyActiveIndex >= 0 {
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
            }
            self.view.layoutIfNeeded()
            
        }, completion: {_ in
            
        })
    }
    
    
}
extension EditVc:UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 60, height: 60)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewForBackGround {
            if currentBackGroundIndex == 0 {
                return plistArray.count + 1
            }
        }
        
        return plistArray2.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionViewForBackGround {
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ColorCell.reusableID,
                for: indexPath) as? ColorCell else {
                return ColorCell()
            }
            
            if currentBackGroundIndex == 0 {
                cell.gradietImv.isHidden = true
                
                if indexPath.row == 0 {
                    cell.gradietImv.image = UIImage(named: "ColorPicker")
                    cell.gradietImv.isHidden = false
                    cell.holderView.backgroundColor = UIColor.clear
                }
                else if let colorString = plistArray[indexPath.row] as? String {
                    cell.holderView.backgroundColor = getColor(colorString: colorString)
                    cell.gradietImv.isHidden = true
                }
            }
            
            
            if currentBackGroundIndex == 1 {
                
                cell.gradietImv.image = nil
                cell.gradietImv.isHidden = false
                if let objArray = plistArray1[indexPath.row] as? NSArray {
                    var allcolors: [CGColor] = []
                    for item in objArray {
                        let color = getColor(colorString: item as? String ?? "")
                        allcolors.append(color.cgColor)
                    }
                    
                    let uimage = UIImage.gradientImageWithBounds(bounds: CGRect(x: 0,y: 0,width: 200,height: 200), colors: allcolors)
                    cell.gradietImv.contentMode = .scaleAspectFill
                    cell.gradietImv.image = uimage
                    
                    
                }
            }
            
            if currentBackGroundIndex == 2 {
                cell.gradietImv.isHidden = false
                cell.gradietImv.image = UIImage(named: "Texture" + "\(indexPath.row)")
            }
            cell.layer.cornerRadius = cell.frame.height/2.0
            return cell
            
        }
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RatioCell.reusableID,
            for: indexPath) as? RatioCell else {
            return RatioCell()
        }
        
        
        cell.iconImv.contentMode = .scaleAspectFit
        cell.iconLabel.textColor = unselectedColor
        cell.heightForLabel.constant = 20.0
        cell.backgroundColor = UIColor.clear
        
        if let value = plistArray2[indexPath.row] as? String  {
            
            print(value)
            cell.iconImv.image = UIImage(named: value)?.withRenderingMode(.alwaysTemplate)
            if indexPath.row == currentlyActiveIndex {
                cell.iconImv.tintColor = titleColor
                cell.iconLabel.textColor = titleColor
            } else {
                cell.iconImv.tintColor = unselectedColor
                cell.iconLabel.textColor = unselectedColor
            }
            
            cell.iconLabel.text = value
        }
        
        // cell.textLabel.textColor = unselectedColor
        
        //cell.backgroundColor = UIColor.red
        return cell
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        
        if collectionView == collectionViewForBackGround {
            
            if currentBackGroundIndex == 0 {
                
                if let colorString = plistArray[indexPath.row] as? String {
                    currentTextStickerView?.backgroundColor = getColor(colorString: colorString)
                }
                
            }
            if currentBackGroundIndex == 1 {
                
                if let objArray = plistArray1[indexPath.row] as? NSArray {
                    var allcolors: [CGColor] = []
                    for item in objArray {
                        let color = getColor(colorString: item as? String ?? "")
                        allcolors.append(color.cgColor)
                    }
                    
                    let uimage = UIImage.gradientImageWithBounds(bounds: CGRect(x: 0,y: 0,width: 200,height: 200), colors: allcolors)
                    currentTextStickerView?.backgroundColor = UIColor(patternImage: uimage)
                    
                }
                
            }
            return
        }
        let cell = collectionView.cellForItem(at: indexPath) as? RatioCell
        
        if collectionView != collectionViewForBackGround {
            UIView.animate(withDuration: 0.2, animations: {
                self.bottomSpaceForBackGroundView.constant = -1000
                self.view.layoutIfNeeded()
            }, completion: {_ in
            })
        }
        
        // cell?.iconImv.tintColor = UIColor.red
        if let btnValue = cell?.iconLabel.text {
            if btnValue == BtnName.Texts.rawValue {
                
                let p = self.bottomSpaceOfFontLoaderView.constant < 0 ? 0 : -1000
                
                if p == 0 {
                    currentlyActiveIndex = BtnNameInt.Texts.rawValue
                    let font = currentTextStickerView?.textView?.font ?? .systemFont(ofSize: 15.0)
                    self.addText(text: "ADD TEXT TO EDIT", font: font)
                } else {
                    currentlyActiveIndex = -1
                }
            }
            
            if btnValue == BtnName.Adjust.rawValue {
                let p = self.bottomSpaceForAdjust.constant < 0 ? 0 : -1000
                
                if p == 0 {
                    currentlyActiveIndex = BtnNameInt.Adjust.rawValue
                } else {
                    currentlyActiveIndex = -1
                }
                
            }
            if btnValue == BtnName.Filter.rawValue {
                let p = self.bottomSpaceForFilter.constant < 0 ? 0 : -1000
                
                if p == 0 {
                    currentlyActiveIndex = BtnNameInt.Filter.rawValue
                } else {
                    currentlyActiveIndex = -1
                }
                
            }
            if btnValue == BtnName.Graphics.rawValue {
                let p = self.bottomSpaceFoSticker.constant < 0 ? 0 : -1000
                
                if p == 0 {
                    currentlyActiveIndex = BtnNameInt.Graphics.rawValue
                } else {
                    currentlyActiveIndex = -1
                }
                
            }
            
            if btnValue == BtnName.Quotes.rawValue {
                let p = self.bottomSpaceForDrawer.constant < 0 ? 0 : -1000
                
                if p == 0 {
                    currentlyActiveIndex = BtnNameInt.Quotes.rawValue
                } else {
                    currentlyActiveIndex = -1
                }
                
            }
            
            if btnValue == BtnName.Overlay.rawValue {
                let p = self.bottomSpaceForOverlay.constant < 0 ? 0 : -1000
                
                if p == 0 {
                    currentlyActiveIndex = BtnNameInt.Overlay.rawValue
                } else {
                    currentlyActiveIndex = -1
                }
                
            }
            if btnValue == BtnName.Image.rawValue {
                currentlyActiveIndex = BtnNameInt.Image.rawValue
                self.processSnapShotPhotos()
                
                
            }
            
            if btnValue == BtnName.Shape.rawValue {
                let p = self.bottomSapceForShape.constant < 0 ? 0 : -1000
                
                if p == 0 {
                    currentlyActiveIndex = BtnNameInt.Shape.rawValue
                } else {
                    currentlyActiveIndex = -1
                }
                
            }
            
            updateValue()
            
        }
        collectionView.reloadData()
    }
}

// Delegate for AddText
extension EditVc: AddTextDelegate {
    func showBackground() {
        UIView.animate(withDuration: 0.2, animations: {
            self.bottomSpaceForBackGroundView.constant = 0
            self.view.layoutIfNeeded()
        }, completion: {_ in
        })
    }
    
    func addText() {
        self.addText(text: "Add Text", font: .systemFont(ofSize: 30.0))
    }
    
    func sendTextureIndex(index: Int) {
        let value =  "Texture" + String(index) + ".png"
        currentTextStickerView?.textStickerView.textColor = UIColor(patternImage: UIImage(named: value)!)
        currentTextStickerView?.currentColorSting = ""
        currentTextStickerView?.currentGradientIndex = -1
        currentTextStickerView?.currentTextureIndex = index
    }
    
    func sendFonrIndex(index: Int) {
        let fontSize = currentTextStickerView?.textStickerView?.fontSize
        currentTextStickerView?.textStickerView.font =  UIFont(
            name: arrayForFont[index] as! String,
            size: fontSize!
        )
        currentTextStickerView?.currentFontIndex = index
        
    }
    
    func gradientValue(index: Int) {
        
        if let objArray = plistArray1[index] as? NSArray {
            var allcolors: [CGColor] = []
            for item in objArray {
                let color = getColor(colorString: item as? String ?? "")
                allcolors.append(color.cgColor)
            }
            
            let uimage = UIImage.gradientImageWithBounds(bounds: CGRect(x: 0,y: 0,width: 200,height: 200), colors: allcolors)
            currentTextStickerView?.textStickerView.textColor = UIColor(patternImage: uimage)
            currentTextStickerView?.currentGradientIndex = index
            currentTextStickerView?.currentColorSting = ""
            currentTextStickerView?.currentTextureIndex = -1
        }
        
        
    }
    
    func colorValue(color: String) {
        currentTextStickerView?.textStickerView.textColor =  getColor(colorString: color)
        currentTextStickerView?.currentColorSting = color
        currentTextStickerView?.currentGradientIndex = -1
        currentTextStickerView?.currentTextureIndex = -1
    }
    
    func addText(text: String, font: UIFont) {
        print("[AddText] delegate called")
        let frame = CGRect(x: 0, y: 0, width: 160, height: 200)
        let sticker = TextStickerContainerView(frame: frame)
        sticker.tag = tagValue + 7 // TODO: implement in alternative way
        sticker.delegate = self
        sticker.currentFontIndex = -1
        
        sticker.pathName = font.fontName //
        sticker.pathType = "TEXT"
        
        //sticker.textStickerView.delegate = self
        sticker.textStickerView.text = text
        sticker.textStickerView.font = font
        
        sticker.textStickerView.updateTextFont()
        sticker.initilizeTextStickerData(mainTextView: sticker.textStickerView)
        
        screenSortView.addSubview(sticker)
        screenSortView.clipsToBounds = true
        tagValue = -1
        currentTextStickerView = sticker
    }
}

extension EditVc: TextStickerContainerViewDelegate {
    func moveViewPosition(textStickerContainerView: TextStickerContainerView) {
        // TODO
    }
    
    func setCurrentTextStickerView(textStickerContainerView: TextStickerContainerView) {
        currentTextStickerView = textStickerContainerView
        
    }
    
    func editTextStickerView(textStickerContainerView: TextStickerContainerView) {
        // TODO
        for view in screenSortView.subviews where view is TextStickerContainerView {
            if view.tag == textStickerContainerView.tag {
                print("[EditVC] Edit text delegate called")
                let v = view as! TextStickerContainerView
                v.textStickerView.isUserInteractionEnabled = true
                v.textStickerView.isEditable = true
                v.textStickerView.becomeFirstResponder()
            }
        }
    }
    
    func deleteTextStickerView(textStickerContainerView: TextStickerContainerView) {
        //screenSortView.subviews
        for view in screenSortView.subviews where view is TextStickerContainerView {
            if view.tag == textStickerContainerView.tag {
                print("[EditVC] add text deleted ")
                view.removeFromSuperview()
            }
        }
    }
}

extension EditVc: sendSticker, imageIndexDelegate, filterIndexDelegate, sendShape {
    func imageNameWithIndex(tag: String, image: UIImage) {
        
        var imagF = image
        currentOverlayIndex = Int(tag) ?? 0
        
        
        if currentOverlayIndex  == 0 {
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
        guard var image = UIImage(named: sticker) else { return }
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
    }
    
    func colorIndex(tag: Int, colorV: UIColor) {
        
    }
    
    func filterNameWithIndex(tag: String, image: UIImage) {
        currentFilterIndex = Int(tag) ?? 0
        var tempImage:UIImage!
        DoAdjustMent(inputImage: mainImage)
        
    }
    
    func sendShape(sticker: String) {
        self.addSticker(test: UIImage(named: sticker) ?? UIImage(), type: "shape", pathName: sticker)
    }
    
}


extension EditVc: StickerViewDelegate {
    
    func stickerViewDidBeginMoving(_ stickerView: StickerView) {
        
    }
    
    func stickerViewDidChangeMoving(_ stickerView: StickerView) {
        
    }
    
    func stickerViewDidEndMoving(_ stickerView: StickerView) {
        
    }
    
    func stickerViewDidBeginRotating(_ stickerView: StickerView) {
        
    }
    
    func stickerViewDidChangeRotating(_ stickerView: StickerView) {
        
    }
    
    func stickerViewDidEndRotating(_ stickerView: StickerView) {
        
    }
    
    func stickerViewDidClose(_ stickerView: StickerView) {
        
    }
    
    func stickerViewDidTap(_ stickerView: StickerView) {
        
    }
    
    
}

extension UIView {
    
    func takeScreenshot() -> UIImage {
        
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
}

extension UIImage {
    func makeFixOrientation() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage;
    }
}
extension UIImage {
    
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

