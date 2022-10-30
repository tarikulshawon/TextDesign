//
//  MakerVc.swift
//  LiveWallPaper
//
//  Created by MacBook on 14/7/20.
//  Copyright © 2020 MacBook. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices


class MakerVc: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var controller = UIImagePickerController()
    
    @IBOutlet weak var viewToHidden: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    
    @IBAction func gotoPreviousView(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func gotoSubscription(_ sender: Any) {
        
    }
    @IBOutlet weak var addImv: UIImageView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }
    
    @IBAction func gotoGalleryPage(_ sender: Any) {
        
        self.photoLibraryAvailabilityCheck()
    }
    
    @objc func reloadDataOfPhoto()
    {
        
        
        DispatchQueue.main.async {
            
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            imagePickerController.mediaTypes = ["public.movie"]
            imagePickerController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.present(imagePickerController, animated: true, completion: nil)

            
            
            
        }
        
    }
    
    func processSnapShotPhotos()
        
    {
        
        self.reloadDataOfPhoto()
        
    }
    func showAlert()
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
    
    func photoLibraryAvailabilityCheck()
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 1
        if let selectedVideo:URL = (info[UIImagePickerController.InfoKey.mediaURL] as? URL) {
            
            
            picker.dismiss(animated: true) {
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VideoTrimmerViewController") as? VideoTrimmerViewController
                vc?.asset = AVAsset.init(url: selectedVideo)
                vc?.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                self.present(vc!, animated: true, completion: nil)
            }
        }
        // 3
        
    }
    func alertToEncourageCameraAccessInitially() {
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
    func checkCamera() {
             let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
             switch authStatus {
             case .authorized: self.gotoCamerA()
             case .denied: alertToEncourageCameraAccessInitially()
             case .notDetermined:  self.gotoCamerA()
             default: alertToEncourageCameraAccessInitially()
             }
         }
    func gotoCamerA()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
          print("Camera Available")

          let imagePicker = UIImagePickerController()
          imagePicker.delegate = self
          imagePicker.sourceType = .camera
          imagePicker.mediaTypes = [kUTTypeMovie as String]
          imagePicker.allowsEditing = true
          imagePicker.videoQuality = .typeHigh

          self.present(imagePicker, animated: true, completion: nil)
      } else {
          print("Camera UnAvaialable")
      }
    }
    @IBAction func takeVideo(_ sender: Any) {
        
          self.checkCamera()
        
    }
    
    
}
