//
//  ContactViewController.swift
//  TabBarApp
//
//  Created by Petr Kozlov on 06.11.2019.
//  Copyright © 2019 Petr Kozlov. All rights reserved.
//

import UIKit
import WebKit

class ContactViewController: UIViewController {
    var currentLinkStr = "https://autospot.ru/contacts/"
    @IBOutlet private weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWebView()
        self.loadUrl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupWebView() {
        self.webView.navigationDelegate = self
    }
    
    private func loadUrl() {
        guard let url = URL( string: self.currentLinkStr) else { return }
        self.webView.load(URLRequest(url: url))
    }
}

extension ContactViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let linkStr = navigationAction.request.url?.absoluteString else { decisionHandler(.cancel); return }
        if linkStr == self.currentLinkStr || linkStr.contains("tel:") || linkStr.contains("mailto:") {
            decisionHandler(.allow); return
        }
        decisionHandler(.cancel)
    }
}
