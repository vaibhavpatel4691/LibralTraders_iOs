import UIKit
import Firebase

import Razorpay

class CheckoutDataViewController: UIViewController {
    weak var checkoutOrderReviewObject: CheckoutOrderReviewViewController?
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    var razorpay: RazorpayCheckout!
    var paymentId: String!
    var shippingParams = [String: Any]()
    var confirm = [String:Any]()
    var response =  [String:Any]()
    var responseParams = [String: Any]()
    var shippingId: String!
    var isVirtual: Bool! = false
    var incrementId = ""
    var orderID = ""
    var razorSuccess = false
    var whichAPI = ""
    var state: String!
    var razorpayPaymentID = ""
    var razorpayResponseMessage = ""
    var razorpayResponseCode = ""
    var orderPlaceData:JSON!
    var razorpayObj : RazorpayCheckout? = nil
    var isErrorAlertShown:Bool = false
    //var merchantDetails : MerchantsDetails = MerchantsDetails.getDefaultData()
    
    var razorpayKey = ""
    @IBOutlet weak var checkoutScrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.image = backBtn.image?.withRenderingMode(.alwaysTemplate).flipImage()
//        backBtn.tintColor = AppStaticColors.itemTintColor
        self.theme()

        if UIDevice().hasNotch {
            containerViewHeight.constant = AppDimensions.screenHeight - 122
        } else {
            containerViewHeight.constant = AppDimensions.screenHeight - 64
        }
        // Do any additional setup after loading the view.
    }
    
    
    func theme() {
        if #available(iOS 13.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                  backBtn.tintColor = AppStaticColors.darkItemTintColor

            } else {
                backBtn.tintColor = AppStaticColors.itemTintColor

            }
        } else {
            backBtn.tintColor = AppStaticColors.itemTintColor
        }

    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            self.theme()
       }

          override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
              // Trait collection will change. Use this one so you know what the state is changing to.
          }

    override func viewDidAppear(_ animated: Bool) {
        self.checkoutScrollView.contentSize = CGSize(width: 2*AppDimensions.screenWidth, height: self.view.frame.height)
        self.checkoutScrollView.isPagingEnabled = true
        self.checkoutScrollView.isScrollEnabled = false
        if isVirtual {
            self.checkoutScrollView.contentOffset = CGPoint(x: AppDimensions.screenWidth, y: self.checkoutScrollView.contentOffset.y)
            self.navigationItem.title = "Review and Payment".localized
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.destination)
        if let destinationVC = segue.destination as? CheckoutAddressAndShippingViewController {
            destinationVC.view.frame = self.view.frame
            destinationVC.view.layoutIfNeeded()
            self.navigationItem.title = "Shipping".localized
            if !isVirtual {
                destinationVC.hitRequest()
            } else {
                self.navigationItem.title = ""
            }
            destinationVC.completionBlock = { [weak self] (shippingId, shippingDict, address) in
                guard let self = self else { return }
                self.navigationItem.title = "Review and Payment".localized
                self.shippingId = shippingId
                self.checkoutScrollView.contentOffset = CGPoint(x: AppDimensions.screenWidth, y: self.checkoutScrollView.contentOffset.y)
                if let checkoutOrderReviewObject = self.checkoutOrderReviewObject {
                    checkoutOrderReviewObject.shippingId = shippingId
                    checkoutOrderReviewObject.address = address
                    self.shippingParams = shippingDict
                    checkoutOrderReviewObject.callRequest()
                }
            }
        }
        
        if let destinationVC = segue.destination as? CheckoutOrderReviewViewController {
            destinationVC.isVirtual = self.isVirtual
            
            checkoutOrderReviewObject = destinationVC

            if isVirtual {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.checkoutOrderReviewObject?.callRequest()
                }
            }
            destinationVC.completionBlock = { [weak self] (paymentDetails, billingAvailable, billingDict)  in
                guard let self = self else { return }
                print(paymentDetails)
                self.razorpayKey = self.checkoutOrderReviewObject?.viewModel.model.razorpaydData?.razorpay_keyId ?? ""
                print(self.razorpayKey)
                self.paymentId = paymentDetails.code
                if billingAvailable {
                    self.shippingParams = billingDict
                }
                self.callRequest()
            }
        }
    }
    @IBAction func backClicked(_ sender: Any) {
        if self.checkoutScrollView.contentOffset.x == AppDimensions.screenWidth && !isVirtual {
            self.checkoutScrollView.contentOffset = CGPoint(x: 0, y: self.checkoutScrollView.contentOffset.y)
            self.navigationItem.title = "Shipping".localized
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func callRequest() {
        self.callingHttppApi { [weak self] success in
            guard let self = self else { return }
            if success {
            } else {
                
            }
        }
    }
}

extension CheckoutDataViewController {
    func callingHttppApi(completion: @escaping (Bool) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        requstParams["storeId"] = Defaults.storeId
        requstParams["width"] = UrlParams.width
        requstParams["quoteId"] = Defaults.quoteId
        var apiname = WhichApiCall.placeOrder
        
        if Defaults.customerToken != nil {
            requstParams["method"] = "customer"
        } else {
            requstParams["method"] = "guest"
        }
        if whichAPI == "changerazorpayorderstatus"{
            apiname = WhichApiCall.changerazorpayorderstatus
            requstParams["status"] = razorSuccess ? "0" :"1"
            requstParams["incrementId"] = self.incrementId
            requstParams["transactionId"] = razorpayPaymentID
            requstParams["state"] = state
        }else{
            if paymentId == "razorpay"{
                requstParams["isRazorpayPayment"] = "1"
            }
        }
        requstParams["purchasePoint"] = "ios"
        requstParams["websiteId"] = UrlParams.defaultWebsiteId
        requstParams["paymentMethod"] = paymentId
        requstParams["shippingMethod"] = shippingId
        requstParams["billingData"] = shippingParams.convertDictionaryToString()
        requstParams["customerToken"] = Defaults.customerToken
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .post, apiname: apiname, currentView: UIViewController()) { [weak self] success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            if success == 1 {
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                print(jsonResponse)
                if jsonResponse["success"].boolValue == true {
                    Defaults.quoteId = ""
                    
                    self?.doFurtherProcessingWithResult(data: jsonResponse) { success in
                        completion(success)
                    }
                } else {
                    if jsonResponse["message"].stringValue.removeWhiteSpace.count > 0 {
                        ShowNotificationMessages.sharedInstance.warningView(message: jsonResponse["message"].stringValue)
                    } else {
                        ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
                    }
                }
            } else if success == 2 {   // Retry in case of error
                NetworkManager.sharedInstance.dismissLoader()
                self?.callingHttppApi {success in
                    completion(success)
                }
            }
        }
    }
    
    func doFurtherProcessingWithResult(data: JSON, completion: (Bool) -> Void) {
        //MARK:- ECOMMERCE_PURCHASE Analytics
        
        Analytics.setScreenName("Checkout", screenClass: "CheckoutDataViewController.class")
        Analytics.logEvent("ECOMMERCE_PURCHASE", parameters: ["orderid":data["incrementId"].stringValue])
        if whichAPI == "changerazorpayorderstatus"{
            if razorSuccess{
                let viewController = OrderPlaceViewController.instantiate(fromAppStoryboard: .checkout)
                viewController.orderId = orderPlaceData["incrementId"].stringValue
                if data["showCreateAccountLink"].boolValue {
                    viewController.email = orderPlaceData["email"].stringValue
                    if orderPlaceData["customerDetails"] != JSON.null {
                        viewController.customerDetails = AccountInformationModel(json: orderPlaceData["customerDetails"])
                    }
                }
                
                viewController.callBack = { [weak self] () in
                    self?.dismiss(animated: true, completion: nil)
                }
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)
                completion(true)
            }else{
                if !isErrorAlertShown{
                    dismiss(animated: true, completion: nil)

                }
            }
        }else{
            orderPlaceData = data
            if paymentId == "razorpay"{
                razorpay = RazorpayCheckout.initWithKey(self.checkoutOrderReviewObject?.viewModel.model.razorpaydData?.razorpay_keyId ?? "", andDelegate: self)
                self.incrementId = data["incrementId"].stringValue
               
                showPaymentForm(data: data)
            }else{
                let viewController = OrderPlaceViewController.instantiate(fromAppStoryboard: .checkout)
                viewController.orderId = data["incrementId"].stringValue
                if data["showCreateAccountLink"].boolValue {
                    viewController.email = data["email"].stringValue
                    if data["customerDetails"] != JSON.null {
                        viewController.customerDetails = AccountInformationModel(json: data["customerDetails"])
                    }
                }
                
                viewController.callBack = { [weak self] () in
                    self?.dismiss(animated: true, completion: nil)
                }
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)
                completion(true)            }
            
        }
    }
    
    
    
}

