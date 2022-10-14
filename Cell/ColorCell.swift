//
//  ColorCell.swift
//  PosterMaker
//
//  Created by m-sagor-sikdar on 19/12/21.
//

import UIKit

class ColorCell: UICollectionViewCell {
    
    
    @IBOutlet weak var textColorView: UIView!
    @IBOutlet weak var deleteImv: UIImageView!
    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var gradietImv: UIImageView!
    @IBOutlet weak var fontLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public static var reusableID: String {
        return String(describing: ColorCell.self)
    }
    
    public static var nib: UINib {
        return UINib(nibName: reusableID, bundle: nil)
    }
    
    
    func shake() {
        let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
        shakeAnimation.duration = 0.20
        shakeAnimation.repeatCount = 2
        shakeAnimation.autoreverses = true
        let startAngle: Float = (-2) * 3.14159/180
        let stopAngle = -startAngle
        shakeAnimation.fromValue = NSNumber(value: startAngle as Float)
        shakeAnimation.toValue = NSNumber(value: stopAngle as Float)
        shakeAnimation.autoreverses = true
        shakeAnimation.duration = 0.15
        shakeAnimation.repeatCount = 10000
        shakeAnimation.timeOffset = 290 * drand48()

        let layer: CALayer = self.layer
        layer.add(shakeAnimation, forKey:"shaking")
    }

    func stopShaking() {
        let layer: CALayer = self.layer
        layer.removeAnimation(forKey: "shaking")
    }
    
    func toZoom() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.layer.borderColor = UIColor.white.cgColor
            self.layer.borderWidth = 1.3
        }
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    func toOriginal() {
        UIView.animate(withDuration: 0.2) {
            self.layer.borderWidth = 0
            self.transform = .identity
        }
    }
}
