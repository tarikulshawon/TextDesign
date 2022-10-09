//
//  StickerView.swift
//  StickerView
//
//  Copyright © All rights reserved.
//

import UIKit

public enum StickerViewHandler:Int {
    case close = 0
    case rotate
    case flip
}

public enum StickerViewPosition:Int {
    case topLeft = 0
    case topRight
    case bottomLeft
    case bottomRight
}

@inline(__always) func CGRectGetCenter(_ rect:CGRect) -> CGPoint {
    return CGPoint(x: rect.midX, y: rect.midY)
}

@inline(__always) func CGRectScale(_ rect:CGRect, wScale:CGFloat, hScale:CGFloat) -> CGRect {
    return CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width * wScale, height: rect.size.height * hScale)
}

@inline(__always) func CGAffineTransformGetAngle(_ t:CGAffineTransform) -> CGFloat {
    return atan2(t.b, t.a)
}

@inline(__always) func CGPointGetDistance(point1:CGPoint, point2:CGPoint) -> CGFloat {
    let fx = point2.x - point1.x
    let fy = point2.y - point1.y
    return sqrt(fx * fx + fy * fy)
}

@objc public  protocol StickerViewDelegate {
    @objc func stickerViewDidBeginMoving(_ stickerView: StickerView)
    @objc func stickerViewDidChangeMoving(_ stickerView: StickerView)
    @objc func stickerViewDidEndMoving(_ stickerView: StickerView)
    @objc func stickerViewDidBeginRotating(_ stickerView: StickerView)
    @objc func stickerViewDidChangeRotating(_ stickerView: StickerView)
    @objc func stickerViewDidEndRotating(_ stickerView: StickerView)
    @objc func stickerViewDidClose(_ stickerView: StickerView)
    @objc func stickerViewDidTap(_ stickerView: StickerView)
}

public class StickerView: UIView {
    
    var initFrame: CGRect = .zero
    var initCenter: CGPoint = .zero
    var pathName:String!
    var pathType:String!
    var opacity  = 1.0
    var brightness:Float = 0.0
    var contrast:Float =  1.0
    var saturation:Float = 1.0
    var sharpen:Float  = 0.0
    var border = 0.0

    
    public var delegate: StickerViewDelegate!
    /// The contentView inside the sticker view.
    public var contentView:UIImageView!
    /// Enable the close handler or not. Default value is YES.
    public var enableClose:Bool = true {
        didSet {
            if self.showEditingHandlers {
                self.setEnableClose(self.enableClose)
            }
        }
    }
    /// Enable the rotate/resize handler or not. Default value is YES.
    public var enableRotate:Bool = true{
        didSet {
            if self.showEditingHandlers {
                self.setEnableRotate(self.enableRotate)
            }
        }
    }
    /// Enable the flip handler or not. Default value is YES.
    public var enableFlip:Bool = true
    /// Show close and rotate/resize handlers or not. Default value is YES.
    public var showEditingHandlers:Bool = true {
        didSet {
            if self.showEditingHandlers {
                self.setEnableClose(self.enableClose)
                self.setEnableRotate(self.enableRotate)
                self.setEnableFlip(self.enableFlip)
                self.contentView?.layer.borderWidth = 1
            }
            else {
                self.setEnableClose(false)
                self.setEnableRotate(false)
                self.setEnableFlip(false)
                self.contentView?.layer.borderWidth = 0
            }
        }
    }
    
    /// Minimum value for the shorter side while resizing. Default value will be used if not set.
    private var _minimumSize:NSInteger = 0
    public  var minimumSize:NSInteger {
        set {
            _minimumSize = max(newValue, self.defaultMinimumSize)
        }
        get {
            return _minimumSize
        }
    }
    /// Color of the outline border. Default: brown color.
    private var _outlineBorderColor:UIColor = .clear
    public  var outlineBorderColor:UIColor {
        set {
            _outlineBorderColor = newValue
            self.contentView?.layer.borderColor = _outlineBorderColor.cgColor
        }
        get {
            return _outlineBorderColor
        }
    }
    /// A convenient property for you to store extra information.
    public  var userInfo:Any?
    
