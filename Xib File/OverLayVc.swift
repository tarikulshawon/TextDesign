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
    @IBOutlet weak var collectionViewForFilter: UICollectionView!
    private let customFlowLayout = CustomCollectionViewFlowLayout()
    
    var centerCell: ColorCell?
    
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
    
    var noOfFilter  = 49
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let nibName = UINib(nibName: ColorCell.reusableID, bundle: nil)
        collectionViewForFilter.register(nibName, forCellWithReuseIdentifier:  ColorCell.reusableID)
        collectionViewForFilter.delegate = self
        collectionViewForFilter.dataSource = self
        collectionViewForFilter.showsVerticalScrollIndicator = false
        collectionViewForFilter.showsHorizontalScrollIndicator = false
        collectionViewForFilter.collectionViewLayout = customFlowLayout
        
        let layoutMargins = collectionViewForFilter.layoutMargins.left +
                            collectionViewForFilter.layoutMargins.right
        let sideInset = frame.width / 2 - layoutMargins
        collectionViewForFilter.contentInset = UIEdgeInsets(
            top: 0,
            left: sideInset,
            bottom: 0,
            right: sideInset
        )
        
    }
    
    func setOverLay(index:Int) {
        if let image = UIImage(named: "Overlay" + "\(index)") {
            delegateForOverlay?.imageNameWithIndex(tag: "\(index)", image: image)
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
        
        
        return CGSize(width: 60, height: 60)
        
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
        cell.gradietImv.layer.cornerRadius  = cell.frame.size.height / 2
        return cell
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(
            withDuration: 0.5,
            animations: {
                cell?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                
            }) { (true) in
                UIView.animate(withDuration: 0.5) {
                    cell?.transform =  CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
            }
        
        setOverLay(index: indexPath.row - 1)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView is UICollectionView else { return }

        let centerPoint = CGPoint(
            x: collectionViewForFilter.frame.size.width / 2 +  scrollView.contentOffset.x,
            y: collectionViewForFilter.frame.size.height / 2 + scrollView.contentOffset.y
        )

        if let indexPath = collectionViewForFilter.indexPathForItem(at: centerPoint) {
            centerCell = collectionViewForFilter.cellForItem(at: indexPath) as? ColorCell
            centerCell?.toZoom()

            setOverLay(index: indexPath.row - 1)
        }

        if let cell = centerCell {
            let offsetX = centerPoint.x - cell.center.x

            if offsetX < -10 || offsetX > 10 {
                cell.toOriginal()
                centerCell = nil
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.collectionViewForFilter.scrollToNearestVisibleCollectionViewCell()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.collectionViewForFilter.scrollToNearestVisibleCollectionViewCell()
        }
    }
}

extension UICollectionView {
    func scrollToNearestVisibleCollectionViewCell() {
        self.decelerationRate = UIScrollView.DecelerationRate.fast
        let visibleCenterPositionOfScrollView = Float(self.contentOffset.x + (self.bounds.size.width / 2))
        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude
        for i in 0..<self.visibleCells.count {
            let cell = self.visibleCells[i]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)

            // Now calculate closest cell
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = self.indexPath(for: cell)!.row
            }
        }
        if closestCellIndex != -1 {
            self.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}

final class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        scrollDirection = .horizontal
    }
    
//    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
//        let horizontalOffset = proposedContentOffset.x + collectionView!.contentInset.left
//        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView!.bounds.size.width, height: collectionView!.bounds.size.height)
//        let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)
//        layoutAttributesArray?.forEach({ (layoutAttributes) in
//            let itemOffset = layoutAttributes.frame.origin.x
//            if fabsf(Float(itemOffset - horizontalOffset)) < fabsf(Float(offsetAdjustment)) {
//                offsetAdjustment = itemOffset - horizontalOffset
//            }
//        })
//        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
//    }
}
