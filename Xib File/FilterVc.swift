//
//  FilterVc.swift
//  PosterMaker
//
//  Created by m-sagor-sikdar on 21/12/21.
//

import UIKit

protocol filterIndexDelegate: AnyObject {
    func filterNameWithIndex(tag:String ,image: UIImage)
}

class FilterVc: UIView, ODRManagerDelegate {
    
    var currentIndex = 0
    var tempArray:NSArray!
    @IBOutlet weak var optionView: UIView!
    lazy var odrManager: ODRManager = {
        let odr = ODRManager()
        odr.delegate = self
        return odr
    }()
    
    
    weak var delegateForFilter: filterIndexDelegate?
    var btnScrollView: UIScrollView!
    var tempViww:UIView!


    
    func doneLoading(tag: String, successfully: Bool) {
        if successfully {
            guard let image = UIImage(named: "Filter" + "\(tag)") else { return  }
            delegateForFilter?.filterNameWithIndex(tag: tag, image: image)
            
        }
    }
    
    @IBOutlet weak var collectionViewForFilter: UICollectionView!
    var noOfFilter  = 27
    let buttonWidth:CGFloat = 70.0
    var selectedIndexView:UIView!
    var plistArray:NSArray!
    let gapBetweenButtons: CGFloat = 7




    override func awakeFromNib() {
        super.awakeFromNib()
        
        let nibName = UINib(nibName: ColorCell.reusableID, bundle: nil)
        collectionViewForFilter.register(nibName, forCellWithReuseIdentifier:  ColorCell.reusableID)
        collectionViewForFilter.delegate = self
        collectionViewForFilter.dataSource = self
        collectionViewForFilter.showsVerticalScrollIndicator = false
        collectionViewForFilter.showsHorizontalScrollIndicator = false
        let path = Bundle.main.path(forResource: "FilterGroup", ofType: "plist")
        fliterArray = NSArray(contentsOfFile: path!)
        
        if let value = fliterArray[currentIndex] as? Dictionary<String, Any>{
            tempArray  = value["items"] as! NSArray
            
        }
        
        stickersScrollContents()

        
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
        
        
        for i in 0..<fliterArray.count{
            let filterButton = UIButton(type: .custom)
            filterButton.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
            filterButton.tag = 800 + i
            filterButton.backgroundColor = UIColor.clear
            
            if i == 0 {
                tempViww.backgroundColor = titleColor
            }
            
            if let value = fliterArray[i] as? Dictionary<String, Any>{
                
                
                 filterButton.setTitle(value["group-name"] as? String, for: .normal)
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
        
        
        btnScrollView.contentSize = CGSize(width: buttonWidth * CGFloat(fliterArray.count) + gapBetweenButtons * CGFloat((fliterArray.count*2 + 1)), height: yCoord)

    }
    
    @objc func buttonAction(sender: UIButton!) {
        
        currentIndex = sender.tag - 800
        print(currentIndex)
        
        if let value = fliterArray[currentIndex] as? Dictionary<String, Any>{
            
            print("hala")
            tempArray  = value["items"] as! NSArray
            
        }
        self.collectionViewForFilter.reloadData()
        self.tempViww.backgroundColor = titleColor
            
        
        
        for i in 0..<fliterArray.count{
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
            
            DispatchQueue.main.async {
                //self.collectionViewForTextControls.reloadData()
            }
            
            
        })
    }
    
}
    

extension FilterVc: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return tempArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
         
        return CGSize(width: 70, height: 70)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.reusableID  , for: indexPath as IndexPath) as! ColorCell
        cell.holderView.isHidden = true
        cell.fontLabel.isHidden = true
        if indexPath.row == 0 {
            cell.gradietImv.image =  UIImage(named: "nofilter")
        }
        else {
            cell.gradietImv.image =  UIImage(named: "filterg")
            var dic = tempArray[indexPath.row]
            var image  = getFilteredImage(withInfo: dic as! [String : Any], for: UIImage(named: "filterg"))
            cell.gradietImv.image  = image
        }
        cell.layer.cornerRadius = cell.frame.size.height/2.0
         return cell
        
       
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
        
        if indexPath.row == 0 {
            delegateForFilter?.filterNameWithIndex(tag:"\(indexPath.row)", image: UIImage())
        }
        
        else if let image = UIImage(named: "Filter" + "\(indexPath.row)") {
            
            
            delegateForFilter?.filterNameWithIndex(tag:"\(indexPath.row)", image: image)
            print(image.size.width)
            
        } else {
            odrManager.load(tag: "\(indexPath.row)")
        }
        
        
    }
}
    
