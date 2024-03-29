//
//  BlogViewController.swift
//  TabBarApp
//
//  Created by Petr Kozlov on 06.11.2019.
//  Copyright © 2019 Petr Kozlov. All rights reserved.
//

import UIKit
import WebKit

class BlogViewController: UIViewController {
    var currentLinkStr = "https://blog.autospot.ru/"

    private var webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWebView()
        self.setupNavigationBar()
        self.loadUrl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupWebView() {
        let frame = self.view.bounds
        self.webView.frame = frame
        self.webView.navigationDelegate = self
        self.view.addSubview(self.webView)
    }
    
    private func setupNavigationBar() {
        guard let navigationCtrl = self.navigationController else { return }
        navigationCtrl.navigationItem.backBarButtonItem?.tintColor = #colorLiteral(red: 0.2033973932, green: 0.7708666921, blue: 0.6697602868, alpha: 1)
    }
    
    private func loadUrl() {
        guard let url = URL( string: self.currentLinkStr) else { return }
        self.webView.load(URLRequest(url: url))
    }
}

extension BlogViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let linkStr = navigationAction.request.url?.absoluteString else { decisionHandler(.cancel); return }
        if linkStr == self.currentLinkStr {
            decisionHandler(.allow); return
        } else if linkStr.contains("blog.autospot.ru"){
            decisionHandler(.cancel)
            let ctrl = BlogViewController.init()
            ctrl.currentLinkStr = linkStr
            guard let navCntr = self.navigationController else { return }
            navCntr.pushViewController(ctrl, animated: true)
            return
        } else if linkStr.contains("tel:") {
            decisionHandler(.allow); return
        }
        decisionHandler(.cancel)
    }
}
