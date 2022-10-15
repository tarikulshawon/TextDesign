//
//  QuotesVc.swift
//  TextArt
//
//  Created by Macbook pro 2020 M1 on 15/10/22.
//

import UIKit

protocol quotesDelegate: AnyObject {
    func sendText1(text: String)
}

class QuotesVc: UIViewController,UITableViewDelegate, UITableViewDataSource {
    weak var delegateForQuotes: quotesDelegate?
    var quotesArray: NSArray!
    var headerName = [String]()
    var quotesDic = [String: NSArray]()
    
    private var hiddenSections = Set<Int>()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func gotoPreviousvIEW(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = Bundle.main.path(forResource: "Motivational", ofType: "plist")
        quotesArray = NSArray(contentsOfFile: path!)
        
        quotesArray.forEach {
            if let dictionary = $0 as? Dictionary<String, Any>,
               let sectionName = dictionary["types"] as? String,
               let contents = dictionary["items"] as? NSArray
            {
                headerName.append(sectionName)
                quotesDic[sectionName] = contents
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionButton = UIButton()
        sectionButton.setTitle(headerName[section], for: .normal)
        sectionButton.setTitleColor(.black, for: .normal)
        sectionButton.layer.cornerRadius = 10
        
        sectionButton.backgroundColor = .systemGray5
        sectionButton.tag = section
        sectionButton.addTarget(self,
                                action: #selector(self.hideSection(sender:)),
                                for: .touchUpInside)
        
        return sectionButton
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { quotesDic.keys.count }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 40 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.hiddenSections.contains(section) { return 0 }
        
        return quotesDic[headerName[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuotesCell") as? QuotesCell else {
            return QuotesCell()
        }

        guard let arr = quotesDic[headerName[indexPath.section]] else { return QuotesCell() }
        
        cell.quotesL.text = arr[indexPath.row] as? String
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let arr = quotesDic[headerName[indexPath.section]] else { return }
        
        self.delegateForQuotes?.sendText1(text: arr[indexPath.row] as? String ?? "")
        
        self.dismiss(animated: true)
    }
}

extension QuotesVc {
    @objc
    private func hideSection(sender: UIButton) {
        let section = sender.tag
        
        func indexPathsForSection() -> [IndexPath] {
            var indexPaths = [IndexPath]()
            
            let dic = quotesArray[section] as! Dictionary<String, Any>
            let data = dic["items"] as! NSArray
            
            for row in 0..<data.count {
                indexPaths.append(IndexPath(row: row, section: section))
            }
            
            return indexPaths
        }
        
        if self.hiddenSections.contains(section) {
            self.hiddenSections.remove(section)
            self.tableView.insertRows(at: indexPathsForSection(),
                                      with: .fade)
        } else {
            self.hiddenSections.insert(section)
            self.tableView.deleteRows(at: indexPathsForSection(),
                                      with: .fade)
        }
    }
}
