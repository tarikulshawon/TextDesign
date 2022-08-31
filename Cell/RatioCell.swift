//
//  RatioCell.swift
//  PosterMaker
//
//  Created by m-sagor-sikdar on 17/12/21.
//

import UIKit

class RatioCell: UICollectionViewCell {
    @IBOutlet weak var iconImv: UIImageView!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var heightForLabel: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public static var reusableID: String {
        return String(describing: RatioCell.self)
    }
    
    public static var nib: UINib {
        return UINib(nibName: reusableID, bundle: nil)
    }
    
    

}
