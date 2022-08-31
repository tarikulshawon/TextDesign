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
    var noOfFilter  = 50
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
        
        if index == 0 {
            delegateForOverlay?.imageNameWithIndex(tag: "\(index)", image: UIImage(named: "nofilter") ?? UIImage())

        }
        else if let image = UIImage(named: "OverLay" + "\(index)") {
            delegateForOverlay?.imageNameWithIndex(tag: "\(index)", image: image)

            print(image.size.width)
            
        } else {
            odrManager.load(tag: "\(index)")
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
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let mainViewWidth = screenWidth;
        let ViewWidth=(mainViewWidth-5*10)/4;
        return CGSize(width: ViewWidth, height: ViewWidth)
        
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
            
            cell.gradietImv.image =  UIImage(named: "OverlayThumb" + "\(indexPath.row - 1)"  + ".jpg")
        }
        cell.gradietImv.layer.cornerRadius  = 15.0
        return cell
        
       
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        setOverLay(index: indexPath.row)
    }
}
    


extension UIImage {

    func saveToDocuments(filename:String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        if let data = self.jpegData(compressionQuality: 1.0) {
            do {
                try data.write(to: fileURL)
            } catch {
                print("error saving file to documents:", error)
            }
        }
    }

}
