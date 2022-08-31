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
