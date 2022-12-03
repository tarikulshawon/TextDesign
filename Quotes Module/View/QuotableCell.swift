//
//  QuotableCell.swift
//  Quotes
//
//  Created by tarikul shawon on 31/10/22.
//

import UIKit

class QuotableCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepare(_ data: Quote) {
        textLabel?.text = "“" + data.content + "”"
        detailTextLabel?.text = "~ " + data.author
    }
    
}
