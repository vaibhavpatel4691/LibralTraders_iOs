//
//  MObileLoginViewController.swift
//  Libral Traders
//
//  Created by khushboo on 31/03/23.
//

import UIKit

class MobileLoginViewController: UIViewController {
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var dropDownView: UIImageView!
    @IBOutlet weak var countryCodeLbl: UILabel!
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var sendOtpBtn: UIButton!
    @IBOutlet weak var btnOutlet: UIButton!
    @IBOutlet weak var mobileDescripLabel: UILabel!
    @IBOutlet weak var mobileNoTf: UITextField!
    @IBOutlet weak var coutryCodeView: UIView!
    weak var delegate: LoginPop?
    
    @IBOutlet weak var verifyOtpTf: UITextField!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var verifyView: UIView!
    @IBOutlet weak var loginLbl: UILabel!
    @IBOutlet weak var AccountLbl: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var label4: UILabel!
    var countryData = [GetCountryData]()
    let transparentView = UIView()
    var counter = 120
    var timer = Timer()
    var mobileNumber = ""
     var countryCode = ""
     var isMobileNumber: Bool = false
     var otpValue = ""
    private var apiName: WhichApiCall = .sendOTP
    let tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let index = countryData.firstIndex(where: {$0.country_code == "in"}) {
            countryImage.setImage(fromURL: countryData[index].image)
            countryCodeLbl.text =  countryData[index].dial_code
        }
            
        mobileNoTf.delegate = self
        btnOutlet.setTitle("", for: .normal)
        tableView.delegate = self
        tableView.dataSource = self
        verifyView.shadowBorder()
        tableView.register(cellType: CountryTableViewCell.self)
        verifyView.isHidden = true
        backBtn.image = UIImage(named: "backArrow")
        loginLbl.addTapGestureRecognizer {
            let customerLoginVC = LoginViewController.instantiate(fromAppStoryboard: .customer)
            let nav = UINavigationController(rootViewController: customerLoginVC)
            customerLoginVC.countryData = self.countryData
            //nav.navigationBar.tintColor = AppStaticColors.accentColor
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnTap(_ sender: Any) {
        addTransparentView(frames: btnOutlet.frame)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func sendOtpClick(_ sender: Any) {
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
                    self.verifyView.isHidden = false*/
                 //   self.verifyOtpTf.text =  self.otpValue
                    //self..constant = 312
                   // self.bottomViewHeightCons.constant = 150
                    let otpViewController = OTPViewController.instantiate(fromAppStoryboard: .customer)
                    // customerCreateAccountVC.parentController = "signIn"
                    // customerCreateAccountVC.delegate = delegate
                    mobileNumber = self.countryCodeLbl.text ?? ""
                    otpViewController.mobileNumber = mobileNumber+(self.mobileNoTf.text ?? "")
                    otpViewController.isFromSignUp = true
                    self.navigationController?.pushViewController(otpViewController, animated: true)
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
                    let customerCreateAccountVC = CreateAnAccountViewController.instantiate(fromAppStoryboard: .customer)
                    //customerCreateAccountVC.delegate = self
                    customerCreateAccountVC.mobileNo = self.mobileNumber+(self.mobileNoTf.text ?? "")
                    let nav = UINavigationController(rootViewController: customerCreateAccountVC)
                    nav.modalPresentationStyle = .fullScreen
                    //nav.navigationBar.tintColor = AppStaticColors.accentColor
                    self.present(nav, animated: true, completion: nil)
                    
                }
               
            }

          
        }
      
    }
}
extension MobileLoginViewController {
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
extension MobileLoginViewController: UITableViewDelegate, UITableViewDataSource {
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


extension MobileLoginViewController {

    func callingHttppApi(dict: [String: Any], apiCall: WhichApiCall, completion: @escaping (Bool) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        
        var requstParams = [String: Any]()
        requstParams["storeId"] = Defaults.storeId
        if apiCall == .sendOTP {
            apiName = .sendOTP
            requstParams["mobile"] = dict["mobile"]
            requstParams["type"]  = "register"
            
        } else if apiCall == .VerifyOTP{
            apiName = .VerifyOTP
            requstParams["mobile"] = dict["mobile"]
            requstParams["otp"] = dict["otp"]
            requstParams["type"]  = "register"
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
                 //   self.otpValue = data["otp"].stringValue
                   
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
extension MobileLoginViewController: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        self.mobileDescripLabel.textColor = .red
//        if textField.text?.count ?? 1 < 7 {
//
//            self.mobileDescripLabel.text = "Please Enter at least 7 charachters."
//            self.sendOtpBtn.isUserInteractionEnabled = false
//        }else if textField.text?.count ?? 1 > 9 {
//            self.mobileDescripLabel.text = "Please Enter less or equal than 10 symbole."
//            self.sendOtpBtn.isUserInteractionEnabled = false
//        }else{
//            self.mobileDescripLabel.text = ""
//            self.sendOtpBtn.isUserInteractionEnabled = true
//        }
//        return true
//    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.mobileDescripLabel.textColor = .red
        if textField.text?.count ?? 1 < 7 {
          
            self.mobileDescripLabel.text = "Please Enter at least 7 charachters."
            self.sendOtpBtn.isUserInteractionEnabled = false
        }else if textField.text?.count ?? 1 > 10 {
            self.mobileDescripLabel.text = "Please Enter less or equal than 10 symbol."
            self.sendOtpBtn.isUserInteractionEnabled = false
        }else{
            self.mobileDescripLabel.text = ""
            self.sendOtpBtn.isUserInteractionEnabled = true
        }
    }
}