    /**
     *  Initialize a sticker view. This is the designated initializer.
     *
     *  @param contentView The contentView inside the sticker view.
     *                     You can access it via the `contentView` property.
     *
     *  @return The sticker view.
     */
    public  init(contentView: UIImageView) {
        self.defaultInset = 11
        self.defaultMinimumSize = 4 * self.defaultInset
        
        var frame = contentView.frame
        frame = CGRect(x: 0, y: 0, width: frame.size.width + CGFloat(self.defaultInset) * 2, height: frame.size.height + CGFloat(self.defaultInset) * 2)
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.addGestureRecognizer(self.moveGesture)
        self.addGestureRecognizer(self.tapGesture)
        self.addGestureRecognizer(self.pinchGestureRecognizer)
        self.addGestureRecognizer(self.rotateConGes)
        // Setup content view
        self.contentView = contentView
        self.contentView.center = CGRectGetCenter(self.bounds)
        self.contentView.isUserInteractionEnabled = false
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.layer.allowsEdgeAntialiasing = true
        self.addSubview(self.contentView)
        
        // Setup editing handlers
        self.setPosition(.topRight, forHandler: .close)
        self.addSubview(self.closeImageView)
        //self.closeImageView.backgroundColor = UIColor.green
        self.setPosition(.bottomRight, forHandler: .rotate)
        self.addSubview(self.rotateImageView)
        //self.rotateImageView.backgroundColor  = UIColor.green
        self.setPosition(.topLeft, forHandler: .flip)
        self.addSubview(self.flipImageView)
        
        self.showEditingHandlers = true
        self.enableClose = true
        self.enableRotate = true
        self.enableFlip = true
        
        self.minimumSize = self.defaultMinimumSize
        self.outlineBorderColor = .brown
    }
    
    public  required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     *  Use image to customize each editing handler.
     *  It is your responsibility to set image for every editing handler.
     *
     *  @param image   The image to be used.
     *  @param handler The editing handler.
     */
    public func setImage(_ image:UIImage, forHandler handler:StickerViewHandler) {
        switch handler {
        case .close:
            self.closeImageView.image = image
        case .rotate:
            self.rotateImageView.image = image
        case .flip:
            self.flipImageView.image = image
        }
    }
    
    /**
     *  Customize each editing handler's position.
     *  If not set, default position will be used.
     *  @note  It is your responsibility not to set duplicated position.
     *
     *  @param position The position for the handler.
     *  @param handler  The editing handler.
     */
    
    public func setPosition(_ position:StickerViewPosition, forHandler handler:StickerViewHandler) {
        let origin = self.contentView.frame.origin
        let size = self.contentView.frame.size
        
        var handlerView:UIImageView?
        switch handler {
        case .close:
            handlerView = self.closeImageView
        case .rotate:
            handlerView = self.rotateImageView
        case .flip:
            handlerView = self.flipImageView
        }
        
        switch position {
        case .topLeft:
            handlerView?.center = origin
            handlerView?.autoresizingMask = [.flexibleRightMargin, .flexibleBottomMargin]
        case .topRight:
            handlerView?.center = CGPoint(x: origin.x + size.width, y: origin.y)
            handlerView?.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        case .bottomLeft:
            handlerView?.center = CGPoint(x: origin.x, y: origin.y + size.height)
            handlerView?.autoresizingMask = [.flexibleRightMargin, .flexibleTopMargin]
        case .bottomRight:
            handlerView?.center = CGPoint(x: origin.x + size.width, y: origin.y + size.height)
            handlerView?.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin]
        }
        
