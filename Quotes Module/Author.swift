//
//  Author.swift
//  Quotes
//
//  Created by tarikul shawon on 31/10/22.
//

/// Example
///
//"_id": "7E6EppQX9_ha",
//"name": "Alice Walker",
//"link": "https://en.wikipedia.org/wiki/Alice_Walker",
//"bio": "Alice Walker (born February 9, 1944) is an American novelist, short story writer, poet, and social activist. In 1982, she wrote the novel The Color Purple, for which she won the National Book Award for hardcover fiction, and the Pulitzer Prize for Fiction.",
//"description": "American author and activist"
///
///

import Foundation

struct Author: Codable {
    let _id: String
    let name: String
    let link: String
    let bio: String
    let description: String
}
