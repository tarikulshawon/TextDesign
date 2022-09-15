

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
    
    @objc
    fileprivate func didReceiveNotification(notification: Notification) {
        reloadDataF()
         
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
