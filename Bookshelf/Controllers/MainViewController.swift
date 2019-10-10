//
//  ViewController.swift
//  Bookshelf
//
//  Created by Eric Castronovo on 10/3/19.
//  Copyright © 2019 Eric Castronovo. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var Books: [BookInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        loadNewBookInformation()
    }
    
    func loadNewBookInformation() {
        let newBooksEndpoint: String = "https://api.itbook.store/1.0/new"
        guard let url = URL(string: newBooksEndpoint) else {
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
                let bookInfo = try decoder.decode(NewBooksResponse.self, from: responseData)
                
                for item in bookInfo.books {
                    let imageURL = item.image
                    let url = URL(string: imageURL)!
                    let imageData = try Data(contentsOf: url)
                    if let image = UIImage(data: imageData) {
                        let newBookInfo = BookInfo(title: item.title, subtitle: item.subtitle, isbn13: item.isbn13, price: item.price, image: item.image, url: item.url, photo: image)
                        self.Books.append(newBookInfo)
                    }
                }
                let queue = OperationQueue.main
                queue.addOperation {
                    self.tableView.reloadData()
                }
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell") as! TableViewCell
        cell.title.text = Books[indexPath.row].title
        cell.subtitle.text = Books[indexPath.row].subtitle
        cell.price.text = Books[indexPath.row].price
        cell.isbn13.text = Books[indexPath.row].isbn13
        cell.photo.image = Books[indexPath.row].photo
        cell.url.text = Books[indexPath.row].url
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDetailFromNew" {
            if let detailViewController = segue.destination as? BookDetailViewController {
                let indexPath = tableView.indexPathForSelectedRow!
                detailViewController.isbn13 = Books[indexPath.row].isbn13
            }
        }
    }
    
    func setDelegates() {
        tableView.dataSource = self
        tableView.delegate = self
    }
}
