//
//  EditViewController + Extension.swift
//  TextArt
//
//  Created by tarikul shawon on 26/9/22.
//

import Foundation
import UIKit

extension EditVc {
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
            let align = Int(textObj.align)!
            
            if align == 0 {
                sticker.textStickerView.textAlignment = .left
            }
            if align == 1 {
                sticker.textStickerView.textAlignment = .center
            }
            if align == 2 {
                sticker.textStickerView.textAlignment = .right
            }
            if align == 0 {
                sticker.textStickerView.textAlignment = .justified
            }

            
            let fontSize = Double(textObj.fontSize)!
            let bacground = textObj.bcColor
            let gradient = Int(textObj.bcGradient)!
            let texture = Int(textObj.bcTexture)!
            
            if texture >= 0 {
                var value =  "Texture" + String(texture) + ".png"
                sticker.backgroundColor = UIColor(patternImage: UIImage(named: value)!)
            }
            
            if gradient >= 0 {
                
                  if let objArray = plistArray1[gradient] as? NSArray {
                    var allcolors: [CGColor] = []
                    for item in objArray {
                        let color = getColor(colorString: item as? String ?? "")
                        allcolors.append(color.cgColor)
                    }
                    
                    let uimage = UIImage.gradientImageWithBounds(bounds: CGRect(x: 0,y: 0,width: 200,height: 200), colors: allcolors)
                    sticker.backgroundColor = UIColor(patternImage: uimage)
                    sticker.bcGradient = gradient
                    
                    
                }
            }
            
            if bacground.count > 1 {
                
                sticker.backgroundColor = getColor(colorString: bacground)
                sticker.hideTextBorder(isHide: true)
            }

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
            var opacityValue = Double(textObj.opacity)
            
            if opacityValue != -1 {
                sticker.textStickerView.alpha = opacityValue ?? 1.0
            }
            
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
}

// Delegate for AddText
extension EditVc: AddTextDelegate {
    func showColorPickerView() {
        self.updateHeight(heightNeedToBeRemoved: self.heightForColorPickerView.constant)
        UIView.animate(withDuration: 0.2, animations: {
    
            self.bottomSpaceForColorPicker.constant = 0
            self.bottomSpceOfMainView.constant = self.heightForColorPickerView.constant
            self.view.layoutIfNeeded()
            
        }, completion: {_ in
            
        })
    }
    
    func sendOpacityValue(value: Double) {
        currentTextStickerView?.textStickerView.alpha = value
        currentTextStickerView?.opacity =  value
    }
    
    func setAlighnMent(index: Int) {
        if index == 0 {
            currentTextStickerView?.textStickerView.textAlignment = .left
            currentTextStickerView?.align = 0
        }
        if index == 1 {
            currentTextStickerView?.textStickerView.textAlignment = .center
            currentTextStickerView?.align = 1
        }
        if index == 2 {
            currentTextStickerView?.textStickerView.textAlignment = .right
            currentTextStickerView?.align = 2
        }
        if index == 3 {
            currentTextStickerView?.textStickerView.textAlignment = .justified
            currentTextStickerView?.align = 3
        }
     
         
    }
    
    func showBackground() {
        UIView.animate(withDuration: 0.2, animations: {
            self.bottomSpaceForBackGroundView.constant = 0
            self.view.layoutIfNeeded()
        }, completion: {_ in
        })
    }
    
    func addText() {
        self.hideALL()
        self.showKeyBoard()
        self.addText(text: "Double Tap to edit", font: .systemFont(ofSize: 20.0))
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
        // Update Frame
        currentTextStickerView?.scaleController.updateFrame()
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
                
        if isFromTextColor {
            currentTextStickerView?.textStickerView.textColor =  getColor(colorString: color)
            currentTextStickerView?.currentColorSting = color
            currentTextStickerView?.currentGradientIndex = -1
            currentTextStickerView?.currentTextureIndex = -1
        }
        else {
            currentTextStickerView?.backgroundColor = getColor(colorString: color)
            currentTextStickerView?.hideTextBorder(isHide: true)
            currentTextStickerView?.bcColor = color
        }
    }
    
    func addText(text: String, font: UIFont) {
        print("[AddText] delegate called")
        self.showKeyBoard()
        let frame = CGRect(x: 0, y: 0, width: 250, height: 200)
        let sticker = TextStickerContainerView(frame: frame)
        sticker.tag = -1// TODO: implement in alternative way
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
        
        guard let textStickerView = currentTextStickerView else {
            print("[EditVC] currentTextStickerView is nill")
            return
        }
        
        textStickerView.deleteController.isHidden = false
        textStickerView.scaleController.isHidden = false
        textStickerView.extendBarView.isHidden = false
        textStickerView.hideTextBorder(isHide: false)
    }
}

