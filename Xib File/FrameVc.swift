//
//  FrameVc.swift
//  TextArt
//
//  Created by Macbook pro 2020 M1 on 25/9/22.
//

import UIKit


protocol sendFrames: AnyObject {
    func sendFramesIndex(frames:String)
}

class FrameVc: UIView {
    
    weak var delegateForFramesr: sendFrames?
    @IBOutlet weak var collectionViewForFrame: UICollectionView!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let nibName = UINib(nibName: RatioCell.reusableID, bundle: nil)
        collectionViewForFrame.register(nibName, forCellWithReuseIdentifier:  RatioCell.reusableID)
        collectionViewForFrame.delegate = self
        collectionViewForFrame.dataSource = self
        collectionViewForFrame.showsVerticalScrollIndicator = false
        collectionViewForFrame.showsHorizontalScrollIndicator = false
        
    }

}

extension FrameVc: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
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
        
        return 49
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        return CGSize(width: 70, height: 70)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RatioCell.reusableID  , for: indexPath as IndexPath) as! RatioCell
        cell.heightForLabel.constant = 0
        cell.iconImv.image =  UIImage(named: "FrameThumb" + "\(indexPath.row)" + ".png")
        cell.iconImv.backgroundColor = UIColor.init(red: 128.0/255.0, green: 92.0/255.0, blue: 242.0/255.0, alpha: 0.1)
        
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
        delegateForFramesr?.sendFramesIndex(frames: "F" + "\(indexPath.row)" + ".jpg")
        
    }
    
    
}