extension CheckoutDataViewController:  RazorpayPaymentCompletionProtocol  {
    
    
    func showPaymentForm(data: JSON) {
        razorpayObj = RazorpayCheckout.initWithKey(razorpayKey, andDelegate: self)
        razorpayPaymentID = ""
     
            let options: [AnyHashable:Any] = [
                "amount": self.checkoutOrderReviewObject?.viewModel.model.razorpaydData?.amount ?? "",
                "currency": Defaults.currency ?? "",//We support more that 92 international currencies.
                "description": self.checkoutOrderReviewObject?.viewModel.model.razorpaydData?.razorpay_title ?? "",
                "order_id": self.checkoutOrderReviewObject?.viewModel.model.razorpaydData?.razorpay_order_id ?? "",
                "image": "",
                "name": self.checkoutOrderReviewObject?.viewModel.model.razorpaydData?.razorpay_merchantName ?? "",
                "prefill": [
                    "contact": self.checkoutOrderReviewObject?.viewModel.model.razorpaydData?.customer_phone_number,
                    "email": self.checkoutOrderReviewObject?.viewModel.model.razorpaydData?.customer_email
                ],
                "theme": [
                    "color": "#364e9e"
                ]
            ]
               
               razorpayObj?.open(options, displayController: self)


        
        razorpayObj?.open(options, displayController: self)
        
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        print("success",payment_id)
        razorpayPaymentID = payment_id;
        razorSuccess = true;
        whichAPI = "changerazorpayorderstatus"
        razorpayResponseCode = ""
        state = "Successful";
        callRequest()
    }
    
    func onPaymentError( _ code: Int32, description : String) {
        print("failure", code, description)
        razorSuccess = false

        whichAPI = "changerazorpayorderstatus"
        razorpayResponseMessage = description
        razorpayResponseCode = String(format:"%d", code);
        state = "Failed";
        callRequest()
        let AC = UIAlertController(title:  "warning".localized, message: "Your Payment is not Confirmed !".localized, preferredStyle: .alert)
        
        let okBtn = UIAlertAction(title: "Ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
        })
        isErrorAlertShown = true
        AC.addAction(okBtn)
        self.present(AC, animated: true, completion: nil)
    }
    
    
    
}
