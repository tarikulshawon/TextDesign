//
//  TextView.swift
//  PosterMaker
//
//  Created by m-sagor-sikdar on 20/12/21.
//

import UIKit

protocol AddTextDelegate: AnyObject {
    func addText(text: String, font: UIFont)
}

class TextEditView: UIView {
    @IBOutlet weak var optionHolderView: UIView!
    
    let gapBetweenButtons: CGFloat = 7
    let buttonWidth: CGFloat = 60.0
    let selectedBtIndex = 1
    
    var plistArray: NSArray!
    var plistArray1: NSArray!
    var plistAttayForTextEditOption: NSArray!
    var btnScrollView: UIScrollView!
    var selectedIndexView: UIView!
    var tempViww: UIView!
    var currentOption: TextEditingOption!
    
    @IBOutlet weak var alighnmentViewHolder: UIView!
    
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var collectionViewForTextControls: UICollectionView!
    
    @IBOutlet weak var imageViewList: UIStackView!
    @IBOutlet weak var labelViewList: UIStackView!
    @IBOutlet weak var horizontalSlider: UISlider!
    
    weak var delegateForText: AddTextDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        horizontalSlider.maximumTrackTintColor = unselectedColor
        horizontalSlider.minimumTrackTintColor = titleColor
        
        currentOption = TextEditingOption.Fonts
        alighnmentViewHolder.isHidden = true
        collectionViewForTextControls.isHidden = true
        sliderView.isHidden = true
        perform(#selector(self.targetMethod), with: self, afterDelay: 0.1)
        
        
        let path = Bundle.main.path(forResource: "colorp", ofType: "plist")
        plistArray = NSArray(contentsOfFile: path!)
        
        let path1 = Bundle.main.path(forResource: "gradient", ofType: "plist")
        plistArray1 = NSArray(contentsOfFile: path1!)
        
        let path2 = Bundle.main.path(forResource: "textEditOption", ofType: "plist")
        plistAttayForTextEditOption = NSArray(contentsOfFile: path2!)
        print(plistArray1.count)
        
        let nibName = UINib(nibName: ColorCell.reusableID, bundle: nil)
        collectionViewForTextControls.register(nibName, forCellWithReuseIdentifier:  ColorCell.reusableID)
        collectionViewForTextControls.delegate = self
        collectionViewForTextControls.dataSource = self
        collectionViewForTextControls.showsVerticalScrollIndicator = false
        collectionViewForTextControls.showsHorizontalScrollIndicator = false
    }
    
    @objc
    fileprivate func targetMethod(){
        stickersScrollContents()
        btnScrollView.showsVerticalScrollIndicator = false
        btnScrollView.showsHorizontalScrollIndicator = false
        selectedIndexView.layer.cornerRadius = selectedIndexView.frame.size.height / 2.0
        selectedIndexView.clipsToBounds = true
        tempViww.backgroundColor = titleColor
        collectionViewForTextControls.reloadData()

    }
    
