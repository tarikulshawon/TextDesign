//
//  SettingCell.swift
//  PosterMaker
//
//  Created by m-sagor-sikdar on 24/12/21.
//

import UIKit

class SettingCell: UITableViewCell {
    
    
    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var settingName: UILabel!
    class var cellID: String {
        String(describing: SettingCell.self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
