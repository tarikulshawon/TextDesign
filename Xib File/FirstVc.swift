

import UIKit
import AVFoundation

class FirstVc: UIView, CustomLayoutDelegate, callDelegate {
    func reloadAllData() {
        self.reloadDataF()
    }
    
    var plistArray:NSArray!
    var plistArray1:NSArray!
    var selectedIndex = 0
    var imageIntoObjList = [ImageInfoData]()
    var deleteBtnPressed = false
    var BubbleTimer:Timer?
    
    @IBOutlet weak var collectionViewForImage: UICollectionView!
    @IBOutlet weak var loadingView: UIView!
    
    public var customCollectionViewLayout: UICustomCollectionViewLayout? {
        get {
            return self.collectionViewForImage?.collectionViewLayout as? UICustomCollectionViewLayout
        }
        set {
            if newValue != nil {
                self.collectionViewForImage?.collectionViewLayout = newValue!
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        DBmanager.shared.initDB()
        var maxId = DBmanager.shared.getMaxIdForMerge()
        
        imageIntoObjList = DBmanager.shared.getMergeFolder()
        print(imageIntoObjList.count)

        collectionViewForImage.reloadData()
        
        
        let nibName = UINib(nibName: ColorCell.reusableID, bundle: nil)
        collectionViewForImage.register(nibName, forCellWithReuseIdentifier:  ColorCell.reusableID)
        collectionViewForImage.delegate = self
        collectionViewForImage.dataSource = self
        
        self.customCollectionViewLayout?.delegate = self
        self.customCollectionViewLayout?.numberOfColumns = 3
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        
    }
    
    func reloadDataF() {
        loadingView.backgroundColor = UIColor.white
        loadingView.alpha = 1.0
        imageIntoObjList = DBmanager.shared.getMergeFolder()
        print(imageIntoObjList.count)
        collectionViewForImage.reloadData()
        self.customCollectionViewLayout?.delegate = self
        self.customCollectionViewLayout?.numberOfColumns = 3
        self.customCollectionViewLayout?.cache.removeAll()
        self.customCollectionViewLayout?.prepare()
        self.perform(#selector(self.targetMethod), with: self, afterDelay: 0.001)

    }

    func setupUI() {
        BubbleTimer = Timer.scheduledTimer(timeInterval: 0.06, target: self, selector: #selector(self.startBubble), userInfo: nil, repeats: true)
    }

    @objc
    fileprivate func didReceiveNotification(notification: Notification) {
        self.setupUI()
        reloadDataF()
        self.perform(#selector(self.targetMethod1), with: self, afterDelay: 1.0)
    }

    @objc fileprivate func targetMethod1(){
        BubbleTimer?.invalidate()
        BubbleTimer = nil
    }

    @objc func buttonTapped(sender : UIButton) {
        let btn = sender.tag - 1000
        let obj = imageIntoObjList[btn]
        DBmanager.shared.deleteFile(id: obj.id)
        reloadDataF()
        
    }

    @objc fileprivate func targetMethod(){
        loadingView.alpha = 0
    }
    
    func getFileUrlWithName(fileName: String) -> NSURL {
        
        var fileURL:NSURL!
        let fileManager = FileManager.default
        
        
        do {
            
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            fileURL = documentDirectory.appendingPathComponent(fileName as String) as NSURL
            
        } catch {
            Swift.print(error)
        }
        
        return  fileURL
    }
    
    
    
}


extension FirstVc: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imageIntoObjList.count
    }
    

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.reusableID  , for: indexPath as IndexPath) as! ColorCell
        cell.holderView.isHidden = true
        cell.layer.cornerRadius = 10.0
        //cell.backgroundColor = UIColor.red
        let image = "FileNameS" + imageIntoObjList[indexPath.row].id + ".jpg"
        let filePath = self.getFileUrlWithName(fileName: image)
        
        print(filePath)
        cell.shake()
        
        cell.deleteImv.isHidden = false
        cell.deleteBtn.isHidden = false
        cell.deleteBtn.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        cell.deleteBtn.tag = 1000 + indexPath.row
        
        
        if deleteBtnPressed {
            cell.deleteImv.isHidden = false
            cell.deleteBtn.isHidden = false
            cell.shake()
        } else {
            cell.deleteImv.isHidden = true
            cell.deleteBtn.isHidden = true
            cell.stopShaking()
        }

        
        if let data = try? Data(contentsOf:  filePath as URL) {
            if let image = UIImage(data: data) {
                
                DispatchQueue.main.async {
                     
                    cell.gradietImv.image = image
                }
               
            }
        }

        return cell

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let obj = imageIntoObjList[indexPath.row]
        let imageN = "FileName" + imageIntoObjList[indexPath.row].id + ".jpg"
        let filePath = self.getFileUrlWithName(fileName: imageN)

        
        if let data = try? Data(contentsOf:  filePath as URL) {
            if let image = UIImage(data: data) {
                
                DispatchQueue.main.async {
                     
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc: EditVc = storyboard.instantiateViewController(withIdentifier: "EditVc") as! EditVc
                    vc.modalPresentationStyle = .fullScreen
                    vc.mainImage = image
                   // .present(vc, animated: true, completion: nil)
                    vc.isfromUpdate = true
                    vc.imageInfoObj = obj
                    
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
        
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        
        let image = "FileNameS" + imageIntoObjList[indexPath.row].id + ".jpg"
        let filePath = self.getFileUrlWithName(fileName: image)
        
        if let data = try? Data(contentsOf:  filePath as URL) {
            if let image = UIImage(data: data) {
                let screenSize = UIScreen.main.bounds
                let screenWidth = screenSize.width
                let mainViewWidth = screenWidth;
                let ViewWidth=(mainViewWidth-4*10)/3;
                let height = (ViewWidth*image.size.height)/image.size.width
                _ = AVMakeRect(aspectRatio: image.size, insideRect: CGRect(x: 0,y: 0,width: ViewWidth,height: height))
                return height
               
            }
        }
        
        return 0
        
    }
    
    
}


extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}



extension FirstVc{
    
    @objc func startBubble() ->Void{

        let bubbleImageView = UIImageView()
        
        let intRandom = self.generateIntRandomNumber(min: 1, max: 6)
        
        bubbleImageView.backgroundColor = titleColor
        let size = self.randomFloatBetweenNumbers(firstNum: 9, secondNum: 40)
        
        let randomOriginX = self.randomFloatBetweenNumbers(firstNum: self.frame.minX, secondNum: self.frame.maxX)
        let originy = self.frame.maxY - 35
        
        
        bubbleImageView.frame = CGRect(x: randomOriginX, y: originy, width: CGFloat(size), height: CGFloat(size))
        bubbleImageView.alpha = self.randomFloatBetweenNumbers(firstNum: 0.0, secondNum: 1.0)
        bubbleImageView.layer.cornerRadius = bubbleImageView.frame.size.height / 2
        bubbleImageView.clipsToBounds = true
        self.addSubview(bubbleImageView)
        
        let zigzagPath: UIBezierPath = UIBezierPath()
        let oX: CGFloat = bubbleImageView.frame.origin.x
        let oY: CGFloat = bubbleImageView.frame.origin.y
        let eX: CGFloat = oX
        let eY: CGFloat = oY - (self.randomFloatBetweenNumbers(firstNum: self.frame.midY, secondNum: self.frame.maxY))
        let t = self.randomFloatBetweenNumbers(firstNum: 20, secondNum: 100)
        var cp1 = CGPoint(x: oX - t, y: ((oY + eY) / 2))
        var cp2 = CGPoint(x: oX + t, y: cp1.y)
        
        let r = arc4random() % 2
        if (r == 1){
            let temp:CGPoint = cp1
            cp1 = cp2
            cp2 = temp
        }
        
        zigzagPath.move(to: CGPoint(x: oX, y: oY))
        
        zigzagPath.addCurve(to: CGPoint(x: eX, y: eY), controlPoint1: cp1, controlPoint2: cp2)
        CATransaction.begin()
        CATransaction.setCompletionBlock({() -> Void in
            
            UIView.transition(with: bubbleImageView, duration: 0.1, options: .transitionCrossDissolve, animations: {() -> Void in
                bubbleImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }, completion: {(_ finished: Bool) -> Void in
                bubbleImageView.removeFromSuperview()
            })
        })
        
        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
        pathAnimation.duration = 1.5
        pathAnimation.path = zigzagPath.cgPath
        
        pathAnimation.fillMode = CAMediaTimingFillMode.forwards
        pathAnimation.isRemovedOnCompletion = false
        bubbleImageView.layer.add(pathAnimation, forKey: "movingAnimation")
        CATransaction.commit()
        
    }
    
    func generateIntRandomNumber(min: Int, max: Int) -> Int {
        let randomNum = Int(arc4random_uniform(UInt32(max) - UInt32(min)) + UInt32(min))
        return randomNum
    }
    
    func randomFloatBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    
    
    
}
