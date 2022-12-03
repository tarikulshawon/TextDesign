//
//  TagableCell.swift
//  Quotes
//
//  Created by tarikul shawon on 31/10/22.
//

import UIKit

class TagableCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func prepare(_ data: Tag) {
        label.text = data.name
    }
}
