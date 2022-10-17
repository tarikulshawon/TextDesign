//
//  TextView.swift
//  PosterMaker
//
//  Created by m-sagor-sikdar on 20/12/21.
//

import UIKit

protocol AddTextDelegate: AnyObject {
    func addText(text: String, font: UIFont)
    func colorValue(color:String)
    func gradientValue(index: Int)
    func sendFonrIndex(index: Int)
    func sendTextureIndex(index: Int)
    func addText()
    func showBackground()
    func setAlighnMent(index:Int)
    func sendOpacityValue(value: Double)
    func showColorPickerView()
}

class TextEditView: UIView {
    @IBOutlet weak var optionHolderView: UIView!
    
    let gapBetweenButtons: CGFloat = 7
    let buttonWidth: CGFloat = 60.0
    let selectedBtIndex = 1
    
    var plistAttayForTextEditOption: NSArray!
    var btnScrollView: UIScrollView!
    var selectedIndexView: UIView!
    var tempViww: UIView!
    
    @IBOutlet weak var alighnmentViewHolder: UIView!
    
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var collectionViewForTextControls: UICollectionView!
    
    @IBOutlet weak var imageViewList: UIStackView!
    @IBOutlet weak var labelViewList: UIStackView!
    @IBOutlet weak var horizontalSlider: UISlider!
    
    private var currentOption: TextEditingOption = .Fonts
    private let options = TextEditingOption.allCases
    var centerCell: ColorCell?
    
    weak var delegateForText: AddTextDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        horizontalSlider.maximumTrackTintColor = unselectedColor
        horizontalSlider.minimumTrackTintColor = titleColor
        
        //currentOption = TextEditingOption.Fonts
        alighnmentViewHolder.isHidden = true
        collectionViewForTextControls.isHidden = true
        sliderView.isHidden = true
        perform(#selector(self.targetMethod), with: self, afterDelay: 0.1)
        
        
        let path = Bundle.main.path(forResource: "colorp", ofType: "plist")
        plistArray = NSArray(contentsOfFile: path!)
        
        let path1 = Bundle.main.path(forResource: "gradient", ofType: "plist")
        plistArray1 = NSArray(contentsOfFile: path1!)
        
        let path2 = Bundle.main.path(forResource: "textEditOption", ofType: "plist")
        plistAttayForTextEditOption = NSArray(contentsOfFile: path2!)
        print(plistArray1.count)
        
        let nibName = UINib(nibName: ColorCell.reusableID, bundle: nil)
        collectionViewForTextControls.register(nibName, forCellWithReuseIdentifier:  ColorCell.reusableID)
        collectionViewForTextControls.delegate = self
        collectionViewForTextControls.dataSource = self
        collectionViewForTextControls.showsVerticalScrollIndicator = false
        collectionViewForTextControls.showsHorizontalScrollIndicator = false
    }
    
    
    @IBAction func opacityValuChanges(_ sender: CustomSlider) {
        if currentOption == .Opacity {
            delegateForText?.sendOpacityValue(value: Double(sender.value))
        }
    }
    
