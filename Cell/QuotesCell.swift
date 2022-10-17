//
//  Quotes.swift
//  TextArt
//
//  Created by Macbook pro 2020 M1 on 15/10/22.
//

import UIKit

class QuotesCell: UITableViewCell {

    @IBOutlet weak var quotesL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension UILabel {
    func setHighlighted(_ text: String, with search: String?) {
        guard let search else { return }
        let attributedText = NSMutableAttributedString(string: text)
        let range = NSString(string: text).range(of: search, options: .caseInsensitive)
        let highlightColor = UIColor.systemYellow
        let highlightedAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)
        ]
        
        attributedText.addAttributes(highlightedAttributes, range: range)
        self.attributedText = attributedText
    }
}