    @objc
    func buttonAction(sender: UIButton!) {
        if sender.tag == 700 {
            self.tempViww.backgroundColor = UIColor.clear
        }
        else {
            self.tempViww.backgroundColor = titleColor
        }
        let selectedOption = plistAttayForTextEditOption[sender.tag - 700] as? String
        switch(selectedOption) {
        case  TextEditingOption.AddText.rawValue:
            //
            
            currentOption = TextEditingOption.AddText
        case  TextEditingOption.Fonts.rawValue:
            currentOption = TextEditingOption.Fonts
        case  TextEditingOption.Color.rawValue:
            currentOption = TextEditingOption.Color
        case  TextEditingOption.Gradient.rawValue:
            currentOption = TextEditingOption.Gradient
        case  TextEditingOption.Draw.rawValue:
            currentOption = TextEditingOption.Draw
        case  TextEditingOption.Shadow.rawValue:
            currentOption = TextEditingOption.Shadow
        case  TextEditingOption.Opacity.rawValue:
            currentOption = TextEditingOption.Opacity
        case  TextEditingOption.Align.rawValue:
            currentOption = TextEditingOption.Align
        case  TextEditingOption.Rotate.rawValue:
            currentOption = TextEditingOption.Rotate
        case  TextEditingOption.Texture.rawValue:
            currentOption = TextEditingOption.Texture
        case .none:
            break
        case .some:
            break
        }
        print("Click: \(currentOption.rawValue)")
        
        if selectedOption == TextEditingOption.Opacity.rawValue || selectedOption == TextEditingOption.Shadow.rawValue {
            
            sliderView.isHidden = false
            collectionViewForTextControls.isHidden = true
            alighnmentViewHolder.isHidden = true
        }
        else if selectedOption == TextEditingOption.Align.rawValue  || selectedOption == TextEditingOption.Rotate.rawValue{
            collectionViewForTextControls.isHidden = true
            alighnmentViewHolder.isHidden = false
            sliderView.isHidden = true
            
            
            if selectedOption == TextEditingOption.Align.rawValue {
                imageViewList.isHidden = false
                labelViewList.isHidden = true
                
            } else {
                imageViewList.isHidden = true
                labelViewList.isHidden = false
            }
            
        } else {
            alighnmentViewHolder.isHidden = true
            collectionViewForTextControls.isHidden = false
            sliderView.isHidden = true
            
        }
        
        
        for i in 0..<self.plistAttayForTextEditOption.count{
            let btn = self.btnScrollView.viewWithTag(i+700) as? UIButton
            btn?.setTitleColor(unselectedColor, for: .normal)
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            var value = CGFloat (sender.tag)
            sender?.setTitleColor(UIColor.white, for: .normal)
            var frame = self.selectedIndexView.frame
            frame.origin.x = sender.frame.origin.x
            self.selectedIndexView.frame = frame
            self.layoutIfNeeded()
            
        }, completion: {_ in
            
            
            var btn = self.btnScrollView.viewWithTag(sender.tag) as? UIButton
            btn?.setTitleColor(UIColor.white, for: .normal)
            
            DispatchQueue.main.async {
                self.collectionViewForTextControls.reloadData()
            }
            
            
        })
        
    }
    func stickersScrollContents() {
        
        print("mammamamama")
        var xCoord: CGFloat = 5
        let yCoord: CGFloat = 0
        let buttonHeight: CGFloat = 45.0
        let tempBtn:CGFloat = 25.0
        btnScrollView = UIScrollView(frame: CGRect(x: 8, y: 0, width: optionHolderView.frame.width, height: optionHolderView.frame.height))
        //btnScrollView.backgroundColor = UIColor.red
        
        optionHolderView.addSubview(btnScrollView)
        tempViww = UIView(frame: CGRect(x: 0, y: (buttonHeight - tempBtn)/2.0, width: buttonWidth, height: tempBtn))
        selectedIndexView = UIView(frame: CGRect(x: 2*xCoord + buttonWidth, y: 0, width: buttonWidth, height: buttonHeight))
        selectedIndexView.addSubview(tempViww)
        tempViww.backgroundColor = tintColor
        tempViww.layer.cornerRadius = tempViww.frame.size.height / 2.0
        //selectedIndexView.backgroundColor = UIColor.clear
        
        
        btnScrollView.addSubview(selectedIndexView)
        
        
        for i in 0..<plistAttayForTextEditOption.count{
            let filterButton = UIButton(type: .custom)
            filterButton.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
            filterButton.tag = 700 + i
            filterButton.backgroundColor = UIColor.clear
            
            if i == 0 {
                filterButton.setImage(UIImage(named: "AddNewText"), for: .normal)
                tempViww.backgroundColor = UIColor.clear
            }
            if let value = plistAttayForTextEditOption[i] as? String ,i > 0 {
                filterButton.setTitle(value, for: .normal)
            }
            if i == selectedBtIndex {
                var value = selectedIndexView.frame
                filterButton.setTitleColor(UIColor.white, for: .normal)
            } else {
                filterButton.setTitleColor(unselectedColor, for: .normal)
            }
            filterButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0)
            filterButton.titleLabel?.adjustsFontSizeToFitWidth = true
            filterButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            //filterButton.setTitleColor(tintColor, for: .normal)
            filterButton.clipsToBounds = true
            filterButton.backgroundColor = UIColor.clear
            xCoord +=  buttonWidth + gapBetweenButtons
            filterButton.titleLabel?.textAlignment = .center
            btnScrollView.addSubview(filterButton)
            
        }
        
        
        btnScrollView.contentSize = CGSize(width: buttonWidth * CGFloat(plistAttayForTextEditOption.count) + gapBetweenButtons * CGFloat((plistAttayForTextEditOption.count*2 + 1)), height: yCoord)
        alighnmentViewHolder.isHidden = true
        collectionViewForTextControls.isHidden = false
    }
}


extension TextEditView: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if currentOption.rawValue == TextEditingOption.Color.rawValue{
            return plistArray.count
        }
        else if currentOption.rawValue == TextEditingOption.Fonts.rawValue {
            return arrayForFont.count
        }
        else if currentOption.rawValue == TextEditingOption.Texture.rawValue {
            return 22
        }
        return plistArray1.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 60, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.reusableID  , for: indexPath as IndexPath) as! ColorCell
        
        cell.holderView.isHidden = false
        cell.gradietImv.isHidden = false
        cell.fontLabel.isHidden = true
        
        if currentOption.rawValue == TextEditingOption.Texture.rawValue {
            cell.gradietImv.isHidden = false
            cell.gradietImv.image = UIImage(named: "Texture" + "\(indexPath.row)")
        }
        
        else if currentOption.rawValue ==  TextEditingOption.Fonts.rawValue {
            
            cell.holderView.isHidden = true
            cell.gradietImv.isHidden = true
            cell.fontLabel.isHidden = false
            var fontName = UIFont(name: arrayForFont[indexPath.row] as! String, size: 15.0)
            cell.fontLabel.font = fontName
            cell.fontLabel.text =  arrayForFont[indexPath.row] as! String
        }
        
        else if currentOption.rawValue == TextEditingOption.Color.rawValue{
            
            cell.gradietImv.isHidden = true
            if let colorString = plistArray[indexPath.row] as? String {
                cell.holderView.backgroundColor = getColor(colorString: colorString)
            }
            
        }
        else {
            
            if currentOption.rawValue == TextEditingOption.Gradient.rawValue {
                
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
        }
        
        cell.layer.cornerRadius = 10.0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let font = UIFont(name: arrayForFont[indexPath.row] as! String, size: 15.0) ?? UIFont.systemFont(ofSize: 15)
        delegateForText?.addText(text: "Add Your Text", font: font)
        
//        let tempArray = self.getStickerArray(index: currentSelectedSticker)
//        let filename = tempArray[indexPath.row]
//        
//        if let value  = plistArray[currentSelectedSticker] as? String, let path =  Bundle.main.path(forResource: value, ofType: nil) {
//            let imagePath = "\(value)/\(filename)"
//            self.delegateForSticker?.sendSticker(sticker: imagePath)
//        }
    }
}
