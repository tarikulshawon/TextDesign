//
//  CropVc.swift
//  PosterMaker
//
//  Created by m-sagor-sikdar on 17/12/21.
//

import UIKit
import IGRPhotoTweaks


class CropVc: UIViewController, IGRPhotoTweakViewControllerDelegate {
    func photoTweaksController(_ controller: IGRPhotoTweakViewController, didFinishWithCroppedImage croppedImage: UIImage) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func photoTweaksControllerDidCancel(_ controller: IGRPhotoTweakViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var widthImv: NSLayoutConstraint!
    @IBOutlet weak var heightImv: NSLayoutConstraint!
    var plistArray:NSArray!
    
    var mainImage:UIImage!
    var selectedIndex  = 0
    
    @IBOutlet weak var ratioCollectionView: UICollectionView!
    
    @IBOutlet weak var mainImv: UIImageView!
    @IBOutlet weak var holderView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80  , height: 80)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection  = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        ratioCollectionView?.collectionViewLayout = layout
        
        
        let emptyAutomationsCell = RatioCell.nib
        ratioCollectionView?.register(emptyAutomationsCell, forCellWithReuseIdentifier: RatioCell.reusableID)
        
        
        let path = Bundle.main.path(forResource: "style", ofType: "plist")
        plistArray = NSArray(contentsOfFile: path!)
        self.perform(#selector(self.targetMethod1), with: self, afterDelay:0.1)
        // Do any additional setup after loading the view.
        
    }
    
    @objc func targetMethod1() {
        widthImv.constant = holderView.frame.width
        heightImv.constant = holderView.frame.height
        
        mainImv.image = mainImage
        mainImv.contentMode = .scaleAspectFit
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //widthImv.constant = holderView.frame.width
        //heightImv.constant = holderView.frame.height
    }
    
    @IBAction func gotoPreviousView(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        
        var image1 = mainImv.takeScreenshot()
        
        if selectedIndex <= 1 {
            image1 = mainImage
        }
        
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: EditVc = storyboard.instantiateViewController(withIdentifier: "EditVc") as! EditVc
        vc.modalPresentationStyle = .fullScreen
        vc.mainImage = image1
        self.present(vc, animated: true, completion: nil)
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension CropVc:UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        plistArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RatioCell.reusableID,
            for: indexPath) as? RatioCell else {
                return RatioCell()
            }
        
        cell.iconImv.image = UIImage(named: "Ratio" + "\(indexPath.row)")
        cell.iconImv.contentMode = .scaleAspectFit
        cell.iconLabel.textColor = unselectedColor
        var obj = plistArray[indexPath.row] as? Dictionary<String, Any>
        
        if let value = obj?["Name"] as? String  {
            cell.iconLabel.text = value
        }
        
        // cell.textLabel.textColor = unselectedColor
        
        //cell.backgroundColor = UIColor.red
        return cell
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        
        selectedIndex = indexPath.row
        if indexPath.row == 1 {
            
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: IGRPhotoTweakViewController = storyboard.instantiateViewController(withIdentifier: "ExampleCropViewController") as! ExampleCropViewController
            vc.modalPresentationStyle = .fullScreen
            vc.image = mainImage
            vc.delegate = self
            

            self.present(vc, animated: true, completion: nil)
            return
            
        }
        if indexPath.row <= 1 {
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.4) {
                    
                    
                    self.widthImv.constant = self.holderView.frame.size.width
                    self.heightImv.constant = self.holderView.frame.size.height
                    
                    self.mainImv.contentMode = .scaleAspectFit
                    self.view.layoutIfNeeded()
                }
            }
            
        } else {
            
            var obj = plistArray[indexPath.row] as? Dictionary<String, Any>
            
            guard  let value = obj?["Width"] as? CGFloat,let value1 = obj?["Height"] as? CGFloat  else {
                return
            }
            
            
            var newWidth:CGFloat = 0
            var newHeight:CGFloat = 0
            
            var ratio:CGFloat = (holderView.frame.size.width*CGFloat(value1))/CGFloat(value)
            
            if ratio > holderView.frame.size.height {
                
                newHeight = holderView.frame.size.height
                newWidth = (value1 * holderView.frame.size.width) / value
                
            } else {
                newWidth = holderView.frame.size.width
                newHeight = ratio
            }
            
            if newWidth > holderView.frame.size.width {
                print("khanki")
            }
            
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.4) {
                    
                    
                    self.widthImv.constant = newWidth
                    self.heightImv.constant = newHeight
                    
                    self.mainImv.contentMode = .scaleAspectFill
                    self.view.layoutIfNeeded()
                }
            }
            
        }
    }
    
    func CGSizeAspectFill(_ aspectRatio: CGSize, _ minimumSize: CGSize) -> CGSize {
        var aspectFillSize = CGSize(width: minimumSize.width, height: minimumSize.height)
        let mW = Float(minimumSize.width / aspectRatio.width)
        let mH = Float(minimumSize.height / aspectRatio.height)
        if mH > mW {
            aspectFillSize.width = CGFloat(mH) * aspectRatio.width
        } else if mW > mH {
            aspectFillSize.height = CGFloat(mW) * aspectRatio.height
        }
        return aspectFillSize
    }
    
}
