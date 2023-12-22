//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: CommentsDataViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */
import UIKit
import MaterialComponents.MaterialTextFields_ColorThemer
import MaterialComponents.MaterialTypographyScheme

class CommentsDataViewController: UIViewController {
    
    @IBOutlet weak var textView: MDCMultilineTextField!
    @IBOutlet weak var updateCommentLabel: UILabel!
    
    var textViewController: MDCTextInputControllerBase!
    
    var comment = ""
    var callback: ((String)->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Comment".localized
        updateCommentLabel.text = "Update Comment".localized.uppercased()
        //        textView.applyButtonBorder(colours: AppStaticColors.accentColor)
        //        textView.layer.cornerRadius = 4
        //        textView.text = comment
        //        textView.becomeFirstResponder()
        
        
        textView.minimumLines = 0
        textViewController = MDCTextInputControllerOutlinedTextArea(textInput: textView)
        textViewController.activeColor = AppStaticColors.accentColor
        textViewController.floatingPlaceholderActiveColor = AppStaticColors.accentColor
        textViewController.placeholderText = "Comment".localized
        textView.text = comment
        textView.becomeFirstResponder()
        self.appTheme()
        // Do any additional setup after loading the view.
    }
    @IBAction func tickClicked(_ sender: Any) {
        if let text = textView.text, text.count > 0 , text.removeWhiteSpace
            .count > 0 {
            callback?(text)
            self.dismiss(animated: true, completion: nil)
        } else {
            ShowNotificationMessages.sharedInstance.warningView(message: "Please write a comment!!!".localized)
        }
    }
    
    
    func appTheme() {
        if #available(iOS 12.0, *) {
            
            if self.traitCollection.userInterfaceStyle == .dark {
                UINavigationBar.appearance().barTintColor = AppStaticColors.darkPrimaryColor
                UIBarButtonItem.appearance().tintColor = AppStaticColors.darkItemTintColor
                
                self.navigationController?.navigationBar.barTintColor = AppStaticColors.darkPrimaryColor
                self.navigationController?.navigationBar.tintColor = AppStaticColors.darkItemTintColor
                UINavigationBar.appearance().tintColor = AppStaticColors.darkItemTintColor
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.darkItemTintColor]
                UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.darkItemTintColor]
                self.navigationItem.leftBarButtonItem?.tintColor = AppStaticColors.darkItemTintColor
                self.navigationItem.rightBarButtonItem?.tintColor = AppStaticColors.darkItemTintColor
                
            } else {
                self.navigationItem.leftBarButtonItem?.tintColor = AppStaticColors.itemTintColor
                self.navigationItem.rightBarButtonItem?.tintColor = AppStaticColors.itemTintColor
                UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
                self.navigationController?.navigationBar.barTintColor = AppStaticColors.primaryColor
                self.navigationController?.navigationBar.tintColor = AppStaticColors.itemTintColor
                UINavigationBar.appearance().tintColor = AppStaticColors.itemTintColor
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
                UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
                UIBarButtonItem.appearance().tintColor = AppStaticColors.itemTintColor
                
            }
        } else {
            self.navigationItem.leftBarButtonItem?.tintColor = AppStaticColors.itemTintColor
            self.navigationItem.rightBarButtonItem?.tintColor = AppStaticColors.itemTintColor
            UIBarButtonItem.appearance().tintColor = AppStaticColors.itemTintColor
            UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
            self.navigationController?.navigationBar.barTintColor = AppStaticColors.primaryColor
            self.navigationController?.navigationBar.tintColor = AppStaticColors.itemTintColor
            UINavigationBar.appearance().tintColor = AppStaticColors.itemTintColor
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
            
        }
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                textView.textColor = UIColor.white
                textViewController.floatingPlaceholderNormalColor = AppStaticColors.accentColor
                textViewController.inlinePlaceholderColor = AppStaticColors.accentColor
            } else {
                textView.textColor = AppStaticColors.accentColor
            }
        } else {
            textView.textColor = AppStaticColors.accentColor
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
    
    
    @IBAction func crossClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
