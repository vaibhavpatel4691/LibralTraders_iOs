//
/**
 * Webkul Software.
 * @package  Mobikul App
 * @Category Webkul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html ASL Licence
 * @link https://store.webkul.com/license.html
 
 */

import UIKit
import MaterialComponents.MaterialTextFields_ColorThemer
import MaterialComponents.MaterialTypographyScheme
import Alamofire
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var dropDownView: UIImageView!
    @IBOutlet weak var countryCodeLbl: UILabel!
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var sendOtpBtn: UIButton!
    @IBOutlet weak var mobileDescripLabel: UILabel!
    @IBOutlet weak var mobileNoTf: UITextField!
    @IBOutlet weak var coutryCodeView: UIView!
    @IBOutlet weak var emailViewHeight: NSLayoutConstraint!
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var btnOutlet: UIButton!
    let defaults = UserDefaults.standard
    var emailController: MDCTextInputControllerOutlined!
    var passwordController: MDCTextInputControllerOutlined!
    @IBOutlet weak var emailTextField: MDCTextField!
    @IBOutlet weak var passwordTextField: MDCTextField!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var loginSegment: UISegmentedControl!
    @IBOutlet weak var signView: UIView!
    
    @IBOutlet weak var verifyOtpTf: UITextField!
    @IBOutlet weak var verifyView: UIView!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label1: UILabel!
    
    
    
    var userEmail: String = ""
    let button = UIButton(type: .custom)
    var viewModel = SignInViewModel()
    var countryData = [GetCountryData]()
    weak var delegate: LoginPop?
    var parentController = ""
    var email: String?
    var signInHandler: (() -> ())?
    var touchID:TouchID!
    var NotAgainCallTouchId :Bool = false
    
    let transparentView = UIView()
    var counter = 120
    var timer = Timer()
    let tableView = UITableView()
    var mobileNumber = ""
     var countryCode = ""
     var isMobileNumber: Bool = false
     var otpValue = ""
    
    private var apiName: WhichApiCall = .sendOTP
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        if let index = countryData.firstIndex(where: {$0.country_code == "in"}) {
            countryImage.setImage(fromURL: countryData[index].image)
            countryCodeLbl.text =  countryData[index].dial_code
        } else {
            callingHttppApiCode { success in
                if let index = self.countryData.firstIndex(where: {$0.country_code == "in"}) {
                    self.countryImage.setImage(fromURL: self.countryData[index].image)
                    self.countryCodeLbl.text =  self.countryData[index].dial_code
                }
            }
        }
            
        emailView.isHidden = true
        emailViewHeight.constant = 150
        otpView.isHidden = false
        passwordTextField.isSecureTextEntry = true
        #if MARKETPLACE
        emailTextField.text = ""
        passwordTextField.text = ""
        #endif
        #if HYPERLOCAL || BTOB
        emailTextField.text = ""
        passwordTextField.text = ""
        #endif
        verifyView.shadowBorder()
        forgotPasswordBtn.titleLabel?.textColor = UIColor.lightGray
        self.navigationItem.title = "Sign In with Email".localized
        signInButton.setTitle("Sign In".localized.uppercased(), for: .normal)
        createAccountButton.setTitle("Create an Account".localized.uppercased(), for: .normal)
        forgotPasswordBtn.setTitle("Forgot password?".localized, for: .normal)
        self.touchID = TouchID(view:self)
        btnOutlet.setTitle("", for: .normal)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: CountryTableViewCell.self)
        DispatchQueue.main.async {
            self.emailController = MDCTextInputControllerOutlined(textInput: self.emailTextField)
            self.passwordController = MDCTextInputControllerOutlined(textInput: self.passwordTextField)
            let allTextFieldController: [MDCTextInputControllerOutlined] = [self.emailController, self.passwordController]
            for textFieldController in allTextFieldController {
                textFieldController.activeColor = AppStaticColors.accentColor
                textFieldController.floatingPlaceholderActiveColor = AppStaticColors.accentColor
            }
            self.emailController.placeholderText = "Email Address".localized
            self.passwordController.placeholderText = "Password".localized
            if #available(iOS 12.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark {
                    self.emailTextField.textColor = UIColor.white
                    self.passwordTextField.textColor = UIColor.white
                    
                    self.emailController.floatingPlaceholderNormalColor = AppStaticColors.accentColor
                    self.emailController.inlinePlaceholderColor = AppStaticColors.accentColor
                    self.passwordController.floatingPlaceholderNormalColor = AppStaticColors.accentColor
                    self.passwordController.inlinePlaceholderColor = AppStaticColors.accentColor
                } else {
                    self.emailTextField.textColor = AppStaticColors.accentColor
                    self.passwordTextField.textColor = AppStaticColors.accentColor
                    
                }
            } else {
                self.emailTextField.textColor = AppStaticColors.accentColor
                self.passwordTextField.textColor = AppStaticColors.accentColor
            }
        }
        theme()
        // MARK: - code for hide show btn
        button.setImage(UIImage(named: "closePassword"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .white
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(passwordTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.revealPassword), for: .touchUpInside)
        
        passwordTextField.rightView = button
        passwordTextField.rightView?.backgroundColor = .white
        passwordTextField.rightViewMode = .always
        if let email = email {
            emailTextField.text = email
            passwordTextField.text = ""
        }
        if #available(iOS 12.0, *) {
            emailTextField.textContentType = .username
            passwordTextField.textContentType = .password
        }
        
        if Defaults.language == "ar" {
            emailTextField.semanticContentAttribute = .forceRightToLeft
            passwordTextField.semanticContentAttribute = .forceRightToLeft
            emailTextField.textAlignment = .right
            passwordTextField.textAlignment = .right
        } else {
            emailTextField.semanticContentAttribute = .forceLeftToRight
            passwordTextField.semanticContentAttribute = .forceLeftToRight
            emailTextField.textAlignment = .left
            passwordTextField.textAlignment = .left
        }
        
    }
    @IBAction func btnTap(_ sender: Any) {
        addTransparentView(frames: btnOutlet.frame)
    }
    @IBAction func sendOTPBtnTap(_ sender: Any) {
        if self.mobileNoTf.text == "" {
            ShowNotificationMessages.sharedInstance.warningView(message: "Please enter mobile number")
        }else{
            var dict = [String:Any]()
            mobileNumber = self.countryCodeLbl.text ?? ""
            dict["mobile"] = mobileNumber+(self.mobileNoTf.text ?? "")
            //dict["type"]  = "register"
            self.callingHttppApi(dict: dict, apiCall: .sendOTP) { [self] success in
                if success{
                   /* if self.counter != 0 {
                        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
                    }
                    
                    
                    self.label2.isHidden = false
                    self.verifyView.isHidden = false
                    self.verifyOtpTf.becomeFirstResponder()*/
                  //  self.verifyOtpTf.text =  self.otpValue
                    //self..constant = 312
                   // self.bottomViewHeightCons.constant = 150
                    let otpViewController = OTPViewController.instantiate(fromAppStoryboard: .customer)
                    // customerCreateAccountVC.parentController = "signIn"
                    // customerCreateAccountVC.delegate = delegate
                    mobileNumber = self.countryCodeLbl.text ?? ""
                    otpViewController.mobileNumber = mobileNumber+(self.mobileNoTf.text ?? "")
                    otpViewController.isFromSignUp = false
                    self.navigationController?.pushViewController(otpViewController, animated: true)
                }
                
            }
        }
    }
    
    @IBAction func verifyOtptap(_ sender: Any) {
        if verifyOtpTf.text == "" {
            ShowNotificationMessages.sharedInstance.warningView(message: "Please Enter The Code")
        }else{
            var dict = [String:Any]()
            mobileNumber = self.countryCodeLbl.text ?? ""
            dict["mobile"] = mobileNumber+(self.mobileNoTf.text ?? "")
            dict["otp"] = self.verifyOtpTf.text ?? ""
            //dict["type"]  = "register"
            self.callingHttppApi(dict: dict, apiCall: .VerifyOTP) { success in
                if success{
                    self.verifyView.isHidden = true
                    self.verifyOtpTf.text = ""
//                    let customerCreateAccountVC = CreateAnAccountViewController.instantiate(fromAppStoryboard: .customer)
//                    //customerCreateAccountVC.delegate = self
//                    customerCreateAccountVC.mobileNo = self.mobileNumber+(self.mobileNoTf.text ?? "")
//                    let nav = UINavigationController(rootViewController: customerCreateAccountVC)
//                    nav.modalPresentationStyle = .fullScreen
//                    //nav.navigationBar.tintColor = AppStaticColors.accentColor
//                    self.present(nav, animated: true, completion: nil)
                    var dict = [String: Any]()
                    dict["username"] = ""
                    dict["password"] = ""
                    dict["mobile"] = self.mobileNumber+(self.mobileNoTf.text ?? "")
                    dict["token"] = Defaults.deviceToken
                    self.viewModel.isMobile = true
                    self.callRequest(dict: dict, apiCall: .login)
                    
                    
                }
               
            }

          
        }
      
    }
    @objc func timerAction() {
            counter -= 1
        label2.text = "Resend OTP in \(counter) second"
        if counter == 0 {
            self.verifyView.isHidden = true
            self.sendOtpBtn.setTitle("Resend OTP", for: .normal)
            timer.invalidate()
            counter = 120
            label2.isHidden = true
        }
        }
    func theme() {
        
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                signView.backgroundColor = AppStaticColors.darkButtonBackGroundColor
                signInButton.backgroundColor = AppStaticColors.darkButtonBackGroundColor
                if #available(iOS 13.0, *) {
                    loginSegment.selectedSegmentTintColor = AppStaticColors.darkButtonBackGroundColor
                } else {
                    // Fallback on earlier versions
                }
                sendOtpBtn.backgroundColor = AppStaticColors.darkButtonBackGroundColor
                signInButton.setTitleColor(AppStaticColors.darkButtonTextColor, for: .normal)
                createAccountButton.backgroundColor = AppStaticColors.defaultColor
                createAccountButton.setTitleColor(AppStaticColors.darkButtonBackGroundColor, for: .normal)
                emailTextField.textColor = UIColor.white
                passwordTextField.textColor = UIColor.white
                UINavigationBar.appearance().barTintColor = AppStaticColors.darkPrimaryColor
                self.navigationController?.navigationBar.barTintColor = AppStaticColors.darkPrimaryColor
                self.navigationController?.navigationBar.tintColor = AppStaticColors.darkItemTintColor
                UINavigationBar.appearance().tintColor = AppStaticColors.darkItemTintColor
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.darkItemTintColor]
                UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.darkItemTintColor]
                   

                if emailController != nil {
                    emailController.floatingPlaceholderNormalColor = AppStaticColors.accentColor
                    emailController.inlinePlaceholderColor = AppStaticColors.accentColor
                    passwordController.floatingPlaceholderNormalColor = AppStaticColors.accentColor
                    passwordController.inlinePlaceholderColor = AppStaticColors.accentColor
                }
            } else {
                emailTextField.textColor = AppStaticColors.accentColor
                passwordTextField.textColor = AppStaticColors.accentColor
                signView.backgroundColor = AppStaticColors.buttonBackGroundColor
                signInButton.backgroundColor = AppStaticColors.buttonBackGroundColor
                if #available(iOS 13.0, *) {
                    loginSegment.selectedSegmentTintColor = AppStaticColors.buttonBackGroundColor
                } else {
                    // Fallback on earlier versions
                }
                sendOtpBtn.backgroundColor = AppStaticColors.buttonBackGroundColor
                signInButton.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
                createAccountButton.backgroundColor = AppStaticColors.defaultColor
                createAccountButton.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
                UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
                self.navigationController?.navigationBar.barTintColor = AppStaticColors.primaryColor
                self.navigationController?.navigationBar.tintColor = AppStaticColors.itemTintColor
                UINavigationBar.appearance().tintColor = AppStaticColors.itemTintColor
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
                UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
            }
        } else {
            emailTextField.textColor = AppStaticColors.accentColor
            passwordTextField.textColor = AppStaticColors.accentColor
            signView.backgroundColor = AppStaticColors.buttonBackGroundColor
            sendOtpBtn.backgroundColor = AppStaticColors.buttonBackGroundColor
            if #available(iOS 13.0, *) {
                loginSegment.selectedSegmentTintColor = AppStaticColors.buttonBackGroundColor
            } else {
                // Fallback on earlier versions
            }
            signInButton.backgroundColor = AppStaticColors.buttonBackGroundColor
            signInButton.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
            createAccountButton.backgroundColor = AppStaticColors.defaultColor
            createAccountButton.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
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
    // MARK: - revel password func
    @objc func revealPassword(_ sender: Any) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        if passwordTextField.isSecureTextEntry {
            button.setImage(UIImage(named: "closePassword"), for: .normal)
        } else {
            button.setImage(UIImage(named: "seePassword"), for: .normal)
        }
    }
    @IBAction func segmentClick(_ sender: Any) {
        switch loginSegment.selectedSegmentIndex {
        case 0:
            emailView.isHidden = true
            emailViewHeight.constant = 150
            otpView.isHidden = false
            
        case 1:
            emailView.isHidden = false
            emailViewHeight.constant = 280
            otpView.isHidden = true
        default:
            break
        }
        
    }
    
    // MARK: - forget password
    @IBAction func forgotPasswordAction(_ sender: Any) {
        let AC = UIAlertController(title: "enteremail".localized, message: "", preferredStyle: .alert)
        AC.addTextField { (textField) in
            textField.placeholder = "enteremail".localized
            textField.text = self.emailTextField.text
        }
        let okBtn = UIAlertAction(title: "Ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            let textField = AC.textFields![0]
            guard let emailId = textField.text, emailId.count>1 else {
                self.showWarningSnackBar(msg: "pleasefillemailid".localized)
                return
            }
            if !NetworkManager.sharedInstance.checkValidEmail(data: emailId) {
                self.showWarningSnackBar(msg: "pleaseentervalidemail".localized)
                return
            }
            var dict = [String: Any]()
            dict["username"] = emailId
            self.callRequest(dict: dict, apiCall: .forgetPassword)
        })
        let noBtn = UIAlertAction(title: "Cancel".localized, style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(okBtn)
        AC.addAction(noBtn)
        self.present(AC, animated: true, completion: {  })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Defaults.touchFlag == "1"{
            touchID.askForLocalAuthentication(message: "loginthrough".localized) { [weak self] in
                if $0 {
                    self?.touchID.checkUserAuthentication(taskCallback: { (sucess) in
                        if sucess{
                            self?.emailTextField.text = Defaults.touchEmail ?? ""
                            self?.passwordTextField.text = Defaults.touchPassword ?? ""
                            self?.NotAgainCallTouchId = true
                            var dict = [String: Any]()
                            dict["username"] = self?.emailTextField.text ?? ""
                            dict["password"] = self?.passwordTextField.text ?? ""
                            dict["token"] = Defaults.deviceToken
                            self?.callRequest(dict: dict, apiCall: .login)
                        }
                    })
                }
            }
        }
    }
    func calltouch(){
        if Defaults.touchFlag != nil && self.NotAgainCallTouchId == false {
            if Defaults.touchFlag == "0" {
                touchID.askForLocalAuthentication(message: "wouldyouliketoconnectappwith".localized) { [weak self] in
                    if $0 {
                        self?.touchID.checkUserAuthentication(taskCallback: { (sucess) in
                            if sucess{
                                Defaults.touchFlag = "1"
                                Defaults.touchEmail = self?.emailTextField.text ?? ""
                                Defaults.touchPassword = self?.passwordTextField.text ?? ""
//                                self?.dismiss(animated: true, completion: {
//                                    if let signInHandler = self?.signInHandler {
//                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHomeApiData"), object: nil)
//                                        signInHandler()
//                                    } else {
//                                        if let signInHandler = self?.signInHandler {
//                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHome"), object: nil)
//                                            signInHandler()
//                                        }
//                                    }
//
//                                    self?.delegate?.loginPop()
//                                })
                                LaunchHome.shared.launchHomeTabbar()
                            } else {
                                Defaults.touchFlag = "0"
//                                self?.dismiss(animated: true, completion: {
//                                    if let signInHandler = self?.signInHandler {
//                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHomeApiData"), object: nil)
//                                        signInHandler()
//                                    } else {
//                                        if let signInHandler = self?.signInHandler {
//                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHome"), object: nil)
//                                            signInHandler()
//                                        }
//                                    }
//
//                                    self?.delegate?.loginPop()
//                                })
                                LaunchHome.shared.launchHomeTabbar()
                            }
                        })
                    } else {
                        Defaults.touchFlag = "0"
//                        self?.dismiss(animated: true, completion: {
//                            if let signInHandler = self?.signInHandler {
//                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHomeApiData"), object: nil)
//                                signInHandler()
//                            } else {
//                                if let signInHandler = self?.signInHandler {
//                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHome"), object: nil)
//                                    signInHandler()
//                                }
//                            }
//
//                            self?.delegate?.loginPop()
//                        })
                        LaunchHome.shared.launchHomeTabbar()
                    }
                }
            } else if Defaults.touchFlag == "1" {
                touchID.askForLocalAuthentication(message: "wouldyouliketoreset".localized) { [weak self] in
                    if $0 {
                        self?.touchID.checkUserAuthentication(taskCallback: { (sucess) in
                            if sucess{
                                Defaults.touchFlag = "1"
                                Defaults.touchEmail = self?.emailTextField.text ?? ""
                                Defaults.touchPassword = self?.passwordTextField.text ?? ""
//                                self?.dismiss(animated: true, completion: {
//                                    if let signInHandler = self?.signInHandler {
//                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHomeApiData"), object: nil)
//                                        signInHandler()
//                                    } else {
//                                        if let signInHandler = self?.signInHandler {
//                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHome"), object: nil)
//                                            signInHandler()
//                                        }
//                                    }
//
//                                    self?.delegate?.loginPop()
//                                })
                                LaunchHome.shared.launchHomeTabbar()
                            }else{
                                Defaults.touchFlag = "0"
//                                self?.dismiss(animated: true, completion: {
//                                    if let signInHandler = self?.signInHandler {
//                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHomeApiData"), object: nil)
//                                        signInHandler()
//                                    } else {
//                                        if let signInHandler = self?.signInHandler {
//                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHome"), object: nil)
//                                            signInHandler()
//                                        }
//                                    }
//
//                                    self?.delegate?.loginPop()
//                                })
                                LaunchHome.shared.launchHomeTabbar()
                            }
                        })
                    } else {
                        Defaults.touchFlag = "0"
//                        self?.dismiss(animated: true, completion: {
//                            if let signInHandler = self?.signInHandler {
//                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHomeApiData"), object: nil)
//                                signInHandler()
//                            } else {
//                                if let signInHandler = self?.signInHandler {
//                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHome"), object: nil)
//                                    signInHandler()
//                                }
//                            }
//
//                            self?.delegate?.loginPop()
//                        })
                        LaunchHome.shared.launchHomeTabbar()
                    }
                }
            } else {
                self.delegate?.loginPop()
            }
        } else {
//            self.dismiss(animated: true, completion: {
//                if let signInHandler = self.signInHandler {
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHomeApiData"), object: nil)
//                    signInHandler()
//                } else {
//                    if let signInHandler = self.signInHandler {
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHome"), object: nil)
//                        signInHandler()
//                    }
//                }
//
//                self.delegate?.loginPop()
//            })
            
            LaunchHome.shared.launchHomeTabbar()
                    }
    }
    // MARK: - sign act
    @IBAction func signInAction(_ sender: Any) {
        guard let emailId = emailTextField.text, emailId.count != 0 else {
            self.showWarningSnackBar(msg: "enteremail".localized)
            emailTextField.shake()
            return
        }
        
        if !NetworkManager.sharedInstance.checkValidEmail(data: emailId) {
            self.showWarningSnackBar(msg: "pleaseentervalidemail".localized)
            emailTextField.shake()
            return
        }
        
        guard let password = passwordTextField.text, password.count != 0 else {
            self.showWarningSnackBar(msg: "enterpassword".localized)
            passwordTextField.shake()
            return
        }
        var dict = [String: Any]()
        dict["username"] = self.emailTextField.text ?? ""
        dict["password"] = self.passwordTextField.text ?? ""
        dict["token"] = Defaults.deviceToken
        viewModel.isMobile = false
        callRequest(dict: dict, apiCall: .login)
    }
    // MARK: - Api act
    func callRequest(dict: [String: Any], apiCall: WhichApiCall) {
        viewModel.callingHttppApi(dict: dict, apiCall: apiCall) { [weak self] success in
            NetworkManager.sharedInstance.dismissLoader()
            guard self != nil else { return }
            if success {
                if apiCall == .login {
                    self?.mobileNoTf.text  = ""
                    ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: "Login Successfully".localized)
                    self?.calltouch()
                }
            } else {
            }
        }
    }
    
    // MARK: - close btn act
    @IBAction func closeAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAnAccountAct(_ sender: Any) {
        if parentController == "signUp" {
            self.navigationController?.popViewController(animated: true)
        } else {
            let customerCreateAccountVC = MobileLoginViewController.instantiate(fromAppStoryboard: .customer)
           // customerCreateAccountVC.parentController = "signIn"
           // customerCreateAccountVC.delegate = delegate
            customerCreateAccountVC.delegate = delegate
            customerCreateAccountVC.countryData = countryData
            customerCreateAccountVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(customerCreateAccountVC, animated: true)
        }
        
        //        self.present(nav, animated: true, completion: nil)
        //        let nav = UINavigationController(rootViewController: customerCreateAccountVC)
        //        self.present(nav, animated: true, completion: nil)
    }
}

