//
//  SettingVc.swift
//  PosterMaker
//
//  Created by m-sagor-sikdar on 24/12/21.
//

import UIKit

class SettingVc: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var upgradeLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var settingTableView: UITableView!
    var firstArray = ["Export Quality","Restore purchases","Rate Us"]
    var secondArray = ["Follow On Instragram"]
    var thirdArray = ["Subscription Info","Term of Use","Privacy policy"]
    var fourthArray = ["Send Us FeedBack"]
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
        upgradeLabel.text = "Unlimited Acess to all premium Feature"

        cancelBtn.tintColor = titleColor
        // Do any additional setup after loading the view.
        
        let nibName = UINib(nibName: SettingCell.cellID, bundle: nil)
        settingTableView.register(nibName, forCellReuseIdentifier: SettingCell.cellID)
        settingTableView.rowHeight = 50.0
        
        
    }
    func getHeight(section:Int)->CGFloat {
        if section == 3 {
            return 20
        }
        if section == 2 {
            return 10
        }
        return 0
        
    }
    
    func getRowName(index: Int,row: Int) -> String {
        if index == 0 {
            return firstArray[row]
        } else if index == 1 {
            return secondArray[row]
        }
        else if index == 2 {
            return thirdArray[row]
        }
        
        return fourthArray[row]
    }
    

    @IBAction func gotoPreviousView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.getHeight(section: section)))
        view.backgroundColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        return view
    }
    
    
     func numberOfSections(in tableView: UITableView) -> Int {
       return  4
   }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return getHeight(section: section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return firstArray.count
        } else if section == 1 {
            return secondArray.count
        }
        else if section == 2 {
            return thirdArray.count
        }
        
        return fourthArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.cellID) as? SettingCell else {
            return SettingCell()
        }
        var name = self.getRowName(index: indexPath.section, row: indexPath.row)
        cell.settingName.text = name
        cell.selectionStyle = .none
       // cell.accessoryType = .disclosureIndicator
        
        if indexPath.row == indexPath.section {
            cell.segmentView.isHidden = false
            cell.accessoryType = .none
        } else {
            cell.segmentView.isHidden = true
            cell.accessoryType = .disclosureIndicator
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
