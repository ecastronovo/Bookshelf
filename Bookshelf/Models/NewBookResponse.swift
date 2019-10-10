//
//  NewBookResponse.swift
//  Bookshelf
//
//  Created by Eric Castronovo on 10/9/19.
//  Copyright © 2019 Eric Castronovo. All rights reserved.
//

import Foundation

struct NewBooksResponse: Codable {
    struct Book: Codable {
        let title: String
        let subtitle: String
        let isbn13: String
        let price: String
        let image: String
        let url: String
    }
    let books: [Book]
}