extension LoginViewController {
    func addTransparentView(frames: CGRect) {
             let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
             
        tableView.frame = CGRect(x: frames.origin.x+50, y: frames.origin.y+frames.height, width: frames.width+50, height: 0)
            self.view.addSubview(tableView)
             tableView.layer.cornerRadius = 5
             
             transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
             tableView.reloadData()
             let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
             transparentView.addGestureRecognizer(tapgesture)
             transparentView.alpha = 0
             UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                 self.transparentView.alpha = 0.5
                 self.tableView.frame = CGRect(x: frames.origin.x+20, y: frames.origin.y+frames.height+100 , width: frames.width, height: 500)
             }, completion: nil)
         }
    @objc func removeTransparentView() {
             let frames = btnOutlet.frame
             UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                 self.transparentView.alpha = 0
                 self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
             }, completion: nil)
         }
}
extension LoginViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell", for: indexPath) as? CountryTableViewCell
        cell?.countryCodeLabel?.text = self.countryData[indexPath.row].dial_code
        cell?.countryImage?.setImage(fromURL: self.countryData[indexPath.row].image)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        countryCodeLbl.text = (self.countryData[indexPath.row].dial_code ?? "")
        countryImage.setImage(fromURL: self.countryData[indexPath.row].image)
        
        removeTransparentView()
    }
}


