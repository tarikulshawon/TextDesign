//
//  FilterVc.swift
//  PosterMaker
//
//  Created by m-sagor-sikdar on 21/12/21.
//

import UIKit

protocol imageIndexDelegate: AnyObject {
    func imageNameWithIndex(tag:String ,image: UIImage)
}

class OverLayVc: UIView, ODRManagerDelegate {
    
   public weak var delegateForOverlay: imageIndexDelegate?
    

    
    
    
    
    func doneLoading(tag: String, successfully: Bool) {
        
        if successfully {
            
            
            guard let image = UIImage(named: "OverLay" + "\(tag)") else { return  }
            delegateForOverlay?.imageNameWithIndex(tag: tag, image: image)
            
        }
        
    }
    
    
    
    lazy var odrManager: ODRManager = {
        let odr = ODRManager()
        odr.delegate = self
        return odr
    }()
    
    @IBOutlet weak var collectionViewForFilter: UICollectionView!
    var noOfFilter  = 49
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let nibName = UINib(nibName: ColorCell.reusableID, bundle: nil)
        collectionViewForFilter.register(nibName, forCellWithReuseIdentifier:  ColorCell.reusableID)
        collectionViewForFilter.delegate = self
        collectionViewForFilter.dataSource = self
        collectionViewForFilter.showsVerticalScrollIndicator = false
        collectionViewForFilter.showsHorizontalScrollIndicator = false
        
    }

    func setOverLay(index:Int) {
        
       
         if let image = UIImage(named: "Overlay" + "\(index)") {
            delegateForOverlay?.imageNameWithIndex(tag: "\(index)", image: image)

            
        } else {
           
        }
        
        
        
    }
    
    

}

extension OverLayVc: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
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
        
        
        return noOfFilter + 1
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
        
        else
        {
            
            cell.gradietImv.image =  UIImage(named: "OverlayThumb" + "\(indexPath.row - 1)")
        }
        cell.gradietImv.layer.cornerRadius  = cell.frame.size.height/2.0
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

        setOverLay(index: indexPath.row - 1)
    }
}
    
