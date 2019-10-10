//
//  DetailViewController.swift
//  Bookshelf
//
//  Created by Eric Castronovo on 10/9/19.
//  Copyright © 2019 Eric Castronovo. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {
    
    var isbn13: String?
    
    var book: CompleteBookInfo?
    
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var authors: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var publisher: UILabel!
    @IBOutlet weak var pages: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var isbn10: UILabel!
    @IBOutlet weak var bookIsbn13: UILabel!
    @IBOutlet weak var url: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var desc: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBookDetails()
    }
    
    func populateBookInfo() {
        if let book = book {
            bookTitle.text = book.title
            authors.text = "By: \(book.authors)"
            subtitle.text = book.subtitle
            desc.text = "Description: \(book.desc)"
            year.text = "Year: \(book.year)"
            price.text = "Price: \(book.price)"
            rating.text = "Rating: \(book.rating)"
            language.text = "Language: \(book.language)"
            pages.text = "No. Pages: \(book.pages)"
            publisher.text = "Publisher: \(book.publisher)"
            bookIsbn13.text = "ISBN13: \(book.isbn13)"
            isbn10.text = "ISBN10: \(book.isbn10)"
            url.text = "Link: \(book.url)"
            
            do {
                let imageURL = book.image
                let url = URL(string: imageURL)!
                let imageData = try Data(contentsOf: url)
                if let image = UIImage(data: imageData) {
                    self.photo.image = image
                }
            } catch {
                print("Error retrieving image")
            }
        }
    }
    
    func loadBookDetails() {
        let detailsEndpoint = "https://api.itbook.store/1.0/books/\(isbn13!)"
        guard let url = URL(string: detailsEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let config = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            guard error == nil else {
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {
                let decoder = JSONDecoder()
                let info = try decoder.decode(CompleteBookInfo.self, from: responseData)
                self.book = info
                let queue = OperationQueue.main
                queue.addOperation {
                    self.populateBookInfo()
                }
            }
            catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
}
