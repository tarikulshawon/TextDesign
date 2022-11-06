//
//  ViewController.swift
//  Quotes
//
//  Created by tarikul shawon on 31/10/22.
//

import UIKit

protocol quotesDelegate: AnyObject {
    func sendQuoteText(text: String)
}

protocol QuotesCardDelegate: AnyObject {
    func sendTouchSignal(_ section: Int)
}

class QuotesViewController: UIViewController {
    @IBOutlet private weak var tagCollectionView: UICollectionView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewHeader: UILabel!
    
    weak var delegateForQuotes: quotesDelegate?
    private var selectedIndex: Int?
    private var viewModel: QuotesViewModel!
    private var famousQuotesData: [Quote] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewModel = QuotesViewModel()
        
        prepareViews()
    }
}

extension QuotesViewController {
    func prepareViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UINib(nibName: "QuotableCell", bundle: nil),
            forCellReuseIdentifier: "QuotableCell"
        )
        
        tagCollectionView.register(
            UINib(nibName: "TagableCell", bundle: nil),
            forCellWithReuseIdentifier: "TagableCell"
        )
        tagCollectionView.collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
        
        famousQuotesData = viewModel.famousQuotes()
        tableViewHeader.text = "famous-quotes".uppercased()
    }
}

// MARK: TableView
extension QuotesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let selectedIndex else {
            return 50
        }
        
        let selectedTag = viewModel.tags[selectedIndex]
        return viewModel.searchQuotes(by: selectedTag.name).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuotableCell") as! QuotableCell
        
        guard let selectedIndex else {
            let data = famousQuotesData[indexPath.row]
            cell.prepare(data)
            return cell
        }
        
        let selectedTag = viewModel.tags[selectedIndex]
        let data = viewModel.searchQuotes(by: selectedTag.name)[indexPath.row]
        cell.prepare(data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedIndex else {
            let data = famousQuotesData[indexPath.row]
            self.delegateForQuotes?.sendQuoteText(text: data.content)
            self.dismiss(animated: true)
            return
        }
        
        let selectedTag = viewModel.tags[selectedIndex]
        let data = viewModel.searchQuotes(by: selectedTag.name)[indexPath.row]
        self.delegateForQuotes?.sendQuoteText(text: data.content)
        
        self.dismiss(animated: true)
    }
}

// MARK: CollectionView
extension QuotesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagableCell", for: indexPath) as! TagableCell
        
        
        cell.prepare(viewModel.tags[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableViewHeader.text = viewModel.tags[selectedIndex ?? 0].name.uppercased()
        tableView.reloadData()
    }
}

extension QuotesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let font = UIFont.systemFont(ofSize: 15)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let text = viewModel.tags[indexPath.row].name
        let size = (text as NSString).size(withAttributes: fontAttributes)
        
        return CGSize(width: size.width + 12 * 2, height: size.height + 6 * 2)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        .init(top: 0, left: 16, bottom: 0, right: 16)
//    }
}

extension QuotesViewController: QuotesCardDelegate {
    func sendTouchSignal(_ section: Int) {
        //self.hideSection(at: section)
        
        //tableView.reloadData()
    }
}

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    required override init() {super.init(); common()}
    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder); common()}
    
    private func common() {
        //estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        minimumLineSpacing = 10
        minimumInteritemSpacing = 10
    }
    
    override func layoutAttributesForElements(
                    in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        guard let att = super.layoutAttributesForElements(in:rect) else {return []}
        var x: CGFloat = sectionInset.left
        var y: CGFloat = -1.0
        
        for a in att {
            if a.representedElementCategory != .cell { continue }
            
            if a.frame.origin.y >= y { x = sectionInset.left }
            a.frame.origin.x = x
            x += a.frame.width + minimumInteritemSpacing
            y = a.frame.maxY
        }
        return att
    }
}
