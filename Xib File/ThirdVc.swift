//
//  ThirdVc.swift
//  PosterMaker
//
//  Created by m-sagor-sikdar on 18/12/21.
//

import UIKit

class ThirdVc: UIView {
    
    var plistArray:NSArray!
    var plistArray1:NSArray!
    var selectedIndex = 0
    
    @IBOutlet weak var collectionViewForColor: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let path = Bundle.main.path(forResource: "colorp", ofType: "plist")
        plistArray = NSArray(contentsOfFile: path!)
        
        let path1 = Bundle.main.path(forResource: "gradient", ofType: "plist")
        plistArray1 = NSArray(contentsOfFile: path1!)
        print(plistArray1.count)
        
        let nibName = UINib(nibName: ColorCell.reusableID, bundle: nil)
        collectionViewForColor.register(nibName, forCellWithReuseIdentifier:  ColorCell.reusableID)
        collectionViewForColor.delegate = self
        collectionViewForColor.dataSource = self
        
    }

    @IBAction func segmentValueChange(_ sender: UISegmentedControl) {
        selectedIndex = sender.selectedSegmentIndex
        collectionViewForColor.reloadData()
        
    }
}


extension ThirdVc: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
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
        
        if selectedIndex == 0 {
            return  100
        }
        return plistArray1.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let mainViewWidth = screenWidth;
        let ViewWidth=(mainViewWidth-4*10)/3;
        let height = (ViewWidth*2500)/1500
        return CGSize(width: ViewWidth, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.reusableID  , for: indexPath as IndexPath) as! ColorCell
        
        if let colorString = plistArray[indexPath.row] as? String,selectedIndex == 0 {
            
            cell.gradietImv.isHidden = true
            cell.holderView.backgroundColor = getColor(colorString: colorString)
            
        }
        else {
            
            cell.gradietImv.isHidden = false
            if let objArray = plistArray1[indexPath.row] as? NSArray {
                var allcolors: [CGColor] = []
                for item in objArray {
                    let color = getColor(colorString: item as? String ?? "")
                    allcolors.append(color.cgColor)
                }
                
                let uimage = UIImage.gradientImageWithBounds(bounds: CGRect(x: 0,y: 0,width: 800,height: 800), colors: allcolors)
                cell.gradietImv.contentMode = .scaleAspectFill
                cell.gradietImv.image = uimage
                
            }
        }
        cell.layer.cornerRadius = 10.0
        return cell
        
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var mainImage:UIImage!
        if selectedIndex != 0 {
            if let objArray = plistArray1[indexPath.row] as? NSArray {
                var allcolors: [CGColor] = []
                for item in objArray {
                    let color = getColor(colorString: item as? String ?? "")
                    allcolors.append(color.cgColor)
                }
                
                mainImage = UIImage.gradientImageWithBounds(bounds: CGRect(x: 0,y: 0,width: 1000,height: 1000), colors: allcolors)
                
            }
        } else {
            if let colorString = plistArray[indexPath.row] as? String,selectedIndex == 0 {
                
                let colorF  = getColor(colorString: colorString)
                mainImage = colorF.image(CGSize(width: 1000, height: 1000))
            }
            
        }

        DispatchQueue.main.async {
             
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: EditVc = storyboard.instantiateViewController(withIdentifier: "EditVc") as! EditVc
            vc.modalPresentationStyle = .fullScreen
            vc.mainImage = mainImage
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

            if var topController = keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                topController.present(vc, animated: true, completion: nil)
            }
            
        }
    }
}

extension UIImage {
    static func gradientImageWithBounds(bounds: CGRect, colors: [CGColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
