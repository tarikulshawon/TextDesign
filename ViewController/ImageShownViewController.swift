//
//  ImageShownViewController.swift
//  TextArt
//
//  Created by Macbook pro 2020 M1 on 15/10/22.
//

import UIKit

class ImageShownViewController: UIViewController,URLSessionDelegate, URLSessionDownloadDelegate {
    
    var imageDetailArrayF = [ImageDetails]()
    
    
    @IBOutlet weak var collectionViewForImage: UICollectionView!
    
    @IBAction func gotoPreviousView(_ sender: Any) {
        self.dismiss(animated: true)
    }
    func localFilePathForUrl(_ previewUrl: String) -> URL? {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let fullPath = documentsPath.appendingPathComponent((URL(string: previewUrl)?.lastPathComponent)!)
        return URL(fileURLWithPath:fullPath)
    }
    
    func startDownload(_ image: ImageDetails) {
        if((activeDownloads[image.downloadURL!]) != nil) {return}
        if (isFileAvailable(fileName: image.name!)) {return}
        
        if let urlString = image.downloadURL, let url =  URL(string: urlString) {
            let download = DownloadManager(url: urlString)
            download.downloadTask = downloadsSession.downloadTask(with: url)
            download.downloadTask!.resume()
            download.isDownloading = true
            activeDownloads[download.url] = download
        }
    }
    
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        // 1
        if let originalURL = downloadTask.originalRequest?.url?.absoluteString,
           let destinationURL = localFilePathForUrl(originalURL) {
            
            //print(destinationURL)
            
            // 2
            let fileManager = FileManager.default
            do {
                try fileManager.removeItem(at: destinationURL)
            } catch {
                // Non-fatal: file probably doesn't exist
            }
            do {
                try fileManager.copyItem(at: location, to: destinationURL)
            } catch let error as NSError {
                print("Could not copy file to disk: \(error.localizedDescription)")
            }
        }
        
        // 3
        if let url = downloadTask.originalRequest?.url?.absoluteString {
            print("Removing url:\(url)")
            activeDownloads[url] = nil
            
            
            
            DispatchQueue.main.async { [self] in
                collectionViewForImage.reloadData()
            }
            
            
            
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("\(bytesWritten) == \(totalBytesWritten) == \(totalBytesExpectedToWrite)")
        if let downloadUrl = downloadTask.originalRequest?.url?.absoluteString,
           let download = activeDownloads[downloadUrl] {
            download.progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
            print("Progress Size: \(download.progress)");
            DispatchQueue.main.async(execute: {
                
            })
        }
    }
    
    
    
    lazy var downloadsSession: Foundation.URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "bgSessionConfiguration")
        let session = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        return session
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: ColorCell.reusableID, bundle: nil)
        collectionViewForImage.register(nibName, forCellWithReuseIdentifier:  ColorCell.reusableID)
        collectionViewForImage.delegate = self
        collectionViewForImage.dataSource = self
        // Do any additional setup after loading the view.
    }
    
}
extension ImageShownViewController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
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
        return imageDetailArrayF.count
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
        
        
        var imageValue = imageDetailArrayF[indexPath.row]
        if (isFileAvailable(fileName: imageValue.name!)) {
            let im = UIImage.init(contentsOfFile: getFilePathWithName(fileName: imageValue.name!))
            
            if(im == nil) {
                let fileManager = FileManager.default
                do {
                    try fileManager.removeItem(at: getFileUrlWithName(fileName: imageValue.name!))
                } catch {
                }
            }
            cell.gradietImv.image = im?.resizeImage(targetSize: CGSize(width: 200, height: 200))
        }else {
            cell.gradietImv.image = UIImage.init(named: "bg")
        }
        
        self.startDownload(imageValue)
        
        cell.gradietImv.contentMode = .scaleAspectFill
        cell.holderView.backgroundColor = UIColor.clear
        cell.layer.cornerRadius = 10.0
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var imageValue = imageDetailArrayF[indexPath.row]
        if (isFileAvailable(fileName: imageValue.name!)) {
            let im = UIImage.init(contentsOfFile: getFilePathWithName(fileName: imageValue.name!))
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: EditVc = storyboard.instantiateViewController(withIdentifier: "EditVc") as! EditVc
            vc.modalPresentationStyle = .fullScreen
            vc.mainImage = im
            present(vc, animated: true, completion: nil)
            
        }
            
        
    }
}
