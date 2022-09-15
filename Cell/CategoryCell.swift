//
//  CategoryCell.swift
//  PosterMaker
//
//  Created by m-sagor-sikdar on 18/12/21.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    
    @IBOutlet weak var categoryImv: UIImageView!
    class var cellID: String {
        String(describing: CategoryCell.self)
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