        handlerView?.tag = position.rawValue
    }
    
    /**
     *  Customize handler's size
     *
     *  @param size Handler's size
     */
    public func setHandlerSize(_ size:Int) {
        if size <= 0 {
            return
        }
        
        self.defaultInset = NSInteger(round(Float(size) / 2))
        self.defaultMinimumSize = 4 * self.defaultInset
        self.minimumSize = max(self.minimumSize, self.defaultMinimumSize)
        
        let originalCenter = self.center
        let originalTransform = self.transform
        var frame = self.contentView.frame
        frame = CGRect(x: 0, y: 0, width: frame.size.width + CGFloat(self.defaultInset) * 2, height: frame.size.height + CGFloat(self.defaultInset) * 2)
        
        self.contentView.removeFromSuperview()
        
        self.transform = CGAffineTransform.identity
        self.frame = frame
        
        self.contentView.center = CGRectGetCenter(self.bounds)
        self.addSubview(self.contentView)
        self.sendSubviewToBack(self.contentView)
        
        let handlerFrame = CGRect(x: 0, y: 0, width: self.defaultInset * 2, height: self.defaultInset * 2)
        self.closeImageView.frame = handlerFrame
        self.setPosition(StickerViewPosition(rawValue: self.closeImageView.tag)!, forHandler: .close)
        self.rotateImageView.frame = handlerFrame
        self.setPosition(StickerViewPosition(rawValue: self.rotateImageView.tag)!, forHandler: .rotate)
        self.flipImageView.frame = handlerFrame
        self.setPosition(StickerViewPosition(rawValue: self.flipImageView.tag)!, forHandler: .flip)
        
        self.center = originalCenter
        self.transform = originalTransform
    }
    
    /**
     *  Default value
     */
    public var defaultInset:NSInteger
    private var defaultMinimumSize:NSInteger
    
    /**
     *  Variables for moving viewes
     */
    private var beginningPoint = CGPoint.zero
    private var beginningCenter = CGPoint.zero
    
    /**
     *  Variables for rotating and resizing viewes
     */
    private var initialBounds = CGRect.zero
    private var initialDistance:CGFloat = 0
    private var deltaAngle:CGFloat = 0
    
    lazy var pinchGestureRecognizer: UIPinchGestureRecognizer = {
        let p = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture))
        p.delegate = self
        p.name = "pinch"
        return p
    }()
    
    private lazy var moveGesture: UIPanGestureRecognizer = {
        let move = UIPanGestureRecognizer(target: self, action: #selector(handleMoveGesture(_:)))
        return move
    }()
    
    private lazy var rotateImageView:UIImageView = {
        let rotateImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.defaultInset * 2, height: self.defaultInset * 2))
        rotateImageView.contentMode = UIView.ContentMode.scaleAspectFit
        rotateImageView.backgroundColor = UIColor.clear
        rotateImageView.isUserInteractionEnabled = true
        rotateImageView.addGestureRecognizer(self.rotateGesture)
        
        return rotateImageView
    }()

    
    private lazy var rotateConGes: UIRotationGestureRecognizer = {
        let rotate = UIRotationGestureRecognizer.init(target: self, action: #selector(handleRotate(recognizer:)))
        return rotate
    }()
    
    private lazy var rotateGesture: UIPanGestureRecognizer = {
        let rot = UIPanGestureRecognizer(target: self, action: #selector(handleRotateGesture(_:)))
        return rot
    }()
    
    
    
    private lazy var closeImageView:UIImageView = {
        let closeImageview = UIImageView(frame: CGRect(x: 0, y: 0, width: self.defaultInset * 2, height: self.defaultInset * 2))
        closeImageview.contentMode = UIView.ContentMode.scaleAspectFit
        closeImageview.backgroundColor = UIColor.clear
        closeImageview.isUserInteractionEnabled = true
        closeImageview.addGestureRecognizer(self.closeGesture)
        return closeImageview
    }()
    private lazy var closeGesture = {
        return UITapGestureRecognizer(target: self, action: #selector(handleCloseGesture(_:)))
    }()
    private lazy var flipImageView:UIImageView = {
        let flipImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.defaultInset * 2, height: self.defaultInset * 2))
        flipImageView.contentMode = UIView.ContentMode.scaleAspectFit
        flipImageView.backgroundColor = UIColor.clear
        flipImageView.isUserInteractionEnabled = true
        flipImageView.addGestureRecognizer(self.flipGesture)
        return flipImageView
    }()
    private lazy var flipGesture = {
        return UITapGestureRecognizer(target: self, action: #selector(handleFlipGesture(_:)))
    }()
    private lazy var tapGesture = {
        return UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
    }()
    // MARK: - Gesture Handlers
    @objc
    func handleMoveGesture(_ recognizer: UIPanGestureRecognizer) {
        let touchLocation = recognizer.location(in: self.superview)
        switch recognizer.state {
        case .began:
            self.beginningPoint = touchLocation
            self.beginningCenter = self.center
            if let delegate = self.delegate {
                delegate.stickerViewDidBeginMoving(self)
            }
        case .changed:
            self.center = CGPoint(x: self.beginningCenter.x + (touchLocation.x - self.beginningPoint.x), y: self.beginningCenter.y + (touchLocation.y - self.beginningPoint.y))
            
            if let delegate = self.delegate {
                delegate.stickerViewDidChangeMoving(self)
            }
        case .ended:
            self.center = CGPoint(x: self.beginningCenter.x + (touchLocation.x - self.beginningPoint.x), y: self.beginningCenter.y + (touchLocation.y - self.beginningPoint.y))
            if let delegate = self.delegate {
                delegate.stickerViewDidEndMoving(self)
            }
        default:
            break
        }
    }
    
    @objc
    func handleRotateGesture(_ recognizer: UIPanGestureRecognizer) {
        let touchLocation = recognizer.location(in: self.superview)
        let center = self.center
        
        switch recognizer.state {
        case .began:
            self.deltaAngle = CGFloat(atan2f(Float(touchLocation.y - center.y), Float(touchLocation.x - center.x))) - CGAffineTransformGetAngle(self.transform)
            self.initialBounds = self.bounds
            self.initialDistance = CGPointGetDistance(point1: center, point2: touchLocation)
            if let delegate = self.delegate {
                delegate.stickerViewDidBeginRotating(self)
            }
        case .changed:
            let angle = atan2f(Float(touchLocation.y - center.y), Float(touchLocation.x - center.x))
            let angleDiff = Float(self.deltaAngle) - angle
            self.transform = CGAffineTransform(rotationAngle: CGFloat(-angleDiff))
            
            var scale = CGPointGetDistance(point1: center, point2: touchLocation) / self.initialDistance
            let minimumScale = CGFloat(self.minimumSize) / min(self.initialBounds.size.width, self.initialBounds.size.height)
            scale = max(scale, minimumScale)
            let scaledBounds = CGRectScale(self.initialBounds, wScale: scale, hScale: scale)
            self.bounds = scaledBounds
            self.setNeedsDisplay()
            
            if let delegate = self.delegate {
                delegate.stickerViewDidChangeRotating(self)
            }
        case .ended:
            let angle = atan2f(Float(touchLocation.y - center.y), Float(touchLocation.x - center.x))
            let angleDiff = Float(self.deltaAngle) - angle
            self.transform = CGAffineTransform(rotationAngle: CGFloat(-angleDiff))
            
            var scale = CGPointGetDistance(point1: center, point2: touchLocation) / self.initialDistance
            let minimumScale = CGFloat(self.minimumSize) / min(self.initialBounds.size.width, self.initialBounds.size.height)
            scale = max(scale, minimumScale)
            let scaledBounds = CGRectScale(self.initialBounds, wScale: scale, hScale: scale)
            self.bounds = scaledBounds
            self.setNeedsDisplay()
            if let delegate = self.delegate {
                delegate.stickerViewDidEndRotating(self)
            }
        default:
            break
        }
    }
    
    //MARK: Handle PinchGesture For TextSticker
    @objc func handlePinchGesture(gesture : UIPinchGestureRecognizer) {
        guard gesture.view != nil else { return }
        
        if let view = gesture.view {
            let scale = gesture.scale
                switch gesture.state {
                case .began:
                    self.initCenter = self.center
                    self.initFrame = self.bounds
                case .changed:
                    let newFrame = CGRectScale(self.initFrame, wScale: scale, hScale: scale)
                    self.bounds = newFrame
                    self.center = self.initCenter
                    //gesture.scale = 1
                case .ended:
                    // Nice animation to scale down when releasing the pinch.
                    // OPTIONAL
                    let newFrame = CGRectScale(self.initFrame, wScale: scale, hScale: scale)
                    self.bounds = newFrame
                    self.center = self.initCenter
                   break
                default:
                    return
                }
            }
    }
    
    
    @objc
    func handleRotate(recognizer : UIRotationGestureRecognizer) {
            if let view = recognizer.view {
                view.transform = view.transform.rotated(by: recognizer.rotation)
                recognizer.rotation = 0
            }
        }
    @objc
    func handleCloseGesture(_ recognizer: UITapGestureRecognizer) {
        if let delegate = self.delegate {
            delegate.stickerViewDidClose(self)
        }
        self.removeFromSuperview()
    }
    
    @objc
    func handleFlipGesture(_ recognizer: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            self.contentView.transform = self.contentView.transform.scaledBy(x: -1, y: 1)
        }
    }
    
    @objc
    func handleTapGesture(_ recognizer: UITapGestureRecognizer) {
        if let delegate = self.delegate {
            delegate.stickerViewDidTap(self)
        }
    }
    
    // MARK: - Private Methods
    private func setEnableClose(_ enableClose:Bool) {
        self.closeImageView.isHidden = !enableClose
        self.closeImageView.isUserInteractionEnabled = enableClose
    }
    
    private func setEnableRotate(_ enableRotate:Bool) {
        self.rotateImageView.isHidden = !enableRotate
        self.rotateImageView.isUserInteractionEnabled = enableRotate
    }
    
    private func setEnableFlip(_ enableFlip:Bool) {
        self.flipImageView.isHidden = !enableFlip
        self.flipImageView.isUserInteractionEnabled = enableFlip
    }
}

extension StickerView: UIGestureRecognizerDelegate {
//    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
