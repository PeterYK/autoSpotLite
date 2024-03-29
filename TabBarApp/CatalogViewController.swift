//
//  ViewController.swift
//  TabBarApp
//
//  Created by Petr Kozlov on 06.11.2019.
//  Copyright © 2019 Petr Kozlov. All rights reserved.
//

import UIKit
import WebKit

class CatalogViewController: UIViewController {
    var currentLinkStr = ""
    var loadLinkStr = "https://autospot.ru/brands/"
    let rootLinkStr = "https://autospot.ru/brands/"
    private var webView = WKWebView()
    var isOffer = false
    
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
    
    private func loadUrl() {
        guard let url = URL( string: self.loadLinkStr) else { return }
        self.webView.load(URLRequest(url: url))
    }
    
    private func setupNavigationBar() {
        if self.isOffer {
            let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveOffer))
            self.navigationItem.setRightBarButtonItems([saveButton], animated: true)
        }
    }
    
   @objc func saveOffer() {
        print(self.currentLinkStr)
    }
}

extension CatalogViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let linkStr = navigationAction.request.url?.absoluteString else { decisionHandler(.cancel); return }
        if linkStr.contains("#") {
            decisionHandler(.cancel)
            return
        } else if linkStr == self.rootLinkStr && linkStr != self.currentLinkStr {
            self.currentLinkStr = linkStr
            decisionHandler(.allow)
            return
        } else if linkStr.contains("autospot.ru/brands/") && linkStr != self.currentLinkStr {
            decisionHandler(.cancel)
            let ctrl = CatalogViewController.init()
            ctrl.currentLinkStr = linkStr
            ctrl.loadLinkStr = linkStr
            ctrl.isOffer = linkStr.contains("/offer/")
            guard let navCntr = self.navigationController else { return }
            navCntr.pushViewController(ctrl, animated: true)
            return
        } else if linkStr.contains("autospot.ru/brands/") && linkStr == self.currentLinkStr {
            decisionHandler(.allow)
//            let ctrl = CatalogViewController.init()
//            ctrl.currentLinkStr = linkStr
//            guard let navCntr = self.navigationController else { return }
//            navCntr.pushViewController(ctrl, animated: true)
            return
        } else if linkStr.contains("tel:") {
            decisionHandler(.allow); return
        }
        decisionHandler(.cancel)
    }
}

