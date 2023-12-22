//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: SocialLoginViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit
import Firebase
import AuthenticationServices
import SwiftKeychainWrapper

class SocialLoginViewController: UIViewController {
    
    // MARK: - outlates
    var movetoSignal = ""
    
    @IBOutlet weak var backImg: UIBarButtonItem!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var signOrRegisterLbl: UILabel!
    
    @IBOutlet weak var appleSignin: UIButton!
    @IBOutlet weak var signWithEmailView: UIView!
    @IBOutlet weak var signWithEmailBtn: UIButton!
    @IBOutlet weak var createAccountView: UIView!
    @IBOutlet weak var createAccountBtn: UIButton!
    @IBOutlet weak var orLeftView: UIView!
    @IBOutlet weak var orLbl: UILabel!
    @IBOutlet weak var orRightView: UIView!
    @IBOutlet weak var socailView: UIView!
    @IBOutlet weak var gmailBtn: UIButton!
    @IBOutlet weak var fbBtn: UIButton!
    @IBOutlet weak var twitterBtn: UIButton!
    @IBOutlet weak var linkdinBtn: UIButton!
    var viewModel: SocialLoginviewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Defaults.language == "ar" {
            appleSignin.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        }
        self.navigationItem.title = "Sign In or Register".localized
        signOrRegisterLbl.text = "Sign In or Register".localized.uppercased()
        appName.text = socialLoginApplicationName.localized
        signWithEmailBtn.setTitle("Sign In with Email".localized.uppercased(), for: .normal)
        createAccountBtn.setTitle("Create an Account".localized.uppercased(), for: .normal)
        self.theme()
        
        
        self.navigationController?.navigationBar.tintColor = AppStaticColors.accentColor
        appleSignin.addTapGestureRecognizer {
           
        }
        twitterBtn.isHidden = true
        viewModel = SocialLoginviewModel()
        viewModel.apiType = "form"
        callRequest(dict: [:])
                fbBtn.isHidden = true
                gmailBtn.isHidden = true
                appleSignin.isHidden = true
                orLbl.isHidden = true
                orLeftView.isHidden = true
                orRightView.isHidden = true
        twitterBtn.isHidden = true
        linkdinBtn.isHidden = true
        self.viewModel.apiType = "countryCode"
        callRequest(dict: [:])
    }
    private var fourDigitNumber: String {
        var result = ""
        repeat {
            // Create a string with a random number 0...9999
            result = String(format:"%04d", arc4random_uniform(10000) )
        } while Set<Character>(result).count < 4
        return result
    }
    func callRequest(dict: [String: Any]) {
        if viewModel.apiType == "form" {
            viewModel.apiName = .createAccountFormData
            viewModel?.callingHttppApi(dict: dict) { [weak self] success in
                NetworkManager.sharedInstance.dismissLoader()
                guard self != nil else { return }
                if success {
                   
                    print("")
                } else {
                }
            }
        } else if viewModel.apiType == "countryCode" {
           
            self.viewModel.apiName = .countryCode
            self.viewModel?.callingHttppApi(dict: dict) { [weak self] success in
                NetworkManager.sharedInstance.dismissLoader()
                guard self != nil else { return }
                if success {
                    print("")
                }
            }
        } else {
            
            viewModel?.callingHttppApi(dict: dict) { [weak self] success in
                NetworkManager.sharedInstance.dismissLoader()
                guard self != nil else { return }
                if success {
                    if self?.movetoSignal == "cart"{
                        self?.performSegue(withIdentifier: "checkout", sender: self)
                    }
                    self?.tabBarController?.tabBar.isHidden = false
                    self?.navigationController?.popViewController(animated: true)
                } else {
                }
            }
        }
    }
    
    func theme() {
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                signWithEmailBtn.backgroundColor = AppStaticColors.defaultColor
                signWithEmailBtn.setTitleColor(AppStaticColors.darkButtonBackGroundColor, for: .normal)
                createAccountBtn.backgroundColor = AppStaticColors.defaultColor
                createAccountBtn.setTitleColor(AppStaticColors.darkButtonBackGroundColor, for: .normal)
                signWithEmailView.backgroundColor = AppStaticColors.darkButtonBackGroundColor
                createAccountView.backgroundColor = AppStaticColors.darkButtonBackGroundColor
                UINavigationBar.appearance().barTintColor = AppStaticColors.darkPrimaryColor
                self.navigationController?.navigationBar.barTintColor = AppStaticColors.darkPrimaryColor
                self.navigationController?.navigationBar.tintColor = AppStaticColors.darkItemTintColor
                UINavigationBar.appearance().tintColor = AppStaticColors.darkItemTintColor
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.darkItemTintColor]
                UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.darkItemTintColor]
                
                
            } else {
                signWithEmailBtn.backgroundColor = AppStaticColors.defaultColor
                signWithEmailBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
                createAccountBtn.backgroundColor = AppStaticColors.defaultColor
                createAccountBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
                signWithEmailView.backgroundColor = AppStaticColors.buttonBackGroundColor
                createAccountView.backgroundColor = AppStaticColors.buttonBackGroundColor
                UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
                self.navigationController?.navigationBar.barTintColor = AppStaticColors.primaryColor
                self.navigationController?.navigationBar.tintColor = AppStaticColors.itemTintColor
                UINavigationBar.appearance().tintColor = AppStaticColors.itemTintColor
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
                UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
                
            }
        } else {
            signWithEmailBtn.backgroundColor = AppStaticColors.defaultColor
            signWithEmailBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
            createAccountBtn.backgroundColor = AppStaticColors.defaultColor
            createAccountBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
            signWithEmailView.backgroundColor = AppStaticColors.buttonBackGroundColor
            createAccountView.backgroundColor = AppStaticColors.buttonBackGroundColor
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
            self.theme()
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        // Trait collection will change. Use this one so you know what the state is changing to.
        
    }
    // MARK: - Gmail Click
    @IBAction func googleClick(_ sender: Any) {
        
    }
    
    // MARK: - Fb Click
    @IBAction func fbClicked(_ sender: Any){
        
        
        
    }
    
    
    @IBAction func backAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signInWithEmail(_ sender: Any) {
        let customerLoginVC = LoginViewController.instantiate(fromAppStoryboard: .customer)
        customerLoginVC.delegate = self
        customerLoginVC.countryData = self.viewModel?.countryData ?? []
        let nav = UINavigationController(rootViewController: customerLoginVC)
        nav.modalPresentationStyle = .fullScreen
        //nav.navigationBar.tintColor = AppStaticColors.accentColor
        self.present(nav, animated: true, completion: nil)
    }
    
    //CreateAnAccountViewController
    @IBAction func createAnAccountAct(_ sender: Any) {
        let customerCreateAccountVC = MobileLoginViewController.instantiate(fromAppStoryboard: .customer)
        //customerCreateAccountVC.delegate = self
        customerCreateAccountVC.countryData = self.viewModel?.countryData ?? []
        customerCreateAccountVC.delegate = self
        let nav = UINavigationController(rootViewController: customerCreateAccountVC)
        nav.modalPresentationStyle = .fullScreen
        //nav.navigationBar.tintColor = AppStaticColors.accentColor
        self.present(nav, animated: true, completion: nil)
    }
}

protocol LoginPop: NSObjectProtocol {
    func loginPop()
}

extension SocialLoginViewController: LoginPop {
    func loginPop() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension NSMutableAttributedString {
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            
            self.addAttribute(.link, value: linkURL, range: foundRange)
            
            return true
        }
        return false
    }
}

