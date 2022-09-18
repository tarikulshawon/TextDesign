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
    
    
    lazy var odrManager: ODRManager = {
        let odr = ODRManager()
        odr.delegate = self
        return odr
    }()
    
    
    weak var delegateForFilter: filterIndexDelegate?

    
    func doneLoading(tag: String, successfully: Bool) {
        if successfully {
            guard let image = UIImage(named: "Filter" + "\(tag)") else { return  }
            delegateForFilter?.filterNameWithIndex(tag: tag, image: image)
            
        }
    }
    
    @IBOutlet weak var collectionViewForFilter: UICollectionView!
    var noOfFilter  = 27
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let nibName = UINib(nibName: ColorCell.reusableID, bundle: nil)
        collectionViewForFilter.register(nibName, forCellWithReuseIdentifier:  ColorCell.reusableID)
        collectionViewForFilter.delegate = self
        collectionViewForFilter.dataSource = self
        collectionViewForFilter.showsVerticalScrollIndicator = false
        collectionViewForFilter.showsHorizontalScrollIndicator = false
        
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
        else {
            cell.gradietImv.image =  UIImage(named: "FilterThumb" + "\(indexPath.row)" + ".jpg")
        }
        cell.layer.cornerRadius = cell.frame.size.height/2.0
         return cell
        
       
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
    