extension EditVc:UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewForBackGround {
            if currentBackGroundIndex == 0 {
                return plistArray.count + 1
            }else if currentBackGroundIndex == 1 {
                return plistArray1.count + 1
            }
            else {
                return 23
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
                else if indexPath.row == 1 {
                    cell.gradietImv.image = UIImage(named: "no-color")
                    cell.gradietImv.isHidden = false
                    cell.holderView.backgroundColor = UIColor.clear

                }
                else if let colorString = plistArray[indexPath.row - 2] as? String {
                    cell.holderView.backgroundColor = getColor(colorString: colorString)
                    cell.gradietImv.isHidden = true
                }
            }
            
            
            if currentBackGroundIndex == 1 {
                
                   if indexPath.row == 0 {
                    cell.gradietImv.image = UIImage(named: "no-color")
                    cell.gradietImv.isHidden = false
                    cell.holderView.backgroundColor = UIColor.clear
                    return cell

                }
                
                cell.gradietImv.image = nil
                cell.gradietImv.isHidden = false
                if let objArray = plistArray1[indexPath.row - 1] as? NSArray {
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
                if indexPath.row == 0 {
                    cell.gradietImv.image = UIImage(named: "no-color")
                    cell.gradietImv.isHidden = false
                    cell.holderView.backgroundColor = UIColor.clear
                    return cell
                }
                cell.gradietImv.isHidden = false
                cell.gradietImv.image = UIImage(named: "Texture" + "\(indexPath.row - 1)")
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
            
            let cell = collectionView.cellForItem(at: indexPath)
            
            UIView.animate(withDuration: 0.5, animations:
                            {
                cell?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                //cell?.backgroundColor = UIColor.lightGray
            }) { (true) in
                UIView.animate(withDuration: 0.5, animations:
                                {
                    cell?.transform =  CGAffineTransform(scaleX: 1.0, y: 1.0);                //cell?.backgroundColor = UIColor.clear
                })
            }
        
            if currentBackGroundIndex == 0 {
                currentTextStickerView?.bcTexture = -1
                currentTextStickerView?.bcGradient = -1
                if indexPath.row == 0 {
                    isFromTextColor = false
                    self.updateHeight(heightNeedToBeRemoved: self.heightForColorPickerView.constant)

                    UIView.animate(withDuration: 0.2, animations: {
                
                        self.bottomSpaceForColorPicker.constant = 0
                        self.bottomSpceOfMainView.constant = self.heightForColorPickerView.constant
                        self.view.layoutIfNeeded()
                        
                    }, completion: {_ in
                        
                    })
                    
                }
                else if indexPath.row == 1 {
                    
                    currentTextStickerView?.bcColor = ""
                    currentTextStickerView?.backgroundColor = UIColor.clear
                    currentTextStickerView?.hideTextBorder(isHide: false)
                    
                }
                
                else if let colorString = plistArray[indexPath.row - 2] as? String {
                    currentTextStickerView?.backgroundColor = getColor(colorString: colorString)
                    currentTextStickerView?.hideTextBorder(isHide: true)
                    currentTextStickerView?.bcColor = colorString
                }
                
            }
            if currentBackGroundIndex == 1 {
                currentTextStickerView?.currentColorSting = ""
                currentTextStickerView?.bcTexture = -1
                if indexPath.row == 0 {
                    currentTextStickerView?.backgroundColor = UIColor.clear
                    currentTextStickerView?.bcGradient = -1
                    currentTextStickerView?.hideTextBorder(isHide: false)
                    return
                }
 
                currentTextStickerView?.hideTextBorder(isHide: true)
                currentTextStickerView?.bcGradient = indexPath.row - 1
                if let objArray = plistArray1[indexPath.row-1] as? NSArray {
                    var allcolors: [CGColor] = []
                    for item in objArray {
                        let color = getColor(colorString: item as? String ?? "")
                        allcolors.append(color.cgColor)
                    }
                    
                    let uimage = UIImage.gradientImageWithBounds(bounds: CGRect(x: 0,y: 0,width: 200,height: 200), colors: allcolors)
                    currentTextStickerView?.backgroundColor = UIColor(patternImage: uimage)
                    
                }
                
            }
            if currentBackGroundIndex == 2 {
                if indexPath.row == 0 {
                    
                    currentTextStickerView?.backgroundColor = UIColor.clear
                    currentTextStickerView?.bcGradient = -1
                    currentTextStickerView?.bcTexture = -1
                    currentTextStickerView?.bcColor = ""
                    currentTextStickerView?.hideTextBorder(isHide: false)
                    return
                }
                
                currentTextStickerView?.bcGradient = -1
                currentTextStickerView?.bcTexture = indexPath.row - 1
                currentTextStickerView?.hideTextBorder(isHide: true)
                let value = UIImage(named: "Texture" + "\(indexPath.row - 1)")
                currentTextStickerView?.backgroundColor = UIColor(patternImage: value!)
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
                    self.addText(text: "Double tap to edit", font: font)
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
                
                let p = self.bottomSpaceForImageViewHolder.constant < 0 ? 0 : -1000
                
                if p == 0 {
                    currentlyActiveIndex = BtnNameInt.Image.rawValue
                } else {
                    currentlyActiveIndex = -1
                }
                
                
            }
            
            if btnValue == BtnName.Shape.rawValue {
                let p = self.bottomSapceForShape.constant < 0 ? 0 : -1000
                
                if p == 0 {
                    currentlyActiveIndex = BtnNameInt.Shape.rawValue
                } else {
                    currentlyActiveIndex = -1
                }
                
            }
            
            if btnValue == BtnName.Frames.rawValue {
                let p = self.bottomSpaceForFrame.constant < 0 ? 0 : -1000
                
                if p == 0 {
                    currentlyActiveIndex = BtnNameInt.Frames.rawValue
                } else {
                    currentlyActiveIndex = -1
                }
            }
            
            
            updateValue()
            
        }
        collectionView.reloadData()
    }
}
