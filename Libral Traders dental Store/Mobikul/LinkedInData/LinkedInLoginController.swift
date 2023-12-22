//
//  LinkedInLoginController.swift
//  LinkedInSocialLogin
//
//  Created by siddhant on 26/02/21.
//

import UIKit
import WebKit

class LinkedInLoginController: UIViewController {
    
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    lazy var linkedInProcessing = LinkedInDataPage() {
        self.callBack?($0)
    }
    /// Return:- Response of LinkedIn Login
    var callBack: (([String: Any]) -> Void)?
    
    override func viewDidLoad() {
        
        navigationItem.title = "linkedin.com"
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelAction))
        navigationItem.leftBarButtonItem = cancelButton
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshAction))
        navigationItem.rightBarButtonItem = refreshButton
        appTheme()
        let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"
        let authURLFull = LinkedInConstants.AUTHURL + "?response_type=code&client_id=" + LinkedInConstants.CLIENT_ID + "&scope=" + LinkedInConstants.SCOPE + "&state=" + state + "&redirect_uri=" + LinkedInConstants.REDIRECT_URI
        
        let urlRequest = URLRequest.init(url: URL.init(string: authURLFull)!)
        webView.load(urlRequest)
    }
    func appTheme() {
        if #available(iOS 12.0, *) {

            if self.traitCollection.userInterfaceStyle == .dark {
             UINavigationBar.appearance().barTintColor = AppStaticColors.darkPrimaryColor
             self.navigationController?.navigationBar.barTintColor = AppStaticColors.darkPrimaryColor
             self.navigationController?.navigationBar.tintColor = AppStaticColors.darkItemTintColor
             UINavigationBar.appearance().tintColor = AppStaticColors.darkItemTintColor
             self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.darkItemTintColor]
             UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.darkItemTintColor]
                

            } else {
             UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
             self.navigationController?.navigationBar.barTintColor = AppStaticColors.primaryColor
             self.navigationController?.navigationBar.tintColor = AppStaticColors.itemTintColor
             UINavigationBar.appearance().tintColor = AppStaticColors.itemTintColor
             self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
             UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
             
         }
        } else {
           UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
            self.navigationController?.navigationBar.barTintColor = AppStaticColors.primaryColor
            self.navigationController?.navigationBar.tintColor = AppStaticColors.itemTintColor
            UINavigationBar.appearance().tintColor = AppStaticColors.itemTintColor
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]

        }

    }
    //MARK:- OBJC Methods
    @objc
    func cancelAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func refreshAction() {
        webView.reload()
    }
}

//MARK:- WKNavigation Delegate Methods
extension LinkedInLoginController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        linkedInProcessing.RequestForCallbackURL(request: navigationAction.request)
        
        //Close the View Controller after getting the authorization code
        if let urlStr = navigationAction.request.url?.absoluteString {
            if urlStr.contains("?code=") {
//                self.dismiss(animated: true, completion: nil)
                navigationController?.popViewController(animated: true)
            }
        }
        decisionHandler(.allow)
    }
}
