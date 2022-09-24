//
//  TextEditViewController.swift
//  TextArt
//
//  Created by Macbook pro 2020 M1 on 24/9/22.
//

import UIKit


public protocol sendTextValue {
    func sendText(text: String,font:UIFont,textContaier:CGSize)
}


class TextEditViewController: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var bottomSpaceText: NSLayoutConstraint!
    
    @IBOutlet weak var textStickerTextView: UITextView!
    public var delegate: sendTextValue!
    var textContainerSize:CGSize!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            bottomSpaceText.constant = keyboardHeight
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textStickerTextView.delegate = self
        textStickerTextView.becomeFirstResponder()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate.sendText(text: textStickerTextView.text, font: UIFont.systemFont(ofSize: 20.0), textContaier: textContainerSize)
        super.viewDidDisappear(animated)
        textStickerTextView.resignFirstResponder()
    }
    
    
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        textContainerSize = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)

        textContainerSize = newSize
        print(textContainerSize.width)
        print(textContainerSize.height)
 
        
    }
    
    
    @IBAction func gotoMainView(_ sender: Any) {
        shouldRemove = true
        self.dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
