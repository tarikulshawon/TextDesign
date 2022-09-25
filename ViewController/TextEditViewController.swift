//
//  TextEditViewController.swift
//  TextArt
//
//  Created by Macbook pro 2020 M1 on 24/9/22.
//

import UIKit


public protocol sendTextValue {
    func sendText(text: String)
}


class TextEditViewController: UIViewController {

    @IBOutlet weak var textStickerTextView: UITextView!
    public var delegate: sendTextValue!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textStickerTextView.textAlignment = .center
        textStickerTextView.becomeFirstResponder()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate.sendText(text: textStickerTextView.text)
        super.viewDidDisappear(animated)
        textStickerTextView.resignFirstResponder()
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
