//
//  File.swift
//  DemoTextSticker
//
//  Created by Mehedi on 3/5/22.

import UIKit

protocol TextStickerContainerViewDelegate: NSObject {
    func setCurrentTextStickerView(textStickerContainerView: TextStickerContainerView)
    func editTextStickerView(textStickerContainerView: TextStickerContainerView)
    func deleteTextStickerView(textStickerContainerView: TextStickerContainerView)
    func moveViewPosition(textStickerContainerView: TextStickerContainerView)
}

protocol UpdateTextFontSize: AnyObject {
    func updateFontSize(to: CGFloat)
}

class TextStickerContainerView: UIView {
    var currentFontIndex = -1
    var currentColorSting = ""
    var currentGradientIndex = -1
    var currentTextureIndex = -1
    var opacity = -1
    var shadow = -1
    var align = 1
    var rotate = -1
    var fontSize: CGFloat = 0.0
    
    
    lazy var pinchGestureRecognizer: UIPinchGestureRecognizer = {
        let p = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture))
        p.delegate = self
        p.name = "pinch"
        return p
    }()
    
    
    lazy var moveGesture: UIPanGestureRecognizer = {
        let m = UIPanGestureRecognizer(target: self, action: #selector(handleMoveGesture))
        m.name = "move"
        m.delegate = self
        return m
    }()
    
    lazy var rotationGesture: UIRotationGestureRecognizer = {
        let r = UIRotationGestureRecognizer(target: self, action: #selector(handleRotationGesture))
        r.name = "rotation"
        r.delegate = self
        return r
    }()
    
    lazy var tapGesture: UITapGestureRecognizer = {
        let t = UITapGestureRecognizer(target: self, action: #selector(tappedOnSelectedTextStickerView(_ :)))
        t.name = "tap"
        t.numberOfTapsRequired = 2
        t.delegate = self
        return t
    }()
    
    lazy var SingleTapGesture: UITapGestureRecognizer = {
        let t = UITapGestureRecognizer(target: self, action: #selector(handleActiveLayers))
        t.name = "tap"
        t.numberOfTapsRequired = 1
        t.delegate = self
        return t
    }()
    
    var breakWordController: BreakWordControllerView?
    var textStickerView: TextStickerView!
    weak var delegate: TextStickerContainerViewDelegate?
    let panControllerSize: CGFloat = 25
    var textView: TextStickerView!
    var pathName: String!
    var pathType: String!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tFrame = CGRect(
            x: panControllerSize,
            y: panControllerSize,
            width: frame.width - panControllerSize * 2,
            height: frame.height - panControllerSize * 2
        )
        
        textStickerView = TextStickerView(frame: tFrame, textContainer: nil)
        textStickerView.layer.name = "notHide"
        textStickerView.tag = 1000
        layer.cornerRadius = 10
        backgroundColor = .clear
        clipsToBounds = true
        addSubview(self.textStickerView)
        isUserInteractionEnabled = true
        
        addGesture()
        addStickerViewSubViews()
        
        // MARK: Draw Border
        drawBorder(
            frame: CGRect(
                x: panControllerSize * 0.5,
                y: panControllerSize * 0.5,
                width: bounds.width - 1 * panControllerSize,
                height: bounds.height - 1 * panControllerSize),
            zoomScale: UIScreen.main.scale
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TextStickerContainerView: UpdateTextFontSize {
    func updateFontSize(to: CGFloat) {
        fontSize = to
    }
}

// MARK: Initialize TextSticker Data
extension TextStickerContainerView {

    func addStickerViewSubViews() {
        let scaleController = PanControllerImageView(frame: CGRect(x: self.self.textStickerView.bounds.width +  panControllerSize, y: self.textStickerView.bounds.height + panControllerSize, width: panControllerSize, height: panControllerSize))
        scaleController.layer.name = "hide"
        scaleController.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
        scaleController.addDelegate(delegate: self)
        
        self.breakWordController = BreakWordControllerView(frame: CGRect(x: 0, y: self.bounds.height * 0.5 - self.panControllerSize, width: self.panControllerSize * 3, height: self.panControllerSize * 2))
        self.breakWordController?.layer.name = "hide"
        self.addSubview(breakWordController!)
        
/// NOTE: Red mark on the boundary is removed. Uncomment if you need this is future

//        let BWShowV = UIView(frame: CGRect(x: self.panControllerSize * 0.5 - 4, y: self.panControllerSize * 0.25, width: 4, height: self.panControllerSize * 1.5))
//        BWShowV.backgroundColor = UIColor.red
//        BWShowV.layer.name = "hide"
//        BWShowV.layer.cornerRadius = 2
//        BWShowV.isUserInteractionEnabled = false
//        breakWordController?.addSubview(BWShowV)
//        breakWordController?.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin]
        
        self.addSubview(scaleController)
        
        let deleteController = DeleteImageView(frame: CGRect(x: self.textStickerView.bounds.width +  panControllerSize, y: 0, width: panControllerSize, height: panControllerSize))
        deleteController.layer.name = "hide"
        deleteController.delegateDelete = self
        deleteController.autoresizingMask = [.flexibleBottomMargin, .flexibleLeftMargin]
        self.addSubview(deleteController)
        
    }
    
    func initilizeTextStickerData(mainTextView: TextStickerView){
        let text = prepareText(maintextView: mainTextView)
        
        self.textStickerView.text = text
        self.textStickerView.fontSize = mainTextView.font!.pointSize
        
        self.textStickerView.textColor = mainTextView.textColor
        self.textStickerView.autocorrectionType = .no
        self.textStickerView.backgroundColor = mainTextView.backgroundColor
        self.textStickerView.layer.shadowColor = mainTextView.layer.shadowColor
        self.textStickerView.layer.shadowRadius = mainTextView.layer.shadowRadius
        self.textStickerView.layer.shadowOpacity = mainTextView.layer.shadowOpacity
        self.textStickerView.layer.shadowOffset = mainTextView.layer.shadowOffset
        self.textStickerView.font = mainTextView.font
        self.textStickerView.textAlignment = mainTextView.textAlignment
        self.textStickerView.font = mainTextView.font
        let newSize = self.textStickerView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        self.textStickerView.frame.size = CGSize(width: newSize.width, height: newSize.height)
    }
    
    func UpdateTextStickerData(currentContainerView:  TextStickerContainerView, currentTextView: TextStickerView, mainTextView: TextStickerView){
        currentTextView.text = prepareText(maintextView: mainTextView)
        currentTextView.backgroundColor = mainTextView.backgroundColor
        currentTextView.textAlignment = mainTextView.textAlignment
        currentTextView.textColor = mainTextView.textColor
        currentTextView.layer.shadowOpacity = mainTextView.layer.shadowOpacity
        currentTextView.layer.shadowColor = mainTextView.layer.shadowColor
        currentTextView.layer.shadowRadius = mainTextView.layer.shadowRadius
        currentTextView.layer.shadowOffset = mainTextView.layer.shadowOffset
        currentTextView.font = UIFont(name: mainTextView.font!.fontName, size: currentTextView.font!.pointSize)
        
        let newSize = currentTextView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        // print("updateTextSticker ", newSize)
        currentContainerView.bounds.size = CGSize(width: newSize.width + 2 * self.panControllerSize, height: newSize.height + 2 * self.panControllerSize)
        currentTextView.bounds.size = CGSize(width: newSize.width, height: newSize.height)
        currentTextView.frame.origin = CGPoint(x: currentContainerView.bounds.origin.x + self.panControllerSize, y: currentContainerView.bounds.origin.y + self.panControllerSize)
    }
    
//    //MARK: Copy Text Sticker
//    func copyTextSticker(){
//
//    }
    
    //MARK: Prepare Text For Make Sticker
    func prepareText(maintextView: TextStickerView) -> String {
        
        let text = maintextView.text
        var result = ""
        maintextView.layoutManager.enumerateLineFragments(forGlyphRange: NSRange(location: 0, length: text!.count)) {  (rect, usedRect, textContainer, glyphRange, stop) in
            
            let characterRange = maintextView.layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
            let line = (maintextView.text as NSString).substring(with: characterRange)
            var add = ""
            for t in line {
                if t != "\n"{
                    add += String(t)
                }else{
                    print("oneee")
                }
            }
            if result != ""{
                result += "\n"
            }
            result += add
        }
      //  print("result  ", result)
        return result
        //  print("TFFF  ",result, "  ", self.textView.bounds.width)
        //   self.textView.text = textF
    }
}

extension TextStickerContainerView {
    
    //MARK: Add Gesture
    func addGesture(){
        self.addGestureRecognizer(tapGesture)
        self.addGestureRecognizer(pinchGestureRecognizer)
        self.addGestureRecognizer(moveGesture)
        self.addGestureRecognizer(rotationGesture)
        self.addGestureRecognizer(SingleTapGesture)
    }
    
    //MARK: Active Edit
    func activeEdit(){
        if self.layer.sublayers == nil {
            return
        }
        for layer in self.layer.sublayers! {
            layer.isHidden = false
        }
    }
    
    //MARK: Handle Single Tap Gesture For Active Edite
    @objc func handleActiveLayers(gesture: UITapGestureRecognizer) {
        self.delegate?.setCurrentTextStickerView(textStickerContainerView: self)
        self.activeEdit()
    }
    
    //MARK: Handle PinchGesture For TextSticker
    @objc func handlePinchGesture(recognizer : UIPinchGestureRecognizer) {
        guard recognizer.view != nil else { return }
        
        switch recognizer.state {
        case .began:
            for sub in recognizer.view!.subviews{
                if sub.tag == 1000{
                    self.textView = (sub as? TextStickerView)
                }
            }
            self.delegate?.setCurrentTextStickerView(textStickerContainerView: self)
            self.activeEdit()
        case .changed:
            if let containerView = recognizer.view {
                if textView != nil {
                    let scale = recognizer.scale
                    textView.font = UIFont(name: textView.font!.fontName, size: textView.font!.pointSize * scale)
                    let newSize = textView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
                    textView.bounds.size = CGSize(width: newSize.width, height: newSize.height)
                    containerView.bounds.size = CGSize(width: newSize.width + (panControllerSize * 2), height: newSize.height + (panControllerSize * 2))
                    textView.frame.origin = CGPoint(x: self.panControllerSize, y: self.panControllerSize)
                    recognizer.scale = 1
                    
                    self.drawBorder(frame: CGRect(x: self.panControllerSize * 0.5, y: self.panControllerSize * 0.5, width: recognizer.view!.bounds.width - (1 * self.panControllerSize), height: recognizer.view!.bounds.height - (1 * self.panControllerSize)), zoomScale: UIScreen.main.scale)
                }
            }
        case .ended:
            print("P  End")
        default:
            print("Not Match")
        }
    }
    
    //MARK: Handle MoveGesture For TextStickerView
    @objc func handleMoveGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        //  print("Move")
        guard gestureRecognizer.view != nil else { return }
        self.delegate?.setCurrentTextStickerView(textStickerContainerView: self)
        self.activeEdit()
        if gestureRecognizer.state == UIGestureRecognizer.State.began || gestureRecognizer.state == UIGestureRecognizer.State.changed {
            let translation = gestureRecognizer.translation(in: self.superview)
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.superview)
        }
    }
    
    @objc func handleRotationGesture(_ gestureRecognizer : UIRotationGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }
        self.delegate?.setCurrentTextStickerView(textStickerContainerView: self)
        self.activeEdit()
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            gestureRecognizer.view?.transform = gestureRecognizer.view!.transform.rotated(by: gestureRecognizer.rotation)
            gestureRecognizer.rotation = 0
        }
    }
    
    //MARK: Handle TapGesture On TextSticker
    // @available(iOS 12.0, *)
    @objc func tappedOnSelectedTextStickerView(_ recognizer: UITapGestureRecognizer){
         print("Tapped")
        // MARK: Add Edit And Delete Menu Bar
                if let view = recognizer.view as? TextStickerContainerView {
                    let editeItem = UIMenuItem(title: "Edit Text", action: #selector(editTextView))
                    let deleteItem = UIMenuItem(title: "Delete", action: #selector(deleteTextView))
                    // MARK: View Hierarchy
                    let bringToFront = UIMenuItem(title: "Bring Front", action: #selector(moveViewPosition))
                    
                    let menu = UIMenuController.shared
                    menu.menuItems = [editeItem, deleteItem, bringToFront]
                    if #available(iOS 12.0, *) {
                        //menu.showMenu(from: view, rect: view.frame)
                        menu.setTargetRect(view.subviews[0].frame, in: view.subviews[0])
                        menu.setMenuVisible(true, animated: true)
                    } else {
                        // Fallback on earlier versions
                    }
                    view.subviews[0].becomeFirstResponder()
                }
        
        self.delegate?.setCurrentTextStickerView(textStickerContainerView: self)
        self.delegate?.editTextStickerView(textStickerContainerView: self)
    }
    
    //MARK: Edit TextView
    @objc func editTextView(){
        self.delegate?.editTextStickerView(textStickerContainerView: self)
    }
    
    //MARK: Delete TextView
    @objc func deleteTextView(){
        self.delegate?.deleteTextStickerView(textStickerContainerView: self)
    }
    
    // MARK: View Hierarchy
    @objc func moveViewPosition() {
        delegate?.moveViewPosition(textStickerContainerView: self)
    }
    
}

//MARK:  DeleteImageViewDeleagte
extension TextStickerContainerView: DeleteImageViewDeleagte {
    func delete() {
        self.delegate?.deleteTextStickerView(textStickerContainerView: self)
    }
}

//MARK: Gesture Recognizer Delegate
extension TextStickerContainerView: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // print("Se ", gestureRecognizer.name)
        return true
    }
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let pos = gestureRecognizer.location(in: self)
        //  print("P  ", pos.x,"  ", self.bounds.width - 44)
        if (pos.x > self.bounds.width - self.panControllerSize) || (pos.x < self.panControllerSize) || (pos.y > self.bounds.height - self.panControllerSize) || (pos.y < self.panControllerSize)  {
            //    print("P1  ", pos.x,"  ", self.bounds.width - 44)
            return false
        }
        return true
    }
}


