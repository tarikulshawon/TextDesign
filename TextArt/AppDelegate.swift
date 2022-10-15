//
//  AppDelegate.swift
//  TextArt
//
//  Created by Sadiqul Amin on 10/8/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var fontArray:NSMutableArray!


    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        DBmanager.shared.initDB()
        
       
        
    
        
        let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileUrl = documentDirectoryUrl?.appendingPathComponent("wallpapers.json")
        
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: fileUrl!)
        } catch {
            // Non-fatal: file probably doesn't exist
        }
        
        checkInternet()
        self.loadData()
        
        if(isFileAvailable(fileName: "wallpapers.json")) {
            getData()
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func downloadVideoLinkAndCreateAsset(_ fileLink: String) {
        URLSession.shared.dataTask(with: NSURL(string: fileLink)! as URL, completionHandler: { (data, response, error) -> Void in
            // Check if data was received successfully
            if error == nil && data != nil {
                 saveToJsonFile(data: data!)
                /*
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                        if let object = json as? NSArray {
                            jsonArray = object
                            print(object)
                        } else if let object = json as? [Any] {
                            // json is an array
                            print(object)
                        }
                } catch {
                    print(error.localizedDescription)
                }*/
            }
        }).resume()
    }
    
    
    func checkInternet () {
        if(isConnectedToNetwork()) {
            self.downloadVideoLinkAndCreateAsset(AppURL.baseUrl.appending(ServerFileName.menuName))
        }else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                let alertView = UIAlertController(title: "Error", message: "The internet connection appears to be offline.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    
                })
                alertView.addAction(action)
                let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

                if var topController = keyWindow?.rootViewController {
                    while let presentedViewController = topController.presentedViewController {
                        topController = presentedViewController
                    }
                    topController.present(alertView, animated: true, completion: nil)
                }
            })
        }
    }
    
    
    public func getData() {
        do {
            let file = getFileUrlWithName(fileName: "wallpapers.json")
            do {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? NSArray {
                    
                    
                    dataArr = object
                } else if let object = json as? [Any] {
                    // json is an array
                    print(object)
                } else {
                    print("JSON is invalid")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func stringByAppendingPathComponent(fileName: String) -> String {
        
        let path = Bundle.main.path(forResource: "Fonts", ofType: "")
        let nsSt = path! as NSString
        return nsSt.appendingPathComponent(fileName)
    }

    func loadData()
    {
        fontArray = NSMutableArray()
        
        do {
            let path = Bundle.main.path(forResource: "Fonts", ofType: "")
            let fileList = try FileManager.default.contentsOfDirectory(atPath: path!)
            
            for item in fileList {
                
                let fileName :NSString!
                fileName = (item as NSString)
                NSLog("sadiqul amin %@", fileName)
                let writePath = self.stringByAppendingPathComponent(fileName: fileName as String)
                self.registerFontWith(path: writePath)
                
                
            }
            
            
        } catch {
            //handle error
            print(error)
        }
        arrayForFont = NSArray.init(array: fontArray)
       // Store.sharedInstance.setfontArray(array: arrayForFont)
        //Store.sharedInstance.setFontName(name: arrayForFont![0] as! NSString)
        
        
    }
    
    func registerFontWith(path: String) {
        if let fontData = NSData(contentsOfFile: path), let dataProvider = CGDataProvider.init(data: fontData) {
            
            
            let fontRef = CGFont.init(dataProvider)
            var errorRef: Unmanaged<CFError>? = nil
            if (CTFontManagerRegisterGraphicsFont(fontRef!, &errorRef) == false) {
                print("Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
            }
            let fontName = fontRef!.postScriptName
            let name:NSString = NSString(string:fontName!)
            fontArray.add(name)
            NSLog("%@", name)
        }
        
    }

}



extension UserDefaults {
    func object<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = self.value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(type.self, from: data)
    }

    func set<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) {
        let data = try? encoder.encode(object)
        self.set(data, forKey: key)
    }
}
