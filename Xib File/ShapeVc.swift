//
//  ShapeVc.swift
//  PosterMaker
//
//  Created by m-sagor-sikdar on 4/1/22.
//

import UIKit

protocol sendShape: AnyObject {
    func sendShape(sticker:String)
}

class ShapeVc: UIView {
    
    @IBOutlet weak var collectionViewShape: UICollectionView!
    weak var delegateForShape: sendShape?

    
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
        collectionViewShape.register(nibName, forCellWithReuseIdentifier:  RatioCell.reusableID)
        collectionViewShape.delegate = self
        collectionViewShape.dataSource = self
        collectionViewShape.showsVerticalScrollIndicator = false
        collectionViewShape.showsHorizontalScrollIndicator = false
        
    }
    
    

}

extension ShapeVc: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
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
        
        return 26
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        return CGSize(width: 60, height: 60)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RatioCell.reusableID  , for: indexPath as IndexPath) as! RatioCell
        
        cell.heightForLabel.constant = 0
        
        cell.iconImv.image = UIImage(named:"Shapes"+"\(indexPath.row + 1)")

        
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
        

        var name = "Shapes"+"\(indexPath.row + 1)"
        delegateForShape?.sendShape(sticker: name)
        
    }
    
    
}
