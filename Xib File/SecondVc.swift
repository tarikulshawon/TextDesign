//
//  SecondVc.swift
//  PosterMaker
//
//  Created by m-sagor-sikdar on 18/12/21.
//

import UIKit

class SecondVc: UIView {
    @IBOutlet weak var categoryTableview: UITableView!
    var plistArray:NSArray!

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
        plistArray = NSArray(contentsOfFile: path!)
        

        
        for item in plistArray {
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
                        print(url);
                        tmpImgDetailsArray.append(ImageDetails(name: imageName, type: "Image", downloadURL: url))
                    }
                    imageDetailsArray.add(tmpImgDetailsArray)
                    tmpImgDetailsArray.removeAll()
                }
            }
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
        plistArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.cellID) as? CategoryCell else {
            return CategoryCell()
        }
        if let value = plistArray[indexPath.row] as? String {
            cell.categoryImv.image = UIImage(named: value)
        }
        cell.selectionStyle = .none
        return cell
        
    }
    
}
