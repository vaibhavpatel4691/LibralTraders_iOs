//
//  VideoWebviewViewController.swift
//  Mobikul Single App
//
//  Created by akash on 02/05/19.
//  Copyright © 2019 Webkul. All rights reserved.
//

import UIKit
import WebKit

class VideoWebviewViewController: UIViewController, WKNavigationDelegate {
    
    var webView : WKWebView!
    var videoURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // videoURL = "https://iosdevcenters.blogspot.com/"
        if let url = URL(string: videoURL) {
            let request = URLRequest(url: url)
            webView = WKWebView(frame: self.view.frame)
            webView.navigationDelegate = self
            webView.load(request)
            self.view.addSubview(webView)
            self.view.sendSubviewToBack(webView)
        }
    }
    
    @IBAction func barButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        NetworkManager.sharedInstance.showLoader()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        NetworkManager.sharedInstance.dismissLoader()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension VideoWebviewViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if !(navigationAction.targetFrame?.isMainFrame ?? false) {
            webView.load(navigationAction.request)
        }
        return nil
    }
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        let exceptions = SecTrustCopyExceptions(serverTrust)
        SecTrustSetExceptions(serverTrust, exceptions)
        completionHandler(.useCredential, URLCredential(trust: serverTrust));
    }
}
