//
//  CompleteBookInfo.swift
//  Bookshelf
//
//  Created by Eric Castronovo on 10/9/19.
//  Copyright © 2019 Eric Castronovo. All rights reserved.
//

import Foundation

struct CompleteBookInfo: Codable {
    var error: String
    var title: String
    var subtitle: String
    var authors: String
    var publisher: String
    var language: String
    var isbn10: String
    var isbn13: String
    var pages: String
    var year: String
    var rating: String
    var desc: String
    var price: String
    var image: String
    var url: String
}
