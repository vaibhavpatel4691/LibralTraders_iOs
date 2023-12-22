//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: ProductShortDescriptionTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit
import WebKit

class ProductShortDescriptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var webviewDesc: WKWebView!
    @IBOutlet weak var heightOfWebView: NSLayoutConstraint!
    @IBOutlet weak var descLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        webviewDesc.navigationDelegate = self
        // Initialization code
    }
    var desc: String! {
        didSet{
            //webviewDesc.loadHTMLString(desc, baseURL: nil)
            //descLbl.text = desc
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension ProductShortDescriptionTableViewCell: WKNavigationDelegate {
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
