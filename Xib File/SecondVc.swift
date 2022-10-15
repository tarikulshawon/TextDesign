//
//  SecondVc.gswift
//  PosterMaker
//
//  Created by m-sagor-sikdar on 18/12/21.
//

import UIKit



class SecondVc: UIView {
    @IBOutlet weak var categoryTableview: UITableView!
    var plistArrayImage:NSArray!
    
    override init(frame:CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        categoryTableview.separatorStyle = .none
        let value:CGFloat = (350*categoryTableview.frame.size.width)/1130
        print(value)
        self.categoryTableview.rowHeight = value
        
        let path = Bundle.main.path(forResource: "category", ofType: "plist")
        plistArrayImage = NSArray(contentsOfFile: path!)
        
        
        
        for item in plistArrayImage {
            print(item)
        }
        
        categoryTableview.delegate = self
        categoryTableview.dataSource = self
        
        let nibName = UINib(nibName: CategoryCell.cellID, bundle: nil)
        categoryTableview.register(nibName, forCellReuseIdentifier: CategoryCell.cellID)
        
        if(isFileAvailable(fileName: "wallpapers.json")) {
            getData()
        }
    }
    
    func createFormattedData() {
        dataDicRoot = dataArrRoot?.object(at: 0) as? NSDictionary
        var i = 0
        if let items = dataDicRoot?.value(forKey: "headerItem") as? NSArray {
            for item in items {
                var currentCategory = ((item as! NSDictionary).object(forKey: "itemName") as? String)!
                var ish = currentCategory
                //print("i: \(i) \(item)")
                i = i + 1
                var j = 0
                currentCategory = currentCategory.replacingOccurrences(of: " ", with: "%20")
                if let images = (item as! NSDictionary).object(forKey: "images") as? NSArray {
                    
                    var tmpImgDetailsArray = [ImageDetails]()
                    for imageOb in images {
                        //print("j: \(j) \(images.count)")
                        j = j+1
                        let name = ((imageOb as AnyObject).object(forKey: "imageName") as? String)!
                        let imageName = "\(name)"
                        let url = "\(AppURL.baseUrl)\(currentCategory)/\(imageName)"
                        tmpImgDetailsArray.append(ImageDetails(name: imageName, type: "Image", downloadURL: url))
                    }
                    
                    
                    for item1 in plistArrayImage {
                        
                        var valuem = item1 as? String
                        
                        if item1 as! String == "Blur1" {
                            valuem = "Blur"
                        }
                        if ish.contains(valuem ?? "") {
                            imageDetailArrayFilter.append(ImageType(typeName: item1 as? String ?? "" , imageDetailArray: tmpImgDetailsArray))
                            break
                        }
                        
                    }
                    tmpImgDetailsArray.removeAll()
                    
                    
                    
                    
                }
                
            }
        }
        for item in imageDetailArrayFilter {
            print(item.typeName)
        }
    }
    
    func getData() {
        let file = getFileUrlWithName(fileName: "wallpapers.json")
        do {
            let data = try Data(contentsOf: file)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            if let object = json as? NSArray {
                dataArrRoot = object
                createFormattedData()
                //print(object)
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


extension SecondVc: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        plistArrayImage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.cellID) as? CategoryCell else {
            return CategoryCell()
        }
        if let value = plistArrayImage[indexPath.row] as? String {
            cell.categoryImv.image = UIImage(named: value)
        }
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt
     indexPath: IndexPath){
        
        var value = plistArrayImage[indexPath.row]
        var selectedArray = [ImageDetails]()
        for item in imageDetailArrayFilter {
            if item.typeName == value as? String {
                selectedArray = item.imageDetailArray
            }
        }
        
        DispatchQueue.main.async {
             
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: ImageShownViewController = storyboard.instantiateViewController(withIdentifier: "ImageShownViewController") as! ImageShownViewController
            vc.imageDetailArrayF = selectedArray
            
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
