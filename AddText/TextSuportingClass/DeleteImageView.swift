//
//  File.swift
//  DemoTextSticker
//
//  Created by Mehedi on 3/5/22.
//

import UIKit

protocol DeleteImageViewDeleagte: NSObject {
    func delete()
}

class DeleteImageView: UIImageView {
    
    lazy var tapGesture: UITapGestureRecognizer = {
        let t = UITapGestureRecognizer(target: self, action: #selector(handleTapped))
        t.numberOfTapsRequired = 1
        self.isUserInteractionEnabled = true
        return t
    }()
    weak var delegateDelete : DeleteImageViewDeleagte?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.image = UIImage(named: "Close")
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: Delete Sticker
    @objc func handleTapped(gesture: UITapGestureRecognizer){
        if let delegate = delegateDelete{
            delegate.delete()
        }
        
    }
}
