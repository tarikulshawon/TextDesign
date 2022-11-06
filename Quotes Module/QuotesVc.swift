////
////  QuotesVc.swift
////  TextArt
////
////  Created by Macbook pro 2020 M1 on 15/10/22.
////
//
//import UIKit
//
//protocol quotesDelegate: AnyObject {
//    func sendQuoteText(text: String)
//}
//
//protocol QuotesCardDelegate: AnyObject {
//    func sendTouchSignal(_ section: Int)
//}
//
//class QuotesVc: UIViewController,UITableViewDelegate, UITableViewDataSource {
//    weak var delegateForQuotes: quotesDelegate?
//    var quotesArray: NSArray!
//    var headerName = [String]()
//    var quotesDic = [String: NSArray]()
//    private var searchedKey: String?
//
//    @IBOutlet weak var searchButton: UIImageView!
//    @IBOutlet weak var searchBar: UISearchBar!
//    @IBOutlet weak var searchBarHeight: NSLayoutConstraint!
//
//    private var hiddenSections = Set<Int>()
//
//    @IBOutlet weak var tableView: UITableView!
//
//    var filteredQuotes: [String] = []
//
//    @IBAction func gotoPreviousvIEW(_ sender: Any) {
//        self.dismiss(animated: true)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let path = Bundle.main.path(forResource: "Motivational", ofType: "plist")
//        quotesArray = NSArray(contentsOfFile: path!)
//
//        quotesArray.forEach {
//            if let dictionary = $0 as? Dictionary<String, Any>,
//               let sectionName = dictionary["types"] as? String,
//               let contents = dictionary["items"] as? NSArray
//            {
//                headerName.append(sectionName)
//                quotesDic[sectionName] = contents
//            }
//        }
//
//        tableView.register(UINib(nibName: "QuotesCardCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "QuotesCardCell")
//        //tableView.register(UINib(nibName: "QuotesCardCell", bundle: nil), forCellReuseIdentifier: "QuotesCardCell")
//
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(searchButtonAction))
//        searchButton.addGestureRecognizer(gesture)
//
//        searchBarHeight.constant = 0
//        searchBar.placeholder = "Search Quotes"
//        searchBar.delegate = self
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if isFiltering { return nil }
////        let sectionButton = UIButton()
////        sectionButton.setTitle(headerName[section], for: .normal)
////        sectionButton.setTitleColor(.black, for: .normal)
////        sectionButton.layer.cornerRadius = 10
////
////        sectionButton.backgroundColor = .systemGray5
////        sectionButton.tag = section
////        sectionButton.addTarget(self,
////                                action: #selector(self.hideSection(sender:)),
////                                for: .touchUpInside)
////
////        return sectionButton
//
//        guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "QuotesCardCell") as? QuotesCardCell else {
//            return UITableViewCell()
//        }
//
//        let expand = hiddenSections.contains(section)
//        cell.prepare(
//            title: headerName[section],
//            count: quotesDic[headerName[section]]?.count ?? 0,
//            section: section,
//            isExpand: !expand,
//            delegate: self
//        )
//        return cell
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        isFiltering ? 1 : quotesDic.keys.count
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        isFiltering ? 8 : 64
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if isFiltering { return filteredQuotes.count }
//        if self.hiddenSections.contains(section) { return 0 }
//
//        return quotesDic[headerName[section]]?.count ?? 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuotesCell") as? QuotesCell else {
//            return QuotesCell()
//        }
//
//        if isFiltering {
//            cell.quotesL.setHighlighted(filteredQuotes[indexPath.row], with: searchedKey)
//            //cell.quotesL.text = filteredQuotes[indexPath.row]
//            return cell
//        } else {
//            guard let arr = quotesDic[headerName[indexPath.section]] else { return QuotesCell() }
//            cell.quotesL.text = arr[indexPath.row] as? String
//            return cell
//        }
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 8
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let arr = quotesDic[headerName[indexPath.section]] else { return }
//
//        self.delegateForQuotes?.sendQuoteText(text: arr[indexPath.row] as? String ?? "")
//
//        self.dismiss(animated: true)
//    }
//}
//
//extension QuotesVc {
//    var isSearchBarEmpty: Bool {
//        return searchBar.text?.isEmpty ?? true
//    }
//
//    var isFiltering: Bool {
//        return !isSearchBarEmpty
//    }
//
//    func filterContentForSearchText(_ searchText: String) {
//        filteredQuotes.removeAll()
//        let quotes = quotesDic.map { $0.1 }
//        _ = quotes.map {
//            $0.forEach { quote in
//                if let str = quote as? String {
//                    if str.lowercased().contains(searchText.lowercased()) {
//                        filteredQuotes.append(str)
//                    }
//                }
//            }
//
//        }
//
//        tableView.reloadData()
//    }
//
//}
//
//extension QuotesVc: QuotesCardDelegate {
//    func sendTouchSignal(_ section: Int) {
//        self.hideSection(at: section)
//
//        //tableView.reloadData()
//    }
//}
//
//extension QuotesVc: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        let searchBar = searchController.searchBar
//        filterContentForSearchText(searchBar.text!)
//    }
//}
//
//extension QuotesVc: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        searchedKey = searchText
//
//        guard !searchText.isEmpty else {
//            tableView.reloadData()
//            return
//        }
//
//        filterContentForSearchText(searchText)
//
//        tableView.reloadData()
//    }
//
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        self.searchBar.showsCancelButton = true
//    }
//
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.showsCancelButton = false
//        searchBar.text = ""
//        searchBar.resignFirstResponder()
//        tableView.reloadData()
//    }
//}
//
//extension QuotesVc {
//    @objc
//    private func hideSection(at: Int) {
//        let section = at
//
//        func indexPathsForSection() -> [IndexPath] {
//            var indexPaths = [IndexPath]()
//
//            let dic = quotesArray[section] as! Dictionary<String, Any>
//            let data = dic["items"] as! NSArray
//
//            for row in 0..<data.count {
//                indexPaths.append(IndexPath(row: row, section: section))
//            }
//
//            return indexPaths
//        }
//
//        if self.hiddenSections.contains(section) {
//            self.hiddenSections.remove(section)
//            self.tableView.insertRows(at: indexPathsForSection(),
//                                      with: .fade)
//        } else {
//            self.hiddenSections.insert(section)
//            self.tableView.deleteRows(at: indexPathsForSection(),
//                                      with: .fade)
//        }
//    }
//
//    @objc
//    func searchButtonAction(sender: UIImageView) {
//        searchBarHeight.constant = searchBarHeight.constant.isZero ? 44 : 0
//        searchBarCancelButtonClicked(searchBar)
//    }
//}
