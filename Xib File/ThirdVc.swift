import UIKit

enum SegmentType: CaseIterable, Equatable {
    case color
    case gradient
}

class ThirdVc: UIView {
    var colorList: NSArray!
    var gradientList: NSArray!
    var selectedSegment = SegmentType.color
    let segments = SegmentType.allCases
    
    @IBOutlet weak var collectionViewForColor: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let path = Bundle.main.path(forResource: "colorp", ofType: "plist")
        colorList = NSArray(contentsOfFile: path!)
        
        let path1 = Bundle.main.path(forResource: "gradient", ofType: "plist")
        gradientList = NSArray(contentsOfFile: path1!)
        print(gradientList.count)
        
        let nibName = UINib(nibName: ColorCell.reusableID, bundle: nil)
        collectionViewForColor.register(nibName, forCellWithReuseIdentifier:  ColorCell.reusableID)
        collectionViewForColor.delegate = self
        collectionViewForColor.dataSource = self
    }

    @IBAction func segmentValueChange(_ sender: UISegmentedControl) {
        selectedSegment = segments[sender.selectedSegmentIndex]
        collectionViewForColor.reloadData()
    }
}


extension ThirdVc: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
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
        switch selectedSegment {
        case .color:
            return colorList.count
        case .gradient:
            return gradientList.count
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let mainViewWidth = UIScreen.main.bounds.width
        let viewWidth = (mainViewWidth - 4 * 10) / 3
        let height = (viewWidth * 2500) / 1500
        
        return CGSize(width: viewWidth, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.reusableID, for: indexPath as IndexPath) as! ColorCell
        
        if let colorString = colorList[indexPath.row] as? String, selectedSegment == .color {
            cell.gradietImv.isHidden = true
            cell.holderView.backgroundColor = getColor(colorString: colorString)
        }
        else {
            cell.gradietImv.isHidden = false
            if let objArray = gradientList[indexPath.row] as? NSArray {
                var allcolors: [CGColor] = []
                for item in objArray {
                    let color = getColor(colorString: item as? String ?? "")
                    allcolors.append(color.cgColor)
                }
                
                let uimage = UIImage.gradientImageWithBounds(
                    bounds: CGRect(x: 0, y: 0, width: 800, height: 800),
                    colors: allcolors
                )
                
                cell.gradietImv.contentMode = .scaleAspectFill
                cell.gradietImv.image = uimage
            }
        }
        
        cell.layer.cornerRadius = 10.0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var mainImage:UIImage!
        if selectedSegment != .color {
            if let objArray = gradientList[indexPath.row] as? NSArray {
                var allcolors: [CGColor] = []
                for item in objArray {
                    let color = getColor(colorString: item as? String ?? "")
                    allcolors.append(color.cgColor)
                }
                
                mainImage = UIImage.gradientImageWithBounds(bounds: CGRect(x: 0,y: 0,width: 1000,height: 1000), colors: allcolors)
                
            }
        } else {
            if let colorString = colorList[indexPath.row] as? String, selectedSegment == .color {
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
