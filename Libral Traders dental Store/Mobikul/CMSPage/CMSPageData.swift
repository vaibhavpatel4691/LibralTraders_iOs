//
//  CMSPageData.swift
//  Ajmal
//
//  Created by Webkul on 05/05/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit
import WebKit
class CMSPageData: UIViewController, WKNavigationDelegate {
    
    public var cmsId: String!
    public var cmsName: String!
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var webView: WKWebView!
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        webView.stringByEvaluatingJavaScript(from: "document.body.style.webkitTouchCallout='none';")
        self.navigationController?.isNavigationBarHidden = false
        webView.navigationDelegate = self
        appTheme()
        if #available(iOS 12.0, *) {
                   if self.traitCollection.userInterfaceStyle == .dark {
                       
//                       webView.backgroundColor = UIColor.black
                   } else {
                       
                   }
               } else {
                    
               }
        self.callingHttppApi()
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.isNavigationBarHidden = false
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
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        DispatchQueue.main.async {
            self.appTheme()
        }
       }

          override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
              // Trait collection will change. Use this one so you know what the state is changing to.
          }
    func callingHttppApi() {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        requstParams["id"] = cmsId
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .get, apiname: .cmsData, currentView: self) {success, responseObject in
            if success == 1 {
                print("sss", JSON(responseObject as? NSDictionary ?? [:]))
                self.doFurtherProcessingWithResult(data: JSON(responseObject as? NSDictionary ?? [:]))
                
            } else if success == 2 {
                self.callingHttppApi()
            }
        }
    }
    
    func doFurtherProcessingWithResult(data: JSON) {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            NetworkManager.sharedInstance.dismissLoader()
            
            if let heading = data["title"].string {
                self.navigationController?.navigationBar.topItem?.title = heading
            }
            
            var HTMLString = String()
            let htmlContent =
            """
            <!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">
            <html lang=\"en\">
            <head>
            <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">
            <link rel=\"stylesheet\" type=\"text/css\" href=\"\(baseDomain)/pub/static/version1501785931/frontend/Magento/luma/en_US/css/styles-l.css\" media=\"all\">
            <link rel=\"stylesheet\" type=\"text/css\" href=\"\(baseDomain)/pub/static/version1501785931/frontend/Magento/luma/en_US/css/styles-m.css\" media=\"all\">
            <link rel=\"stylesheet\" type=\"text/css\" href=\"\(baseDomain)/pub/media/styles.css\" media=\"all\">
            </head>
            <body data-container="body" class="cms-privacy-policy-cookie-restriction-mode cms-page-view" style="padding:5px;">
            <div class="page-wrapper">
            <main id="maincontent" class="page-main">
            <div class="columns">
            <div class="column main">
            
            \(data["content"].stringValue)
            </div>
            </div>
            </main>
            </div>
            </body>
            
            </html>
            """
            
            if Defaults.language == "ar" {
                HTMLString = "<span dir=\"rtl\">\(htmlContent)</span></p>"
            } else {
                HTMLString = "<span dir=\"ltr\">\(htmlContent)</span></p>"
            }
            
            self.webView.loadHTMLString(HTMLString, baseURL: nil)
        }
        
    }
//    func webView(_ inWeb: UIWebView, shouldStartLoadWith inRequest: URLRequest, inType: UIWebView.NavigationType) -> Bool {
//        if inType == .linkClicked {
//            if let url = inRequest.url {
//                UIApplication.shared.openURL(url)
//            }
//            return false
//        }
//        return true
//    }
    
    
    
//    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
//        if navigationType == .linkClicked {
//            if let url = request.url {
//                UIApplication.shared.openURL(url)
//            }
//            return false
//        }
//        return true
//    }
//    @available(iOS 13.0, *)
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
//         print("fdsdsfdf")
//       
//            decisionHandler(.allow, preferences) 
//    }
//    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//       
//        if let url = webView.url {
//            print(url.absoluteString) // It will give the selected link URL
//            UIApplication.shared.openURL(url)
//            
//        }
//        decisionHandler(.allow)
//    }
//    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: ((WKNavigationActionPolicy) -> Void)) {
//        if (navigationAction.navigationType == .linkActivated){
//            decisionHandler(.allow)
//        } else {
//            decisionHandler(.cancel)
//        }
//    }
}
