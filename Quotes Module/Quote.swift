//
//  Quote.swift
//  Quotes
//
//  Created by tarikul shawon on 31/10/22.
//

///Example
///
//"_id": "Tm5YUGQYMtDk",
//"content": "To follow, without halt, one aim: There is the secret of success.",
//"author": "Anna Pavlova",
//"tags": ["success"]
///
///

import Foundation

struct Quote: Codable {
    let _id: String
    let content: String
    let author: String
    let tags: [String]
}
