//
//  ImageEditView.swift
//  PosterMaker
//
//  Created by m-sagor-sikdar on 28/12/21.
//

import UIKit

protocol sendImageDelegate: AnyObject {
    func  sendImage()
    func changeImageOpacity(value:Float)
    func chnageValue(value: Float, index:Int)
}

class ImageEditView: UIView{
    
    
    @IBOutlet weak var collectionViewForBackGround: UICollectionView!
    @IBOutlet weak var optionView: UIView!
    var btnScrollView: UIScrollView!
    var tempViww:UIView!
    var selectedIndexView:UIView!
    var plistAttayForTextEditOption:NSArray!
    let buttonWidth:CGFloat = 90.0
    var selectedBtIndex = 0
    let gapBetweenButtons: CGFloat = 7
    weak var delegateForImage: sendImageDelegate?
    var currentIndex = 1


    @IBOutlet weak var titleLabel: UILabel!
    



    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        let path2 = Bundle.main.path(forResource: "imageEdit", ofType: "plist")
        plistAttayForTextEditOption = NSArray(contentsOfFile: path2!)
        stickersScrollContents()
    }
    
    
    @IBAction func sliderValueChanged(_ sender: CustomSlider) {
        print(sender.value)
        if titleLabel.text == "Brightness" {
            delegateForImage?.chnageValue(value: sender.value, index: 0)
        }else if titleLabel.text == "Saturation" {
            delegateForImage?.chnageValue(value: sender.value, index: 1)
        }else if titleLabel.text == "Contrast" {
            delegateForImage?.chnageValue(value: sender.value, index: 2)
        }
        else if titleLabel.text == "Sharpen" {
            delegateForImage?.chnageValue(value: sender.value, index: 3)
        }
        else {
            delegateForImage?.changeImageOpacity(value: sender.value)
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        
        
        self.tempViww.backgroundColor = titleColor
            
        
        
        for i in 0..<self.plistAttayForTextEditOption.count{
            var btn = self.btnScrollView.viewWithTag(i+700) as? UIButton
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
                if sender.tag == 700 {
                    btn?.setTitleColor(unselectedColor, for: .normal)
                    var btn1 = self.btnScrollView.viewWithTag(701) as? UIButton
                    self.buttonAction(sender: btn1)
                    self.delegateForImage?.sendImage()
                }
                
                if sender.tag == 701 {
                    self.titleLabel.text = "Opacity"
                    self.currentIndex = 1
                }
                else if sender.tag == 702 {
                    self.titleLabel.text = "Brightness"
                    self.currentIndex = 3
                }
                else if sender.tag == 703 {
                    self.titleLabel.text = "Saturation"
                    self.currentIndex = 4
                }
                else if sender.tag == 704 {
                    self.titleLabel.text = "Contrast"
                    self.currentIndex = 5
                }
                else if sender.tag == 705 {
                    self.titleLabel.text = "Sharpen"
                    self.currentIndex = 6
                }
                
                
            }
            
            
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
        tempViww.backgroundColor = titleColor
        tempViww.layer.cornerRadius = tempViww.frame.size.height / 2.0
       // selectedIndexView.backgroundColor = UIColor.red
        
        
        btnScrollView.addSubview(selectedIndexView)
        
        
        for i in 0..<plistAttayForTextEditOption.count{
            let filterButton = UIButton(type: .custom)
            filterButton.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
            filterButton.tag = 700 + i
            filterButton.backgroundColor = UIColor.clear
            
           
            if let value = plistAttayForTextEditOption[i] as? String {
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
        
    }

}

