//
//  ViewController.swift
//  MyDemo
//
//  Created by Shinan Liu on 3/22/21.
//

import UIKit
import WebKit
class ViewController: UIViewController{

    var webView: WKWebView!
    var addressView: AddressView!
    var tabContainer: TabContainer!
    var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressView = AddressView()
        addressView?.translatesAutoresizingMaskIntoConstraints = false
    
        tabContainer = TabContainer(frame: .zero)
        tabContainer.translatesAutoresizingMaskIntoConstraints = false
        container = UIView()
        container.backgroundColor = .red
        container.translatesAutoresizingMaskIntoConstraints = false
       
        addressView.tabContainer = tabContainer
        addressView.setupNaviagtionActions(forTabConatiner: self.tabContainer)
        view.addSubview(addressView!)
        view.addSubview(tabContainer!)
        view.addSubview(container)
        
        NSLayoutConstraint.activate([
            addressView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addressView!.topAnchor.constraint(equalTo: tabContainer.bottomAnchor),
            addressView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addressView!.heightAnchor.constraint(equalToConstant: 40),
            
            tabContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tabContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabContainer.widthAnchor.constraint(equalTo: view.widthAnchor),
            tabContainer.heightAnchor.constraint(equalToConstant: TabContainer.standardHeight),
            
            container.topAnchor.constraint(equalTo: addressView.bottomAnchor),
            container.widthAnchor.constraint(equalTo: view.widthAnchor),
            container.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
        tabContainer.containerView = container
        tabContainer.addressBar = addressView
        tabContainer.addTabButton?.addTarget(self, action: #selector(addTab), for: .touchUpInside)
        addressView.menuButton.addTarget(self, action: #selector(showMenu(sender:)), for: .touchUpInside)
        tabContainer.loadBrowsingSession()
        
        addressView.urlTextField.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        tabContainer?.setUpTabConstraints()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        tabContainer?.setUpTabConstraints()
    }
    
    @objc func addTab() {
        let _ = tabContainer?.addNewTab(container: container!)
    }
    
    @objc func showBookmark(sender: UIButton) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 80, height: 97.5)
        let vc = BookmarkCollectionViewController(collectionViewLayout: flowLayout)
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.barTintColor = .gray
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func showMenu(sender: UIButton) {
        let convertedPoint = sender.convert(sender.center, to: self.view)
        
        let addBookmarkAction = MenuItem.item(named: "Add Bookmark", action: { [unowned self] in
            self.addBookmark(btn: sender)
        })
        let bookmarkAction = MenuItem.item(named: "Bookmarks", action: { [unowned self] in
            self.showBookmark(sender: sender)
        })
        
        let menu = SharedDropdownMenu(menuItems: [addBookmarkAction, bookmarkAction])
        menu.show(in: self.view, from: convertedPoint)
    }
    
    @objc func addBookmark(btn: UIView) {
        let vc = AddBookmarkTableViewController(style: .grouped)
       // vc.pageIconURL = tabContainer?.currentTab?.webContainer?.favicon?.getPreferredURL()
        vc.pageTitle = tabContainer?.currentTab?.webContainer?.webView?.title
        vc.pageURL = tabContainer?.currentTab?.webContainer?.webView?.url?.absoluteString
        let nav = UINavigationController(rootViewController: vc)
        
        
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func didSelectEntry(with url: URL?) {
        guard let url = url else { return }
        tabContainer?.loadRequest(string: url.absoluteString)
    }

}

