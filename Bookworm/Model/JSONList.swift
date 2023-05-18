//
//  JSONBook.swift
//  Bookworm
//
//  Created by Vladimir Kratinov on 2023-05-18.
//

import Foundation

struct JSONBook: Codable {
    let title: String
    let author: String
    let rating: Int16
    let genre: String
    let review: String
}

struct JSONList: Codable {
    let data: [JSONBook]
}
