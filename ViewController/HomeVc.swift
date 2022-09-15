//
//  HomeVc.swift
//  TextArt
//
//  Created by Sadiqul Amin on 10/8/22.
//

import UIKit
import AVFoundation
import Photos
import PhotosUI

class HomeVc: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet private weak var collectionViewHolder: UIView!
    @IBOutlet private weak var lineHolderView: UIView!

    private var scrollView: UIScrollView!
    private var lineView: UIView!
    private var firstVc: FirstVc!
    private var secondVc: SecondVc!
    private var thirdVc: ThirdVc!
    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.perform(#selector(self.targetMethod1), with: self, afterDelay:0.1)

        // Do any additional setup after loading the view.
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            
        }
        
        dismiss(animated: true) {
            
        }
        
    }

    @objc private func targetMethod1() {
        
        lineView =  UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        lineView.backgroundColor = titleColor
        lineView.tintColor = UIColor.clear
        lineHolderView.addSubview(lineView)
        var rect = lineView.frame
        rect.size.width = lineHolderView.frame.size.width / 3.0
        rect.size.height = lineHolderView.frame.height
        lineView.frame = rect

        let screenWidth = collectionViewHolder.frame.width
        let screenHeight = collectionViewHolder.frame.height
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        collectionViewHolder.addSubview(scrollView)
        scrollView.backgroundColor = UIColor.red

        firstVc = FirstVc.loadFromXib()
        firstVc.frame = CGRect(x: 0,y: 0,width: screenWidth,height: screenHeight)
        scrollView.addSubview(firstVc)
        
        secondVc = SecondVc.loadFromXib()
        secondVc.frame = CGRect(x: screenWidth,y: 0,width: screenWidth,height: screenHeight)
        scrollView.addSubview(secondVc)
        
        let thirdVc = ThirdVc.loadFromXib()
        thirdVc.frame = CGRect(x: 2*screenWidth,y: 0,width: screenWidth,height: screenHeight)
        scrollView.addSubview(thirdVc)

        
        
        scrollView.isScrollEnabled = false
        scrollView.contentSize = CGSize(width: collectionViewHolder.frame.width * 3, height: collectionViewHolder.frame.height)
        
        
    }
    
    private func processSnapShotPhotos () {
        DispatchQueue.main.async {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }

    private func showAlert()
    {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Access Denied",
                message: galleryAccessMessge,
                preferredStyle: UIAlertController.Style.alert
            )
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Allow Access", style: .cancel, handler: { (alert) -> Void in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }

    private func gotoCamerA()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            print("Camera Available")
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera UnAvaialable")
        }
    }

    private func checkCameraPermission() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized: self.gotoCamerA()
        case .denied: alertToEncourageCameraAccessInitially()
        case .notDetermined:  self.gotoCamerA()
        default: alertToEncourageCameraAccessInitially()
        }
    }

    private func alertToEncourageCameraAccessInitially() {
        let alert = UIAlertController(
            title: "Access Denied",
            message: cameraAccesMessge,
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Access", style: .default, handler: { (alert) -> Void in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        present(alert, animated: true, completion: nil)
    }

    private func photoLibraryAvailabilityCheck()
    {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                self.processSnapShotPhotos()
            case .restricted:
                self.showAlert()
            case .denied:
                self.showAlert()
            default:
                // place for .notDetermined - in this callback status is already determined so should never get here
                break
            }
        }
    }

    @IBAction func gotoCameraView(_ sender: Any) {

        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let saveAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.checkCameraPermission()
            
        })
        
        let deleteAction = UIAlertAction(title: "Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.photoLibraryAvailabilityCheck()
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        optionMenu.addAction(saveAction)
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    func selectedUnselectedColor(m1:Bool,
                                 m2:Bool,
                                 m3:Bool) {
        
        
        lbl1.textColor = m1 == true ? titleColor : unselectedColor
        lbl2.textColor = m2 == true ? titleColor : unselectedColor
        lbl3.textColor = m3 == true ? titleColor : unselectedColor
        
    }

    @IBAction func gotoBtn1(_ sender: Any) {

        self.selectedUnselectedColor(m1: true, m2: false, m3: false)
        self.gotoIndex(width: 0, index: 0)
    }

    @IBAction func gotoBtn2(_ sender: Any) {
        self.selectedUnselectedColor(m1: false, m2: true, m3: false)
        self.gotoIndex(width: self.lineHolderView.frame.size.width/3.0, index: 1)
    }

    @IBAction func gotoBtn3(_ sender: Any) {
        
        self.selectedUnselectedColor(m1: false, m2: false, m3: true)
        self.gotoIndex(width: 2*self.lineHolderView.frame.size.width/3.0, index: 2)
    }

    func gotoIndex(width:CGFloat,index:Int) {
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4) {
                var rect = self.lineView.frame
                rect.origin.x = width
                self.lineView.frame = rect
                
                if index == 0 {
                    self.scrollView.contentOffset = CGPoint(x: 0,y: 0)
                }
                else if index == 1{
                    self.scrollView.contentOffset = CGPoint(x: self.collectionViewHolder.frame.size.width,y: 0)
                    
                }
                else {
                    self.scrollView.contentOffset = CGPoint(x: 2*self.collectionViewHolder.frame.size.width,y: 0)
                }
                self.view.layoutIfNeeded()
            }
        }
    }

}


public extension UIView
{
    static func loadFromXib<T>(withOwner: Any? = nil, options: [UINib.OptionsKey : Any]? = nil) -> T where T: UIView
    {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: "\(self)", bundle: bundle)

        guard let view = nib.instantiate(withOwner: withOwner, options: options).first as? T else {
            fatalError("Could not load view from nib file.")
        }
        return view
    }
}
