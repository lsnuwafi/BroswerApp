//
//  TabContainerView.swift
//  MyDemo
//
//  Created by Shinan Liu on 4/7/21.
//

import Foundation
import UIKit
import Darwin
class TabContainer: UIView {
    
    
    @objc static let standardHeight: CGFloat = 35
    @objc static let defaultTabWidth: CGFloat = 150
    static let defaultTabHeight: CGFloat = TabContainer.standardHeight - 2
    static var currentInstance: TabContainer?
    var tabScrollView: UIScrollView!
    var addTabButton: UIButton!
    var tabList: [TabView] = []
    weak var containerView: UIView?
    weak var addressBar: AddressView?
    var currentTab: TabView? {
        guard tabList.count > 0 else { return nil}
        return tabList[selectedIndex]
    }
    var selectedIndex = 0 {
        didSet {
            setTab()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .gray
        
        addTabButton = UIButton()
        addTabButton!.setImage(UIImage(systemName: "plus"), for: .normal)
        addTabButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(addTabButton!)

        tabScrollView = UIScrollView()
        tabScrollView.isScrollEnabled = true
        tabScrollView.showsVerticalScrollIndicator = false
        tabScrollView.showsHorizontalScrollIndicator = false
        tabScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tabScrollView)
        NSLayoutConstraint.activate([
            addTabButton.heightAnchor.constraint(equalToConstant: TabContainer.standardHeight - 5),
            addTabButton.widthAnchor.constraint(equalToConstant: TabContainer.standardHeight - 5),
            addTabButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            addTabButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            
            tabScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tabScrollView.heightAnchor.constraint(equalToConstant: 33),
            tabScrollView.trailingAnchor.constraint(equalTo: addTabButton.leadingAnchor, constant: 5),
            tabScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])

        TabContainer.currentInstance = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func goBack(sender: UIButton) {
        let tab = tabList[selectedIndex]
        let _ = tab.webContainer?.webView?.goBack()
        tab.webContainer?.finishedLoadUpdates()
    }
    
    @objc func goForward(sender: UIButton) {
        let tab = tabList[selectedIndex]
        let _ = tab.webContainer?.webView?.goForward()
        tab.webContainer?.finishedLoadUpdates()
    }
    
    @objc func refresh(sender: UIButton) {
        let tab = tabList[selectedIndex]
        let _ = tab.webContainer?.webView?.reload()
    }
    
    func switchVisibleWebView(prevTab: TabView?, newTab: TabView) {
        prevTab?.webContainer?.removeFromView()
        newTab.webContainer?.addToView()
       // debugPrint("aaa webis aa", newTab.webContainer)
        let url = newTab.webContainer?.webView.url
        if url?.absoluteString != "" {
            addressBar?.setAddressText(url?.absoluteString)
        }
        
    }
    
    func scroll(toTab tab: TabView, addingTab: Bool = false) {
        guard tabScrollView.contentSize.width > tabScrollView.frame.width else { return }
        
        let maxOffset = tabScrollView.contentSize.width - tabScrollView.frame.width + ((addingTab) ? TabContainer.defaultTabWidth : 0)
        tabScrollView.setContentOffset(CGPoint(x: min(maxOffset, tab.frame.origin.x), y: 0), animated: true)
    }
    
    func loadBrowsingSession() {
        let url = URL(string: "https://www.google.com")!
        let request = URLRequest(url: url)
        let _ = addNewTab(withRequest: request)
        didTap(tab: tabList[selectedIndex])
        return
    }
    
    func setUpTabConstraints() {
        let tabWidth = TabContainer.defaultTabWidth
        
        for (i, tab) in tabList.enumerated() {
            tab.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                tab.topAnchor.constraint(equalTo: self.tabScrollView.topAnchor),
                tab.bottomAnchor.constraint(equalTo: self.tabScrollView.bottomAnchor),
                tab.heightAnchor.constraint(equalTo: self.tabScrollView.heightAnchor),
                tab.widthAnchor.constraint(equalToConstant: tabWidth),
            ])
            if i > 0 {
                let lastTab = self.tabList[i - 1]
                NSLayoutConstraint.activate([
                    tab.leadingAnchor.constraint(equalTo: lastTab.trailingAnchor, constant: -6),
                ])
            }  else {
                NSLayoutConstraint.activate([
                    tab.leadingAnchor.constraint(equalTo: self.tabScrollView.leadingAnchor),
                ])
            }
            
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
        }) { _ in
            self.tabScrollView.contentSize = CGSize(width: TabContainer.defaultTabWidth * CGFloat(self.tabList.count) -
                                               CGFloat((self.tabList.count - 1) * 6),
                                               height: TabContainer.defaultTabHeight)
        }
    }
    
    func loadRequest(string: String?) {
        guard let string = string else { return }
        
        if addressBar?.urlTextField.text != string {
            //addressBar?.setAddressText(string)
            
        }
        
        let tab = tabList[selectedIndex]
        tab.webContainer?.loadRequest(string: string)
    }
    
    @objc func addNewTab(container: UIView, focusAddressBar: Bool = true) -> TabView {
        let newTab = TabView(parentView: container)
        newTab.delegate = self
        self.tabScrollView.addSubview(newTab)
        self.tabScrollView.sendSubviewToBack(newTab)
        
        tabList.append(newTab)
        
        setUpTabConstraints()
        didTap(tab: newTab)
        if focusAddressBar && tabList.count > 1 {
           addressBar?.urlTextField.becomeFirstResponder()
        }
        
        scroll(toTab: newTab, addingTab: true)
        
        return newTab
    }
    
    @objc func addNewTab(withRequest request: URLRequest) {
        guard let container = self.containerView else { return }
        
        let newTab = addNewTab(container: container, focusAddressBar: false)
        let _ = newTab.webContainer?.webView!.load(request)
    }
    
    func updateNavButtons() {
        let tab = tabList[selectedIndex]
        
        addressBar?.backButton.isEnabled = tab.webContainer?.webView?.canGoBack ?? false
        addressBar?.backButton.tintColor = (tab.webContainer?.webView?.canGoBack ?? false) ? .black : .lightGray
        addressBar?.forwardButton.isEnabled = tab.webContainer?.webView?.canGoForward ?? false
        addressBar?.forwardButton.tintColor = (tab.webContainer?.webView?.canGoForward ?? false) ? .black : .lightGray
    }
    
    @objc func setTab() {
        for (i, tab) in tabList.enumerated() {
            tab.backgroundColor = (i == selectedIndex) ? .white : .gray
        }
    }
    
}

extension TabContainer: TabViewDelegate {
    func didTap(tab: TabView) {
        let preIndex = selectedIndex
        if let index = tabList.firstIndex(of: tab) {
            selectedIndex = index
            
            var prevTab: TabView?
            if tabList.count > 1 {
                prevTab = tabList[preIndex]
            }
            
            switchVisibleWebView(prevTab: prevTab, newTab: tab)
            
            scroll(toTab: tab)
        }
    }
    
    func close(tab: TabView) -> Bool {
        guard tabList.count > 1 else {
            exit(0)
        }
        guard let indexToRemove = tabList.firstIndex(of: tab) else { return false }
        
        tabList.remove(at: indexToRemove)
        tab.removeFromSuperview()
        if selectedIndex >= indexToRemove {
            selectedIndex = max(0, selectedIndex - 1)
            switchVisibleWebView(prevTab: tab, newTab: tabList[selectedIndex])
        }
        
        setUpTabConstraints()
        return true
    }
}
