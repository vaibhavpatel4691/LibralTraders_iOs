//
//  PrductDescriptionTableViewCell.swift
//  Mobikul Single App
//
//  Created by jitendra on 28/05/21.
//  Copyright © 2021 Webkul. All rights reserved.
//

import UIKit
import WebKit

class PrductDescriptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var webviewDesc: WKWebView!
    @IBOutlet weak var heightOfWebView: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        webviewDesc.navigationDelegate = self
        // Initialization code
    }
    var desc: String! {
        didSet{
            //webviewDesc.loadHTMLString(desc, baseURL: nil)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
extension PrductDescriptionTableViewCell: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        var scriptContent = "var meta = document.createElement('meta');"

                scriptContent += "meta.name='viewport';"

                scriptContent += "meta.content='width=device-width';"

                scriptContent += "document.getElementsByTagName('head')[0].appendChild(meta);"

         

                webView.evaluateJavaScript(scriptContent, completionHandler: nil)

                self.webviewDesc.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in

                        if complete != nil {

                            self.webviewDesc.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in

                                print(height, self.desc)
                                //self.heightOfWebView.constant = height as! CGFloat

                            })

                        }

         

                        })
    }
}
