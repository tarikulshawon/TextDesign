//
//  ImageEditView.swift
//  PosterMaker
//
//  Created by m-sagor-sikdar on 28/12/21.
//

import UIKit

class ImageEditView: UIView {
    
    
    @IBOutlet weak var optionView: UIView!
    var btnScrollView: UIScrollView!
    var tempViww:UIView!
    var selectedIndexView:UIView!
    var plistAttayForTextEditOption:NSArray!
    let buttonWidth:CGFloat = 60.0
    var selectedBtIndex = 0
    let gapBetweenButtons: CGFloat = 7






    

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
                //self.collectionViewForTextControls.reloadData()
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
