//
//  DrawVc.swift
//  PosterMaker
//
//  Created by m-sagor-sikdar on 21/12/21.
//

import UIKit

protocol colorIndexSend: AnyObject {
    func colorIndex(tag:Int ,colorV: UIColor)
}

class DrawVc: UIView {
    
    weak var delegateForDraw: colorIndexSend?


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    @IBAction func gotoColor(_ sender: Any) {
        if let value = sender as? UIButton {
            self.delegateForDraw?.colorIndex(tag: value.tag - 1000, colorV: UIColor.black)
        }
    }
    
    

}
