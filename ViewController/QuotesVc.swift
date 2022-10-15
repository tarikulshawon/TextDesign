//
//  QuotesVc.swift
//  TextArt
//
//  Created by Macbook pro 2020 M1 on 15/10/22.
//

import UIKit

class QuotesVc: UIViewController,UITableViewDelegate, UITableViewDataSource {
     
    var quotesArray:NSArray!
    var headerName = [String]()

    @IBAction func gotoPreviousvIEW(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = Bundle.main.path(forResource: "Motivational", ofType: "plist")
        quotesArray = NSArray(contentsOfFile: path!)
        
        for ma in quotesArray {
            
            if let a = ma as? Dictionary<String, Any> ,let b = a["types"] as? String{
                headerName.append(b)
            }
            
            
        }

        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.lightGray.withAlphaComponent(1.0)
        let headerLabel = UILabel(frame: CGRect(x: 30, y: 0, width:
        tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = UIFont.systemFont(ofSize: 20)
        headerLabel.textColor = UIColor.white
        headerLabel.text = headerName[section]
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        return headerView
    }
    
    
     func numberOfSections(in tableView: UITableView) -> Int {
         return  quotesArray.count
   }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var lol = quotesArray[section]
        if let a = lol as? Dictionary<String, Any> ,let b = a["items"] as? NSArray{
            return b.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuotesCell") as? QuotesCell else {
            return QuotesCell()
        }
        
        var lol = quotesArray[indexPath.section]
        if let a = lol as? Dictionary<String, Any> ,let b = a["items"] as? NSArray{
            cell.quotesL.text = b[indexPath.row] as? String
        }
        
       
      
        return cell
        
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
