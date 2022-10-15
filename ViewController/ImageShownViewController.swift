//
//  ImageShownViewController.swift
//  TextArt
//
//  Created by Macbook pro 2020 M1 on 15/10/22.
//

import UIKit

class ImageShownViewController: UIViewController,URLSessionDelegate, URLSessionDownloadDelegate {
    
    
    func localFilePathForUrl(_ previewUrl: String) -> URL? {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let fullPath = documentsPath.appendingPathComponent((URL(string: previewUrl)?.lastPathComponent)!)
        return URL(fileURLWithPath:fullPath)
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

        // Do any additional setup after loading the view.
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