    @objc
    fileprivate func targetMethod(){
        stickersScrollContents()
        btnScrollView.showsVerticalScrollIndicator = false
        btnScrollView.showsHorizontalScrollIndicator = false
        selectedIndexView.layer.cornerRadius = selectedIndexView.frame.size.height / 2.0
        selectedIndexView.clipsToBounds = true
        tempViww.backgroundColor = titleColor
        collectionViewForTextControls.reloadData()
        

    }
    
    
    @IBAction func gotoLeft(_ sender: Any) {
        delegateForText?.setAlighnMent(index: 0)
    }
    
    
    @IBAction func gotocenter(_ sender: Any) {
        delegateForText?.setAlighnMent(index: 1)
    }
    
    
    @IBAction func gotoRight(_ sender: Any) {
        delegateForText?.setAlighnMent(index: 2)
    }
    
    
    @IBAction func gotoJustified(_ sender: Any) {
        
        delegateForText?.setAlighnMent(index: 3)
        
    }
    @objc
    func buttonAction(sender: UIButton!) {
       
        self.tempViww.backgroundColor = titleColor
        let optionString = plistAttayForTextEditOption[sender.tag - 700] as? String
        let selectedOption = TextEditingOption(rawValue: optionString ?? "")
        currentOption = selectedOption ?? .Fonts
        
        print("Click: \(currentOption.rawValue)")
        
        if selectedOption == .Opacity || selectedOption == .Shadow {
            
            sliderView.isHidden = false
            collectionViewForTextControls.isHidden = true
            alighnmentViewHolder.isHidden = true
        }
        else if selectedOption == .Align  || selectedOption == .Rotate {
            collectionViewForTextControls.isHidden = true
            alighnmentViewHolder.isHidden = false
            sliderView.isHidden = true
            
            
            if selectedOption == .Align {
                imageViewList.isHidden = false
                labelViewList.isHidden = true
                
            } else {
                imageViewList.isHidden = true
                labelViewList.isHidden = false
            }
            
        } else {
            alighnmentViewHolder.isHidden = true
            collectionViewForTextControls.isHidden = false
            sliderView.isHidden = true
            
        }
        
        
        for i in 0..<self.plistAttayForTextEditOption.count{
            let btn = self.btnScrollView.viewWithTag(i+700) as? UIButton
            btn?.setTitleColor(unselectedColor, for: .normal)
        }
        var btn = self.btnScrollView.viewWithTag(sender.tag) as? UIButton

        UIView.animate(withDuration: 0.2, animations: {
            var value = CGFloat (sender.tag)
            sender?.setTitleColor(UIColor.white, for: .normal)
            var frame = self.selectedIndexView.frame
            frame.origin.x = sender.frame.origin.x
            self.selectedIndexView.frame = frame
            self.layoutIfNeeded()
            
        }, completion: {_ in
            
            
            
            DispatchQueue.main.async {
                self.collectionViewForTextControls.reloadData()
            }
            
            
        })
        
        if currentOption == .AddText {
            delegateForText?.addText()
            
        }
        
        if currentOption == .BackGround {
            delegateForText?.showBackground()
        }
        
        if sender.tag == 700 ||  currentOption.rawValue == TextEditingOption.BackGround.rawValue {
            btn?.setTitleColor(unselectedColor, for: .normal)
            var btn1 = self.btnScrollView.viewWithTag(701) as? UIButton
            self.buttonAction(sender: btn1)
        }
    }
    
    func stickersScrollContents() {
        
        print("stickersScrollContents")
        var xCoord: CGFloat = 5
        let yCoord: CGFloat = 0
        let buttonHeight: CGFloat = 45.0
        let tempBtn:CGFloat = 25.0
        btnScrollView = UIScrollView(frame: CGRect(x: 8, y: 0, width: optionHolderView.frame.width, height: optionHolderView.frame.height))
        //btnScrollView.backgroundColor = UIColor.red
        
        optionHolderView.addSubview(btnScrollView)
        tempViww = UIView(frame: CGRect(x: 0, y: (buttonHeight - tempBtn)/2.0, width: buttonWidth, height: tempBtn))
        selectedIndexView = UIView(frame: CGRect(x: 2*xCoord + buttonWidth, y: 0, width: buttonWidth, height: buttonHeight))
        selectedIndexView.addSubview(tempViww)
        tempViww.backgroundColor = tintColor
        tempViww.layer.cornerRadius = tempViww.frame.size.height / 2.0
        //selectedIndexView.backgroundColor = UIColor.clear
        
        
        btnScrollView.addSubview(selectedIndexView)
        
        
        for i in 0..<plistAttayForTextEditOption.count{
            let filterButton = UIButton(type: .custom)
            filterButton.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
            filterButton.tag = 700 + i
            filterButton.backgroundColor = UIColor.clear
            if let value = plistAttayForTextEditOption[i] as? String{
                filterButton.setTitle(value, for: .normal)
            }
            if i == selectedBtIndex {
                var value = selectedIndexView.frame
                filterButton.setTitleColor(UIColor.white, for: .normal)
            } else {
                filterButton.setTitleColor(unselectedColor, for: .normal)
            }
            filterButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0)
            filterButton.titleLabel?.adjustsFontSizeToFitWidth = true
            filterButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            //filterButton.setTitleColor(tintColor, for: .normal)
            filterButton.clipsToBounds = true
            filterButton.backgroundColor = UIColor.clear
            xCoord +=  buttonWidth + gapBetweenButtons
            filterButton.titleLabel?.textAlignment = .center
            btnScrollView.addSubview(filterButton)
            
        }
        
        
        btnScrollView.contentSize = CGSize(width: buttonWidth * CGFloat(plistAttayForTextEditOption.count) + gapBetweenButtons * CGFloat((plistAttayForTextEditOption.count*2 + 1)), height: yCoord)
        alighnmentViewHolder.isHidden = true
        collectionViewForTextControls.isHidden = false
    }
}


