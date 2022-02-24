//
//  PrivacyPolicyViewController.swift
//  XapoTest
//
//  Created by Olivier on 2/24/22.
//

import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController, WKUIDelegate {
    
    var url:String!
    var webView: WKWebView!
   
    // setting  up webview
    override func loadView() {
        super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // open URL
        webView.load(URLRequest(url: URL(string: url)!))
    }
    
   

}
