//
//  ShareWishlistViewController.swift
//  Mobikul Single App
//
//  Created by akash on 22/05/19.
//  Copyright © 2019 Webkul. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields_ColorThemer
import MaterialComponents.MaterialTypographyScheme

class ShareWishlistViewController: UIViewController {
    
    @IBOutlet weak var emailTxtView: MDCTextField!
    @IBOutlet weak var messageTxtview: MDCMultilineTextField!
    @IBOutlet weak var submitButtonView: UIView!
    @IBOutlet weak var submitBtn: UIButton!
    
    var EmailController: MDCTextInputControllerOutlined!
    var messageController: MDCTextInputControllerBase!
    var viewModel = ShareWishlistViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                submitBtn.backgroundColor = AppStaticColors.darkButtonBackGroundColor
                submitBtn.setTitleColor(AppStaticColors.darkButtonTextColor, for: .normal)
                
            } else {
                submitBtn.backgroundColor = AppStaticColors.buttonBackGroundColor
                submitBtn.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
            }
        } else {
            submitBtn.backgroundColor = AppStaticColors.buttonBackGroundColor
            submitBtn.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
        }
        
        self.navigationItem.title = "Share Wishlist".localized
        EmailController = MDCTextInputControllerOutlined(textInput: emailTxtView)
        EmailController.activeColor = AppStaticColors.accentColor
        EmailController.floatingPlaceholderActiveColor = AppStaticColors.accentColor
        EmailController.placeholderText = "Email addresses, separated by commas".localized
        messageTxtview.minimumLines = 0
        messageController = MDCTextInputControllerOutlinedTextArea(textInput: messageTxtview)
        messageController.activeColor = AppStaticColors.accentColor
        messageController.floatingPlaceholderActiveColor = AppStaticColors.accentColor
        messageController.placeholderText = "Message".localized
        submitButtonView.shadowBorder()
        submitBtn.setTitle("Share Wish List".localized, for: .normal)
        
        
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                emailTxtView.textColor = UIColor.white
                messageTxtview.textColor = UIColor.white
                EmailController.floatingPlaceholderNormalColor = AppStaticColors.accentColor
                EmailController.inlinePlaceholderColor = AppStaticColors.accentColor
                
                
                messageController.floatingPlaceholderNormalColor = AppStaticColors.accentColor
                messageController.inlinePlaceholderColor = AppStaticColors.accentColor
                
            } else {
                emailTxtView.textColor = AppStaticColors.accentColor
                messageTxtview.textColor = AppStaticColors.accentColor
            }
        } else {
            emailTxtView.textColor = AppStaticColors.accentColor
            messageTxtview.textColor = AppStaticColors.accentColor
        }
        
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
      if #available(iOS 12.0, *) {
              if self.traitCollection.userInterfaceStyle == .dark {
                  emailTxtView.textColor = UIColor.white
                messageTxtview.textColor = UIColor.white
                  EmailController.floatingPlaceholderNormalColor = AppStaticColors.accentColor
                  EmailController.inlinePlaceholderColor = AppStaticColors.accentColor
                
                
                messageController.floatingPlaceholderNormalColor = AppStaticColors.accentColor
                messageController.inlinePlaceholderColor = AppStaticColors.accentColor
                
              } else {
                  emailTxtView.textColor = AppStaticColors.accentColor
                messageTxtview.textColor = AppStaticColors.accentColor
              }
          } else {
              emailTxtView.textColor = AppStaticColors.accentColor
        messageTxtview.textColor = AppStaticColors.accentColor
          }
          
    }
    /*
    
     */
    
    @IBAction func tapSubmitBtn(_ sender: Any) {
        guard let subject = emailTxtView.text, subject.count != 0 else {
            self.showWarningSnackBar(msg: "Please enter email!".localized)
            emailTxtView.shake()
            return
        }
        
        if let emails = emailTxtView.text?.components(separatedBy: ",") {
            for email in emails {
                if !NetworkManager.sharedInstance.checkValidEmail(data: email) {
                    self.showWarningSnackBar(msg: "pleaseentervalidemail".localized)
                    emailTxtView.shake()
                    return
                }
            }
        }
        
        var dict = [String: Any]()
        dict["emails"] = self.emailTxtView.text ?? ""
        dict["message"] = self.messageTxtview.text ?? ""
        callRequest(dict: dict, apiCall: .shareWishList)
    }
    
    func callRequest(dict: [String: Any], apiCall: WhichApiCall) {
        viewModel.callingHttppApi(dict: dict, apiCall: apiCall) { [weak self] success in
            NetworkManager.sharedInstance.dismissLoader()
            guard self != nil else { return }
            if success {
                if apiCall == .shareWishList {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
