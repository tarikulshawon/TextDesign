//
//  StickerVc.swift
//  PosterMaker
//
//  Created by m-sagor-sikdar on 21/12/21.
//

import UIKit

protocol sendSticker: AnyObject {
    func sendSticker(sticker:String)
}


class StickerVc: UIView {
    
    var plistArray:NSArray!
    @IBOutlet weak var optionView: UIView!
    var btnScrollView: UIScrollView!
    var tempViww:UIView!
    var selectedIndexView:UIView!
    let buttonWidth:CGFloat = 60.0
    let gapBetweenButtons: CGFloat = 7
    var resourcePath2:String?
    var currentSelectedSticker = 0
    weak var delegateForSticker: sendSticker?

    
    



    @IBOutlet weak var collectionViewForSticker: UICollectionView!
    

    func getStickerArray(index: Int) -> NSArray {
        
        
        var tempArray:NSArray!
        if let value  = plistArray[currentSelectedSticker] as? String, let path =  Bundle.main.path(forResource: value, ofType: nil) {
            
            do {
                try  tempArray =  FileManager.default.contentsOfDirectory(atPath: path) as NSArray
            } catch {
            }

        }
        
        return tempArray
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let nibName = UINib(nibName: RatioCell.reusableID, bundle: nil)
        collectionViewForSticker.register(nibName, forCellWithReuseIdentifier:  RatioCell.reusableID)
        collectionViewForSticker.delegate = self
        collectionViewForSticker.dataSource = self
        collectionViewForSticker.showsVerticalScrollIndicator = false
        collectionViewForSticker.showsHorizontalScrollIndicator = false
        
        
        
        
        let path = Bundle.main.path(forResource: "sticker", ofType: "plist")
        plistArray = NSArray(contentsOfFile: path!)
        stickersScrollContents()
        
        
    }
    
    @objc func buttonAction(sender: UIButton!) {
        
        let tag = sender.tag - 800
        currentSelectedSticker = tag
        getStickerArray(index: currentSelectedSticker)
        
        for i in 0..<self.plistArray.count{
            var btn = self.btnScrollView.viewWithTag(i+800) as? UIButton
            btn?.setTitleColor(unselectedColor, for: .normal)
        }
       
        
        DispatchQueue.main.async {
            self.collectionViewForSticker.reloadData()
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
        
        
        for i in 0..<plistArray.count{
            let filterButton = UIButton(type: .custom)
            filterButton.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
            filterButton.tag = 800 + i
            filterButton.backgroundColor = UIColor.clear
            
            if i == 0 {
                tempViww.backgroundColor = titleColor
            }
            
            if let value = plistArray[i] as? String{
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
        
        
        btnScrollView.contentSize = CGSize(width: buttonWidth * CGFloat(plistArray.count) + gapBetweenButtons * CGFloat((plistArray.count*2 + 1)), height: yCoord)

    }
    
    
}


extension StickerVc: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.getStickerArray(index: currentSelectedSticker).count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        return CGSize(width: 60, height: 60)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RatioCell.reusableID  , for: indexPath as IndexPath) as! RatioCell
        

        var tempArray = self.getStickerArray(index: currentSelectedSticker)
        let filename = tempArray[indexPath.row]
        
        if let value  = plistArray[currentSelectedSticker] as? String, let path =  Bundle.main.path(forResource: value, ofType: nil) {
            let imagePath = "\(value)/\(filename)"
            var image = UIImage(named: imagePath)
            cell.iconImv.image = image
            
        }
        cell.heightForLabel.constant = 0
        
        
        return cell
        
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tempArray = self.getStickerArray(index: currentSelectedSticker)
        let filename = tempArray[indexPath.row]
        
        if let value  = plistArray[currentSelectedSticker] as? String, let path =  Bundle.main.path(forResource: value, ofType: nil) {
            let imagePath = "\(value)/\(filename)"
            self.delegateForSticker?.sendSticker(sticker: imagePath)
        }
        
    }
    
    
}
