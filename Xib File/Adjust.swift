//
//  StickerVc.swift
//  PosterMaker
//
//  Created by m-sagor-sikdar on 21/12/21.
//

import UIKit

protocol sendValueForAdjust: AnyObject {
    func sendAdjustValue(value:Float ,index: Int)
}


class Adjust: UIView {
    
    var plistArray4:NSArray!
    @IBOutlet weak var optionView: UIView!
    var btnScrollView: UIScrollView!
    var tempViww:UIView!
    var selectedIndexView:UIView!
    let buttonWidth:CGFloat = 85.0
    let gapBetweenButtons: CGFloat = 7
    var resourcePath2:String?
    var currentSelectedSticker = 0
    weak var delegate: sendValueForAdjust?
    
    
    var brigthness:Float = 0
    let max_brightness = 0.7
    let min_brightness = -0.7
    
    
    var contrast:Float = 1.0
    let max_contrast = 1.5
    let min_contrast = 0.5
    
    var saturation:Float = 1.0
    let max_saturation = 3.0
    let min_saturation = -1.0
    
    var hue:Float = 0.0
    let max_hue = 1.0
    let min_hue = 0.0
    
    var sharpen:Float = 0
    let max_sharpen = 4.0
    let min_sharpen = -4.0
    
    var currentIndex = 0
    
    
    @IBOutlet weak var horizontalSlider: UISlider!
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        
        delegate?.sendAdjustValue(value: sender.value, index: currentIndex)
        
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        
        
        let path = Bundle.main.path(forResource: "AdjustV", ofType: "plist")
        plistArray4 = NSArray(contentsOfFile: path!)
        stickersScrollContents()
        updateSlider()
        
        
    }
    
    func updateSlider() {
        if currentIndex == 0 {
            horizontalSlider.maximumValue = Float(max_brightness)
            horizontalSlider.minimumValue =
            Float(min_brightness)
            horizontalSlider.value = Float(brigthness)
        }
        if currentIndex == 1 {
            horizontalSlider.maximumValue = Float(max_saturation)
            horizontalSlider.minimumValue =
            Float(min_saturation)
            horizontalSlider.value = Float(saturation)
        }
        if currentIndex == 2 {
            horizontalSlider.maximumValue = Float(max_hue)
            horizontalSlider.minimumValue =
            Float(min_hue)
            horizontalSlider.value = Float(hue)
        }
        if currentIndex == 3 {
            horizontalSlider.maximumValue = Float(max_sharpen)
            horizontalSlider.minimumValue =
            Float(min_sharpen)
            horizontalSlider.value = Float(sharpen)
        }
        if currentIndex == 4 {
            horizontalSlider.maximumValue = Float(max_contrast)
            horizontalSlider.minimumValue =
            Float(min_contrast)
            horizontalSlider.value = Float(contrast)
        }
        
    }
    
    @objc func buttonAction(sender: UIButton!) {
        
        let tag = sender.tag - 800
        currentIndex = tag
        
        self.updateSlider()
        for i in 0..<self.plistArray4.count{
            var btn = self.btnScrollView.viewWithTag(i+800) as? UIButton
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
            
            
            
            
        })
        
    }
    
    func stickersScrollContents() {
        
        print("mammamamama")
        var xCoord: CGFloat = 5
        let yCoord: CGFloat = 0
        let buttonHeight: CGFloat = 45.0
        let tempBtn:CGFloat = 25.0
        btnScrollView = UIScrollView(frame: CGRect(x: 8, y: 0, width: optionView.frame.width, height: optionView.frame.height))
        //btnScrollView.backgroundColor = UIColor.red
        
        optionView.addSubview(btnScrollView)
        tempViww = UIView(frame: CGRect(x: 0, y: (buttonHeight - tempBtn)/2.0, width: buttonWidth, height: tempBtn))
        selectedIndexView = UIView(frame: CGRect(x: xCoord, y: 0, width: buttonWidth, height: buttonHeight))
        selectedIndexView.addSubview(tempViww)
        tempViww.backgroundColor = tintColor
        tempViww.layer.cornerRadius = tempViww.frame.size.height / 2.0
        //selectedIndexView.backgroundColor = UIColor.clear
        
        
        btnScrollView.addSubview(selectedIndexView)
        btnScrollView.showsHorizontalScrollIndicator = false
        btnScrollView.showsVerticalScrollIndicator = false
        
        
        for i in 0..<plistArray4.count{
            let filterButton = UIButton(type: .custom)
            filterButton.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
            filterButton.tag = 800 + i
            filterButton.backgroundColor = UIColor.clear
            
            if i == 0 {
                tempViww.backgroundColor = titleColor
            }
            
            if let value = plistArray4[i] as? String{
                filterButton.setTitle(value, for: .normal)
                filterButton.setTitleColor(unselectedColor, for: .normal)
            }
            
            filterButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0)
            filterButton.titleLabel?.adjustsFontSizeToFitWidth = true
            filterButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            
            if i == 0 {
                filterButton.setTitleColor(UIColor.white, for: .normal)
            }
            //filterButton.setTitleColor(tintColor, for: .normal)
            filterButton.clipsToBounds = true
            filterButton.backgroundColor = UIColor.clear
            xCoord +=  buttonWidth + gapBetweenButtons
            filterButton.titleLabel?.textAlignment = .center
            btnScrollView.addSubview(filterButton)
            
        }
        
        
        btnScrollView.contentSize = CGSize(width: buttonWidth * CGFloat(plistArray4.count) + gapBetweenButtons * CGFloat((plistArray4.count*2 + 1)), height: yCoord)
        
    }
    
    
}



