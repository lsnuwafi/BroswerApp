//
//  AddBookmarkViewController.swift
//  MyDemo
//
//  Created by Shinan Liu on 4/11/21.
//

import Foundation
import UIKit


fileprivate let reuseidentifier = "bookmarkCell"

class AddBookmarkTableViewController: UITableViewController {
    
    @objc var pageIconURL: String?
    @objc var pageTitle: String?
    @objc var pageURL: String?
    
    @objc var titleTextField: UITextField?
    @objc var urlTextField: UITextField?
    var userDefaults: UserDefaults!
    override var preferredContentSize: CGSize {
        get {
            return CGSize(width: 414, height: 200)
        }
        set { super.preferredContentSize = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Bookmark"
        userDefaults = UserDefaults.standard
        self.navigationController?.navigationBar.barTintColor = .gray
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(done))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))

        tableView.register(BookmarkTableViewCell.self, forCellReuseIdentifier: reuseidentifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func displayValidationError(for field: String) {
        let av = UIAlertController(title: "Error", message: "Please enter a \(field) for your bookmark.", preferredStyle: .alert)
        av.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(av, animated: true, completion: nil)
    }
    
    @objc func done() {
        guard let title = titleTextField?.text, title != "" else {
            displayValidationError(for: "title")
            return
        }
        guard let url = urlTextField?.text, url != "" else {
            displayValidationError(for: "URL")
            return
        }
        
   //     let bookmark = Bookmark(value: ["id": UUID().uuidString, "name": title,
 //                                       "pageURL": url, "iconURL": pageIconURL ?? ""])
        let bookmark = Bookmark(title, url)
        var decoded = userDefaults.data(forKey: "bookmarks")
        if decoded == nil {
            let bookmarkArr = [Bookmark]()
            let encoded: Data = NSKeyedArchiver.archivedData(withRootObject: bookmarkArr)
            userDefaults.set(encoded, forKey: "bookmarks")
            decoded = userDefaults.data(forKey: "bookmarks")
        }
        
        var bookmarkArr = try! NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClass: Bookmark.self, from: decoded!)
        
        bookmarkArr!.append(bookmark)
        let encoded: Data = NSKeyedArchiver.archivedData(withRootObject: bookmarkArr)
        userDefaults.set(encoded, forKey: "bookmarks")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseidentifier, for: indexPath) as? BookmarkTableViewCell

        if let pageIconURL = pageIconURL, let imgURL = URL(string: pageIconURL) {
  //          cell?.imageView?.sd_setImage(with: imgURL, placeholderImage: UIImage(named: "globe"))
        } else {
            cell?.imageView?.image = UIImage(named: "globe")
        }
        
        titleTextField = cell?.titleTextField
        urlTextField = cell?.urlTextField
        
        cell?.titleTextField?.text = pageTitle
        cell?.urlTextField?.text = pageURL

        return cell!
    }

}
