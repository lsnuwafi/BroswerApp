//
//  BookMarkViewController.swift
//  MyDemo
//
//  Created by Shinan Liu on 4/11/21.
//

import Foundation
import UIKit


private let reuseIdentifier = "BookMarkCollectionCell"

class BookmarkCollectionViewController: UICollectionViewController, UIGestureRecognizerDelegate {
    
    
    var bookmarks : [Bookmark] = []
    var delegate: ViewController?
    var userDefaults: UserDefaults!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Bookmarks"
        
        self.navigationController?.navigationBar.barTintColor = .white
        userDefaults = UserDefaults.standard
        self.collectionView?.backgroundColor = .white
        self.collectionView?.contentInset = UIEdgeInsets(top: 16, left: 8, bottom: 0, right: 8)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(done))


        // Register cell classes
        self.collectionView!.register(BookmarkCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        var bookArrData = userDefaults.data(forKey: "bookmarks")!
        
        bookmarks = try! NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClass: Bookmark.self, from: bookArrData)!
       // print("boo", bookmarkArr!.count)
        guard let collectionView = self.collectionView else { return }
        setupLongGestureRecognizerOnCollection()
        collectionView.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func done() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookmarks.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BookmarkCollectionViewCell
       // cell.delegate = self
        let bookmark = bookmarks[indexPath.row]
        //print("bookmark", bookmark)
        cell.textLabel?.text = bookmark.name
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        defer {
            self.dismiss(animated: true, completion: nil)
        }
        let bookmark = bookmarks[indexPath.row]
        
        delegate?.didSelectEntry(with: URL(string: bookmark.pageURL))
    }
    
//    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        if let selectedItems = collectionView.indexPathsForSelectedItems, selectedItems.count == 0 {
//            deleteButton.isEnabled = false
//        }
//    }
    
    private func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        collectionView?.addGestureRecognizer(longPressedGesture)
    }

    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) {
            return
        }
        isEditing = true
       
        let p = gestureRecognizer.location(in: collectionView)
          if let indexPath = collectionView?.indexPathForItem(at: p) {
              print("Long press at item: \(indexPath.row)")
                deleteBookmark(indexPath.row)
          }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIControl {
                    return true
                }
                return false
    }
    
    func deleteBookmark(_ index: Int) {
        bookmarks.remove(at: index)
        let encoded: Data = NSKeyedArchiver.archivedData(withRootObject: bookmarks)
        userDefaults.set(encoded, forKey: "bookmarks")
        collectionView.reloadData()
    }


}

