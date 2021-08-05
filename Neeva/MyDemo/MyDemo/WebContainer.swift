//
//  WebContainer.swift
//  MyDemo
//
//  Created by Shinan Liu on 4/7/21.
//

import Foundation
import WebKit

class WebContainer: UIView {
    var webView: WKWebView!
    weak var parentView: UIView?
    weak var tabView: TabView?
    var isObserving = false
    
    deinit {
        if isObserving {
            webView?.removeObserver(self, forKeyPath: "estimatedProgress")
            webView?.removeObserver(self, forKeyPath: "title")
        }
    }
    
    @objc init(parent: UIView) {
        super.init(frame: .zero)
        debugPrint("aaa webcontainer parent", parent)
        self.parentView = parent
        self.translatesAutoresizingMaskIntoConstraints = false
     
        backgroundColor = .white
        
        webView = WKWebView(frame: .zero, configuration: loadConfiguration())
        
        
        webView.allowsLinkPreview = true
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: self.topAnchor),
            webView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension WebContainer: WKNavigationDelegate, WKUIDelegate{
    func finishedLoadUpdates() {
       guard let webView = webView else { return }

       tabView?.tabTitle = webView.title

       if let tabContainer = TabContainer.currentInstance, isObserving {

        tabContainer.addressBar?.setAddressText(webView.url?.absoluteString)
           tabContainer.updateNavButtons()
       }
   }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            
            if webView?.estimatedProgress == 1 {
           //     progressView?.setProgress(0, animated: false)
            }
        } else if keyPath == "title" {
            tabView?.tabTitle = webView?.title
        }
    }
    
    func loadConfiguration() -> WKWebViewConfiguration {
        let config = WKWebViewConfiguration()
        return config
    }
    
    func removeFromView() {
        guard let _ = parentView else { return }
        
        if isObserving {
            webView?.removeObserver(self, forKeyPath: "estimatedProgress")
            webView?.removeObserver(self, forKeyPath: "title")
            isObserving = false

        }
        
        self.removeFromSuperview()
    }
    
    func addToView() {
        guard let _ = parentView else { return }
        
        parentView?.addSubview(self)
        NSLayoutConstraint.activate([
            
            self.topAnchor.constraint(equalTo: parentView!.topAnchor),
            self.widthAnchor.constraint(equalTo: parentView!.widthAnchor),
            self.bottomAnchor.constraint(equalTo: parentView!.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: parentView!.leadingAnchor),
        ])
        
        if !isObserving {
            webView?.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
            webView?.addObserver(self, forKeyPath: "title", options: .new, context: nil)
            isObserving = true
        }
    }


    func loadRequest(string: String) {
        var urlString = string
        if !urlString.isURL() {
            let searchTerms = urlString.replacingOccurrences(of: " ", with: "+")
        //    let searchUrl = UserDefaults.standard.string(forKey: SettingsKeys.searchEngineUrl)!
            let searchUrl = "https://google.com/?q="
            
            urlString = searchUrl + searchTerms
        } else if !urlString.hasPrefix("http://") && !urlString.hasPrefix("https://") {
            urlString = "https://" + urlString
        }
        
        if let url = URL(string: urlString) {
            let _ = webView?.load(URLRequest(url: url))
        }
    }
        
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        if let tabContainer = TabContainer.currentInstance {
            _ = tabContainer.close(tab: tabView!)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        finishedLoadUpdates()
    }

}
