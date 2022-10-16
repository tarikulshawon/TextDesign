//
//  AddTextViewController.swift
//  TextArt
//
//  Created by tarikul shawon on 18/8/22.
//

import UIKit

class AddTextViewController: UIViewController {

    var sticker: TextStickerContainerView?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func addStickers(_ sender: Any) {
        let frame = CGRect(x: 0, y: 0, width: 160, height: 200)
        let sticker = TextStickerContainerView(frame: frame)
        
        self.sticker = sticker
        self.sticker?.delegate = self
        //
        sticker.textStickerView.delegate = self
        self.sticker?.textStickerView.text = "Hello Sadiq vai !!"
        self.sticker?.textStickerView.updateTextFont()
        self.sticker?.initilizeTextStickerData(mainTextView: self.sticker!.textStickerView)
        self.view.addSubview(sticker)
    }
    
    @IBAction func fontChange(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.tag = 1
            let size = self.sticker?.textStickerView.font?.pointSize ?? 20
            
            self.sticker?.textStickerView.font = UIFont.systemFont(ofSize: size)
        }else{
            let size = self.sticker?.textStickerView.font?.pointSize ?? 20
            sender.tag = 0
            self.sticker?.textStickerView.font = UIFont.boldSystemFont(ofSize: size)
        }
    }
    
    @IBAction func colorChange(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.tag = 1
            self.sticker?.textStickerView.textColor = UIColor.green
        }else{
            sender.tag = 0
            self.sticker?.textStickerView.textColor = UIColor.red
        }
       
    }
    
    @IBAction func alignTapped(_ sender: UIButton) {
        
        if sender.tag == 0 {
            sender.tag = 1
            self.sticker?.textStickerView.textAlignment = .left
        }else if sender.tag == 1{
            sender.tag = 2
            self.sticker?.textStickerView.textAlignment = .center
        }else{
            sender.tag = 0
            self.sticker?.textStickerView.textAlignment = .right
        }
        
    }
    
    @IBAction func gradientChange(_ sender: Any) {
        self.sticker?.textStickerView.textColor = UIColor(patternImage: UIImage(named: "g1")!)
        
    }
    
    @IBAction func shadowChange(_ sender: UISlider) {
        
        // set the attributed text on a label
        self.sticker?.textStickerView.layer.shadowColor = UIColor.black.cgColor
        self.sticker?.textStickerView.layer.shadowOffset = .zero
        self.sticker?.textStickerView.layer.shadowRadius = CGFloat(sender.value * 5.0)
        self.sticker?.textStickerView.layer.shadowOpacity = 1

    }
    
    @IBAction func opacityChange(_ sender: UISlider) {
        self.sticker?.textStickerView.alpha = CGFloat(sender.value)
        
    }
    
    @IBAction func texureChanged(_ sender: Any) {
        self.sticker?.textStickerView.textColor = UIColor(patternImage: UIImage(named: "p1")!)
    }
    
    
}

extension AddTextViewController {
    
    //Get all Data
    func getInfo() {
        
        guard let sticker = self.sticker else { return }
        
        //get frame
        let frame = sticker.frame
        
        //get rotation angle
        let radians = atan2(sticker.transform.b, sticker.transform.a)
        let degrees = radians * 180 / .pi
        
        //Get all Text related info from sticker.textStickerView, like as text color, font, alignment etc
        let textView = sticker.textStickerView
        
        
    }
}


extension AddTextViewController: TextStickerContainerViewDelegate {
    func showKeyBoard(text: String) {
        
    }
    
    func showKeyBoard() {
         
    }
    
    func moveViewPosition(textStickerContainerView: TextStickerContainerView) {
        // TODO
    }
    
    
    func setCurrentTextStickerView(textStickerContainerView: TextStickerContainerView) {
        self.sticker = textStickerContainerView
    }
    
    func editTextStickerView(textStickerContainerView: TextStickerContainerView) {
        print("Edit Text")
        sticker?.textStickerView.isUserInteractionEnabled = true
        sticker?.textStickerView.becomeFirstResponder()
    }
    
    func deleteTextStickerView(textStickerContainerView: TextStickerContainerView) {
        self.sticker?.removeFromSuperview()
    }
}

extension AddTextViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textView.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)

        // make sure the result is under 16 characters
        return updatedText.count <= 100
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        print("begin")
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("End edit")
    }
}
