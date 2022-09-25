import UIKit

class PanControllerImageView: UIImageView, UIGestureRecognizerDelegate {
    var textView: TextStickerView!
    var initialFrame: CGRect!
    var initialFontSize: CGFloat!
    var initialDist: CGFloat!
    var initialCenter: CGPoint!
    var deltaAngle: CGFloat!
    var panControllerSize: CGFloat = 25
    var pController: PanControllerImageView!
    var delegate: UpdateTextFontSize!
    var gesture: UIPanGestureRecognizer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        gesture = panGesture
        self.image = UIImage(named: "Rotate")
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(panGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addDelegate(delegate: UpdateTextFontSize) {
        self.delegate = delegate
    }
}

extension PanControllerImageView {
    //MARK: Add Gesture
    func addGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        gesture = panGesture
        addGestureRecognizer(panGesture)
    }
    
    func updateFrame() {
        /// initialization
        guard let superview = superview else { return }
        
        let location = gesture.location(in: superview.superview)
        let center = superview.center
        
        if let foundView = superview.viewWithTag(1000) {
            textView = (foundView as! TextStickerView)
        }
        
        deltaAngle = CGFloat(atan2f(Float(location.y - center.y), Float(location.x - center.x))) - CGAffineTransformGetAngle(superview.transform)
        
        initialDist = CGPointGetDistance(point1: center, point2: location)
        initialFontSize = textView.font!.pointSize
        
        /// Update when textView is present
        guard (textView != nil) else { return }
        
        let angle = atan2f(Float(location.y - center.y), Float(location.x - center.x))
        let angleDiff = Float (deltaAngle) - angle
        superview.transform = CGAffineTransform(rotationAngle: CGFloat(-angleDiff))
        
        let scale = (CGPointGetDistance(point1: center, point2: location) / initialDist)
        
        textView.font = UIFont(name: textView.font!.fontName, size: initialFontSize * scale)
        let newSize = textView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        
        let containerSize = CGSize(width: newSize.width + (panControllerSize * 2), height: newSize.height + (panControllerSize * 2))
        let textviewSize = CGSize(width: newSize.width, height: newSize.height)
        
        textView.bounds.size = textviewSize
        textView.frame.origin = CGPoint(x: (gesture.view?.superview!.bounds.origin)!.x + panControllerSize, y: (gesture.view?.superview!.bounds.origin)!.y + panControllerSize)
        gesture.view?.superview!.bounds.size = containerSize
        
        /// re-draw
        gesture.view?.superview!.drawBorder(
            frame: CGRect(
                x: panControllerSize * 0.5,
                y: panControllerSize * 0.5,
                width: containerSize.width - panControllerSize,
                height: containerSize.height - panControllerSize
            ),
            zoomScale: UIScreen.main.scale)
    }
    
    @objc
    func handlePanGesture(gesture: UIPanGestureRecognizer){
        let location = gesture.location(in: self.superview!.superview)
        let center = self.superview!.center
        switch gesture.state {
        case .began:
            for sub in self.superview!.subviews  {
                if sub.tag == 1000{
                    self.textView = (sub as! TextStickerView)
                }
            }
            //self.textView.text = self.
            self.deltaAngle = CGFloat(atan2f(Float(location.y - center.y), Float(location.x - center.x))) - CGAffineTransformGetAngle(self.superview!.transform)
            
            self.initialDist = CGPointGetDistance(point1: center, point2: location)
            self.initialFontSize = self.textView.font!.pointSize
            
            break
        case .changed:
            guard let textView = textView else {
                print("Text view is nil")
                return
            }
            
            let angle = atan2f(Float(location.y - center.y), Float(location.x - center.x))
            let angleDiff = Float (self.deltaAngle) - angle
            self.superview!.transform = CGAffineTransform(rotationAngle: CGFloat(-angleDiff))
            
            let scale = (CGPointGetDistance(point1: center, point2: location) / self.initialDist)
            
            textView.font = UIFont(name: textView.font!.fontName, size: initialFontSize * scale)
            let newSize = textView.sizeThatFits(
                CGSize(
                    width: CGFloat.greatestFiniteMagnitude,
                    height: CGFloat.greatestFiniteMagnitude
                )
            )
            
            let containerSize = CGSize(
                width: newSize.width + panControllerSize * 2,
                height: newSize.height + panControllerSize * 2
            
            )
            let textviewSize = CGSize(width: newSize.width, height: newSize.height)
            
            textView.bounds.size = textviewSize
            textView.frame.origin = CGPoint(
                x: (gesture.view?.superview!.bounds.origin)!.x + panControllerSize,
                y: (gesture.view?.superview!.bounds.origin)!.y + panControllerSize
            )
            
            gesture.view?.superview!.bounds.size = containerSize
            
            gesture.view?
                .superview!
                .drawBorder(
                    frame: CGRect(x: panControllerSize * 0.5,
                                  y: panControllerSize * 0.5,
                                  width: containerSize.width - (1 * panControllerSize),
                                  height: containerSize.height - (1 * panControllerSize)),
                    zoomScale: UIScreen.main.scale
                )
            
            textView.fontSize = textView.font?.pointSize
            break
        case .ended:
            delegate.updateFontSize(to: textView.fontSize)
            print("[PanControllerImageView] PanGesture Ended")
            break
        default:
            print("Not Match")
        }
    }
}
