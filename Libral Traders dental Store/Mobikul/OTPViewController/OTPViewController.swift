//
//  OTPViewController.swift
//  Libral Traders
//
//  Created by Invention Hill on 16/10/23.
//

import UIKit

class OTPViewController: UIViewController {

    @IBOutlet weak var enterOtpCodeHeaderLabel: UILabel!
    @IBOutlet weak var timeCountLabel: UILabel!
    @IBOutlet weak var otpContainView: UIView!
    @IBOutlet weak var submitCodeButton: UIButton!
    
    var mobileNumber: String?
    let otpStackView = OTPStackView()
    
    var viewModel = SignInViewModel()

    private var apiName: WhichApiCall = .sendOTP
    var countdownTimer: Timer?
    var remainingSeconds = 120
    var isFromSignUp = false
    
    var touchID:TouchID!
    var NotAgainCallTouchId :Bool = false
    weak var delegate: LoginPop?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUPView()
        self.setUpOTPView()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        countdownTimer?.invalidate()
    }
    
    func setUPView() {
        self.submitCodeButton.layer.cornerRadius = 14
        self.enterOtpCodeHeaderLabel.text = "Enter the code from the sms we sent to \(self.mobileNumber ?? "0")"
    }
    
    func setUpOTPView() {
        submitCodeButton.isEnabled = false
        submitCodeButton.alpha = 0.3
        otpContainView.addSubview(otpStackView)
        otpStackView.delegate = self
        otpStackView.heightAnchor.constraint(equalTo: otpContainView.heightAnchor).isActive = true
        otpStackView.centerXAnchor.constraint(equalTo: otpContainView.centerXAnchor).isActive = true
        otpStackView.centerYAnchor.constraint(equalTo: otpContainView.centerYAnchor).isActive = true
        self.touchID = TouchID(view:self)
        startCountdownTimer()
    }
    
    func startCountdownTimer() {
        countdownTimer?.invalidate() // Invalidate previous timer if exists
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        remainingSeconds = 120 // Reset remaining seconds
        
    }
    
    @objc func updateTimer() {
        if remainingSeconds > 0 {
            remainingSeconds -= 1
            let minutes = remainingSeconds / 60
            let seconds = remainingSeconds % 60
            timeCountLabel.text = String(format: "%02d:%02d", minutes, seconds)
        } else {
            countdownTimer?.invalidate()
            countdownTimer = nil
            timeCountLabel.text = "0:0"
        }
    }
   
    @IBAction func codeResendButtonPressed(_ sender: UIButton) {
        var dict = [String:Any]()
         
         dict["mobile"] = self.mobileNumber
         //dict["type"]  = "register"
         self.callingHttppApi(dict: dict, apiCall: .sendOTP) { [self] success in
             if success {
                 countdownTimer?.invalidate()
                 self.startCountdownTimer()
             }
         }
    }
    
    @IBAction func submitCodeButtonPressed(_ sender: UIButton) {
        print("Final OTP : ",otpStackView.getOTP())
        let code = otpStackView.getOTP()
        
        var dict = [String:Any]()
        
        dict["mobile"] = self.mobileNumber
        dict["otp"] = code
        //dict["type"]  = "register"
        self.callingHttppApi(dict: dict, apiCall: .VerifyOTP) { success in
            if success {
                self.countdownTimer?.invalidate()
                self.countdownTimer = nil
                self.timeCountLabel.text = "0:0"
                if self.isFromSignUp {
                    let customerCreateAccountVC = CreateAnAccountViewController.instantiate(fromAppStoryboard: .customer)
                    //customerCreateAccountVC.delegate = self
                    customerCreateAccountVC.mobileNo = self.mobileNumber ?? ""
                    let nav = UINavigationController(rootViewController: customerCreateAccountVC)
                    nav.modalPresentationStyle = .fullScreen
                    //nav.navigationBar.tintColor = AppStaticColors.accentColor
                    self.present(nav, animated: true, completion: nil)
                } else {
                    var dict = [String: Any]()
                    dict["username"] = ""
                    dict["password"] = ""
                    dict["mobile"] = self.mobileNumber
                    dict["token"] = Defaults.deviceToken
                    self.viewModel.isMobile = true
                   self.callRequest(dict: dict, apiCall: .login)
                }
//                    let customerCreateAccountVC = CreateAnAccountViewController.instantiate(fromAppStoryboard: .customer)
//                    //customerCreateAccountVC.delegate = self
//                    customerCreateAccountVC.mobileNo = self.mobileNumber+(self.mobileNoTf.text ?? "")
//                    let nav = UINavigationController(rootViewController: customerCreateAccountVC)
//                    nav.modalPresentationStyle = .fullScreen
//                    //nav.navigationBar.tintColor = AppStaticColors.accentColor
//                    self.present(nav, animated: true, completion: nil)
               
                
                
            } else {
                self.submitCodeButton.isEnabled = false
                self.submitCodeButton.alpha = 0.3
                self.otpStackView.setAllFieldColor(isWarningColor: true, color: .red)
            }
           
        }
    }

    // MARK: - Api login action
    func callRequest(dict: [String: Any], apiCall: WhichApiCall) {
        viewModel.callingHttppApi(dict: dict, apiCall: apiCall) { [weak self] success in
            NetworkManager.sharedInstance.dismissLoader()
            guard self != nil else { return }
            if success {
                if apiCall == .login {
                    ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: "Login Successfully".localized)
                    self?.calltouch()
                }
            } else {
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
//                                Defaults.touchEmail = self?.emailTextField.text ?? ""
//                                Defaults.touchPassword = self?.passwordTextField.text ?? ""
                                
                                LaunchHome.shared.launchHomeTabbar()
                            } else {
                                Defaults.touchFlag = "0"
                                LaunchHome.shared.launchHomeTabbar()
                            }
                        })
                    } else {
                        Defaults.touchFlag = "0"
                        LaunchHome.shared.launchHomeTabbar()
                    }
                }
            } else if Defaults.touchFlag == "1" {
                touchID.askForLocalAuthentication(message: "wouldyouliketoreset".localized) { [weak self] in
                    if $0 {
                        self?.touchID.checkUserAuthentication(taskCallback: { (sucess) in
                            if sucess{
                                Defaults.touchFlag = "1"
//                                Defaults.touchEmail = self?.emailTextField.text ?? ""
//                                Defaults.touchPassword = self?.passwordTextField.text ?? ""
                                LaunchHome.shared.launchHomeTabbar()
                            }else{
                                Defaults.touchFlag = "0"
                                LaunchHome.shared.launchHomeTabbar()
                            }
                        })
                    } else {
                        Defaults.touchFlag = "0"
                        LaunchHome.shared.launchHomeTabbar()
                    }
                }
            } else {
                self.delegate?.loginPop()
            }
        } else {
            LaunchHome.shared.launchHomeTabbar()
        }
    }
}


extension OTPViewController: OTPDelegate {
    
    func didChangeValidity(isValid: Bool) {
        submitCodeButton.isEnabled = isValid
        submitCodeButton.alpha = isValid ? 1.0 : 0.3
    }
    
}


extension OTPViewController {

    func callingHttppApi(dict: [String: Any], apiCall: WhichApiCall, completion: @escaping (Bool) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        
        var requstParams = [String: Any]()
        requstParams["storeId"] = Defaults.storeId
        if apiCall == .sendOTP {
            apiName = .sendOTP
            requstParams["mobile"] = dict["mobile"]
            requstParams["type"]  = isFromSignUp ? "register" : "login"
            
        } else if apiCall == .VerifyOTP{
            apiName = .VerifyOTP
            requstParams["mobile"] = dict["mobile"]
            requstParams["otp"] = dict["otp"]
            requstParams["type"]  = isFromSignUp ? "register" : "login"
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
