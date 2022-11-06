//
//  QuotesViewModel.swift
//  Quotes
//
//  Created by tarikul shawon on 31/10/22.
//

import Foundation

final class QuotesViewModel {
    var tags: [Tag] = []
    var quotes: [Quote] = []
    var authors: [Author] = []
    
    init() {
        fetchJSONData()
    }
}

extension QuotesViewModel {
//    func quoteData(at row: Int) -> Quote {
//
//    }
    
    func searchQuotes(by key: String) -> [Quote] {
        quotes.filter { $0.tags.contains(key) }
    }
    
    func famousQuotes() -> [Quote] {
        return quotes.filter { $0.tags.contains("famous-quotes") }
    }
}

private extension QuotesViewModel {
    func fetchJSONData() {
        do {
            if let bundlePath = Bundle.main.path(forResource: "authors",
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                
                let data = try JSONDecoder().decode([Author].self, from: jsonData)
                authors = data
            }
        } catch {
            print(error)
        }
        
        do {
            if let bundlePath = Bundle.main.path(forResource: "quotes",
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                
                let data = try JSONDecoder().decode([Quote].self, from: jsonData)
                quotes = data
            }
        } catch {
            print(error)
        }
        
        do {
            if let bundlePath = Bundle.main.path(forResource: "tags",
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                
                let data = try JSONDecoder().decode([Tag].self, from: jsonData)
                tags = data
            }
        } catch {
            print(error)
        }
    }
}