extension TextEditView: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch currentOption {
        case .Color:   return plistArray.count + 1
        case .Fonts:   return arrayForFont.count
        case .Texture: return 22 // TODO: Fix
        default:       return plistArray1.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 60, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.reusableID  , for: indexPath as IndexPath) as! ColorCell
        
        cell.holderView.isHidden = false
        cell.gradietImv.isHidden = false
        cell.fontLabel.isHidden = true
        cell.textColorView.isHidden = true
        
        switch currentOption {
        case .Texture:
            cell.layer.cornerRadius = cell.frame.size.height/2.0
            cell.gradietImv.isHidden = false
            cell.gradietImv.image = UIImage(named: "Texture" + "\(indexPath.row)")
            cell.holderView.backgroundColor = UIColor.clear
            
        case .Fonts:
            cell.holderView.isHidden = true
            cell.gradietImv.isHidden = true
            cell.textColorView.isHidden = false
            cell.fontLabel.isHidden = false
            var fontName = UIFont(name: arrayForFont[indexPath.row] as! String, size: 25.0)
            cell.fontLabel.font = fontName
            cell.fontLabel.text =  "Text art"
            cell.textColorView.backgroundColor = UIColor.init(red: 128.0/255.0, green: 92.0/255.0, blue: 242.0/255.0, alpha: 1.0)
            cell.textColorView.layer.cornerRadius = 4.0
            cell.layer.cornerRadius = 0.0
            cell.fontLabel.textColor = UIColor.white
            cell.fontLabel.textAlignment = .center
            
        case .Color:
            cell.layer.cornerRadius = cell.frame.size.height/2.0
            cell.gradietImv.isHidden = true
            
            if indexPath.row == 0 {
                cell.gradietImv.image = UIImage(named: "ColorPicker")
                cell.gradietImv.isHidden = false
                cell.holderView.backgroundColor = UIColor.clear
            }
            else if let colorString = plistArray[indexPath.row - 1] as? String {
                cell.holderView.backgroundColor = getColor(colorString: colorString)
                cell.gradietImv.isHidden = true
            }
            
        case .Gradient:
            cell.layer.cornerRadius = cell.frame.size.height/2.0
            cell.gradietImv.image = nil
            cell.gradietImv.isHidden = false
            if let objArray = plistArray1[indexPath.row] as? NSArray {
                var allcolors: [CGColor] = []
                for item in objArray {
                    let color = getColor(colorString: item as? String ?? "")
                    allcolors.append(color.cgColor)
                }
                
                let uimage = UIImage.gradientImageWithBounds(bounds: CGRect(x: 0,y: 0,width: 200,height: 200), colors: allcolors)
                cell.gradietImv.contentMode = .scaleAspectFill
                cell.gradietImv.image = uimage
            }
            
        default: break
        }
  
        print(cell.contentView.frame.size)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)

        UIView.animate(withDuration: 0.5, animations: {
            cell?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { (true) in
            UIView.animate(withDuration: 0.5, animations: {
                cell?.transform =  CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        }
    
        switch currentOption {
        case .Color:
            if indexPath.row == 0 {
                self.delegateForText?.showColorPickerView()
            }
            else if let colorString = plistArray[indexPath.row - 1] as? String {
                
                delegateForText?.colorValue(color: colorString)
            }
        case .Fonts:
            delegateForText?.sendFonrIndex(index: indexPath.row)
        case .Gradient:
            delegateForText?.gradientValue(index: indexPath.row)
        case .Texture:
            delegateForText?.sendTextureIndex(index: indexPath.row)
        default: break
        }
    }
}

extension TextEditView {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView is UICollectionView else { return }

        let centerPoint = CGPoint(
            x: collectionViewForTextControls.frame.size.width / 2 +  scrollView.contentOffset.x,
            y: collectionViewForTextControls.frame.size.height / 2 + scrollView.contentOffset.y
        )

        if let indexPath = collectionViewForTextControls.indexPathForItem(at: centerPoint) {
            centerCell = collectionViewForTextControls.cellForItem(at: indexPath) as? ColorCell
            centerCell?.toZoom()

            switch currentOption {
            case .Color:
                if indexPath.row != 0, let colorString = plistArray[indexPath.row - 1] as? String {
                    delegateForText?.colorValue(color: colorString)
                }
            case .Fonts:
                delegateForText?.sendFonrIndex(index: indexPath.row)
            case .Gradient:
                delegateForText?.gradientValue(index: indexPath.row)
            case .Texture:
                delegateForText?.sendTextureIndex(index: indexPath.row)
            default: break
            }
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
        self.collectionViewForTextControls.scrollToNearestVisibleCollectionViewCell()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.collectionViewForTextControls.scrollToNearestVisibleCollectionViewCell()
        }
    }
}
