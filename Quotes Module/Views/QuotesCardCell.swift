//
//  QuotesCardCell.swift
//  TextArt
//
//  Created by tarikul shawon on 18/10/22.
//

import UIKit

class QuotesCardCell: UITableViewHeaderFooterView {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var informationImage: UIImageView!
    
    var delegate: QuotesCardDelegate?
    private var section: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(cellPressed))
        contentView.addGestureRecognizer(gesture)
    }

    func prepare(title: String, count: Int, section: Int, isExpand: Bool, delegate: QuotesCardDelegate) {
        self.title.text = title
        self.section = section
        self.delegate = delegate
        countLabel.text = String(count) + " quotes"
        
//        if isExpand {
//            informationImage.image = UIImage(named: "Expand")
//        } else{
//            informationImage.image = UIImage(named: "Collapse")
//        }
        
    }
    
    @objc
    func cellPressed() {
        delegate?.sendTouchSignal(section ?? 0)
    }
    
}
