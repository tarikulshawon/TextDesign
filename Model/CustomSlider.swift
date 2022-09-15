import UIKit

class CustomSlider: UISlider {

    @IBInspectable var thumbImage: UIImage?

    // MARK: Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        thumbImage = UIImage(named: "slider")

        if let thumbImage = thumbImage {
            self.setThumbImage(thumbImage, for: .normal)
        }
    }
}