extension LoginViewController {

    func callingHttppApi(dict: [String: Any], apiCall: WhichApiCall, completion: @escaping (Bool) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        
        var requstParams = [String: Any]()
        requstParams["storeId"] = Defaults.storeId
        if apiCall == .sendOTP {
            apiName = .sendOTP
            requstParams["mobile"] = dict["mobile"]
            requstParams["type"]  = "login"
            
        } else if apiCall == .VerifyOTP{
            apiName = .VerifyOTP
            requstParams["mobile"] = dict["mobile"]
            requstParams["otp"] = dict["otp"]
            requstParams["type"]  = "login"
        }
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .post, apiname: apiName, currentView: UIViewController()) { [weak self] success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            if success == 1 {
                guard let dict = responseObject as? NSDictionary else {
                    ShowNotificationMessages.sharedInstance.warningView(message: "somethingwentwrong".localized)
                    return
                }
                let responseJSON = JSON(dict)

                self?.doFurtherProcessingWithResult(data: responseJSON) { success in
                    completion(success)
                }
            } else if success == 2 {
                NetworkManager.sharedInstance.dismissLoader()
                self?.callingHttppApi(dict: dict, apiCall: apiCall) {success in
                    completion(success)
                }
            }
        }
    }
    
    func doFurtherProcessingWithResult(data: JSON, completion: (Bool) -> Void) {
        
        if apiName == .sendOTP {
            if data["success"].boolValue == true {
                if data["resend_link_count"].stringValue == "10" {
                    ShowNotificationMessages.sharedInstance.warningView(message: data["message"].stringValue)
                    completion(false)
                }else{
                    self.label1.text = data["message"].stringValue
                    self.label2.text = "Resend OTP attempt \(data["resend_attempt_count"].stringValue) of 10 left"
                   // self.otpValue = data["otp"].stringValue
                   
                    completion(true)
                }
            }else{
                ShowNotificationMessages.sharedInstance.warningView(message: data["message"].stringValue)
                completion(false)
            }
          
        } else if apiName == .VerifyOTP {
            if data["success"].boolValue == true {
                ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: data["message"].stringValue)
                completion(true)
            }else{
                ShowNotificationMessages.sharedInstance.warningView(message: data["message"].stringValue)
                completion(false)
            }
        } else {
            if data["success"].boolValue {
                ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: data["message"].stringValue)
            } else {
                ShowNotificationMessages.sharedInstance.warningView(message: data["message"].stringValue)
            }
            completion(true)
        }
    }

}


extension LoginViewController {
    func callingHttppApiCode(completion: @escaping (Bool) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .get, apiname: .countryCode, currentView: UIViewController()) { [weak self] success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            if success == 1 {
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                if jsonResponse["success"].boolValue == true {
                   
                        if let array = jsonResponse["country_code"].array {
                            self?.countryData = array.map{GetCountryData(data: $0)}
                        }else{
                            self?.countryData.append(GetCountryData(data: jsonResponse["country_code"]))
                        }
                   
                    
                    completion(true)
                } else {
                    if jsonResponse["message"].stringValue.removeWhiteSpace.count > 0 {
                        ShowNotificationMessages.sharedInstance.warningView(message: jsonResponse["message"].stringValue)
                    } else {
                        ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
                    }
                }
            } else if success == 2 {   // Retry in case of error
                NetworkManager.sharedInstance.dismissLoader()
                self?.callingHttppApiCode {success in
                    completion(success)
                    
                }
            }
        }
    }
    
   
    
    
}
