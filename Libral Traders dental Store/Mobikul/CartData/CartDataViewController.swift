import UIKit
import Firebase

class CartDataViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var bottomClicked: UIView!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountToBePaid: UILabel!
    @IBOutlet weak var crossBtn: UIBarButtonItem!
    @IBOutlet weak var wishlistBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var cartViewModalObject: CartViewModel?
    var emptyView: EmptyView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomClicked.addShadow(location: .top)
        wishlistBtn.title = "Go to wishlist".localized
        cartViewModalObject = CartViewModel()
        cartViewModalObject?.priceLabel = self.priceLabel
        cartViewModalObject?.cartController = self
        cartViewModalObject?.tableView = tableView
        self.navigationItem.title = "Cart".localized
        tableView.register(cellType: CartActionTableViewCell.self)
        tableView.register(cellType: CartProductTableViewCell.self)
        tableView.register(cellType: CartVoucherTableViewCell.self)
        tableView.register(cellType: CartPriceTableViewCell.self)
        tableView.register(cellType: RelatedProductTableViewCell.self)
        tableView.tableFooterView = UIView()
        proceedBtn.setTitle("Proceed".localized, for: .normal)
        amountToBePaid.text = "Amount to be paid".localized
        bottomClicked.isHidden = true
        self.theme()

        // Do any additional setup after loading the view.
    }
    
    
    func theme() {
                if #available(iOS 12.0, *) {
                    if self.traitCollection.userInterfaceStyle == .dark {
        //                proceedBtn.backgroundColor = UIColor.white
        //                proceedBtn.setTitleColor(UIColor.black, for: .normal)
                        proceedBtn.backgroundColor = AppStaticColors.darkButtonBackGroundColor
                        proceedBtn.setTitleColor(AppStaticColors.darkButtonTextColor, for: .normal)
                        crossBtn.tintColor = AppStaticColors.darkItemTintColor
                        wishlistBtn.tintColor = AppStaticColors.darkItemTintColor
                        UINavigationBar.appearance().barTintColor = AppStaticColors.darkPrimaryColor
                        self.navigationController?.navigationBar.barTintColor = AppStaticColors.darkPrimaryColor
                        self.navigationController?.navigationBar.tintColor = AppStaticColors.darkItemTintColor
                        UINavigationBar.appearance().tintColor = AppStaticColors.darkItemTintColor
                        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.darkItemTintColor]
                        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.darkItemTintColor]
                           


                    } else {
                        proceedBtn.backgroundColor = AppStaticColors.buttonBackGroundColor
                        proceedBtn.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
                        crossBtn.tintColor = AppStaticColors.itemTintColor
                        wishlistBtn.tintColor = AppStaticColors.itemTintColor
                        UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
                        self.navigationController?.navigationBar.barTintColor = AppStaticColors.primaryColor
                        self.navigationController?.navigationBar.tintColor = AppStaticColors.itemTintColor
                        UINavigationBar.appearance().tintColor = AppStaticColors.itemTintColor
                        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
                        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
                    }
                } else {
                    crossBtn.tintColor = AppStaticColors.itemTintColor
                    wishlistBtn.tintColor = AppStaticColors.itemTintColor

                    proceedBtn.backgroundColor = AppStaticColors.buttonBackGroundColor
                    proceedBtn.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
                    UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
                     self.navigationController?.navigationBar.barTintColor = AppStaticColors.primaryColor
                     self.navigationController?.navigationBar.tintColor = AppStaticColors.itemTintColor
                     UINavigationBar.appearance().tintColor = AppStaticColors.itemTintColor
                     self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
                     UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
                }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.cartViewModalObject?.whichApiCall = .getCartData
        self.callRequest()
        if emptyView == nil {
            emptyView = EmptyView(frame: self.view.frame)
            self.view.addSubview(emptyView)
            emptyView.isHidden = true
            emptyView.emptyImages.addSubview(LottieHandler.sharedInstance.initializeLottie(bounds: emptyView.emptyImages.bounds, fileName: "CartFile"))
            //            emptyView.emptyImages.image = UIImage(named: "illustration-bag")
            emptyView.actionBtn.setTitle("Start Shopping".localized, for: .normal)
            emptyView.labelMessage.text = "You have no items in your cart.".localized
            emptyView.titleText.text = "Empty Cart".localized
            emptyView.actionBtn.addTapGestureRecognizer {
                self.emptyClicked()
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        DispatchQueue.main.async {
            self.theme()
            self.tableView.reloadData()
        }
    }

       override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
           // Trait collection will change. Use this one so you know what the state is changing to.
       }
    
    
    func emptyClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func crossClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func wishlistClicked(_ sender: Any) {
        if Defaults.customerToken == nil {
            let customerLoginVC = LoginViewController.instantiate(fromAppStoryboard: .customer)
            let nav = UINavigationController(rootViewController: customerLoginVC)
            nav.modalPresentationStyle = .fullScreen
            //nav.navigationBar.tintColor = AppStaticColors.accentColor
            self.present(nav, animated: true, completion: nil)
        } else {
            let viewController = WishlistDataViewController.instantiate(fromAppStoryboard: .main)
            self.navigationController?.pushViewController(viewController, animated: true)
            
        }
    }
    
    @IBAction func proceedClicked(_ sender: Any) {
        
        guard let cartModel =  cartViewModalObject?.cartModel else {
            return
        }
        
        if  cartModel.minimumAmount > cartModel.unformattedCartTotal {
            ShowNotificationMessages.sharedInstance.warningView(message: cartModel.descriptionMessage)
        } else if  !cartModel.isCheckoutAllowed {
            ShowNotificationMessages.sharedInstance.warningView(message: "You are not allowed to checkout".localized)
        } else  {
            if Defaults.customerToken != nil {
                let viewController = CheckoutDataViewController.instantiate(fromAppStoryboard: .checkout)
                let nav = UINavigationController(rootViewController: viewController)
                //nav.navigationBar.tintColor = AppStaticColors.accentColor
                viewController.isVirtual = self.cartViewModalObject?.cartModel.isVirtual
                nav.modalPresentationStyle = .fullScreen
                
                //MARK:- BEGIN_CHECKOUT Analytics

                Analytics.setScreenName("Cart", screenClass: "CartDataViewController.class")
                Analytics.logEvent("BEGIN_CHECKOUT", parameters: ["id":Defaults.customerToken ?? ""])
                self.present(nav, animated: true, completion: nil)
            } else {
                Analytics.setScreenName("Cart", screenClass: "CartDataViewController.class")
                Analytics.logEvent("BEGIN_CHECKOUT", parameters: ["id":"Guset"])

                self.showAlert()
            }
        }
        
    }
    
    func callRequest() {
        cartViewModalObject?.callingHttppApi { [weak self] success,_  in
            guard let self = self else { return }
            if success {
                self.priceLabel.text = self.cartViewModalObject?.cartModel.cartTotal
            } else {
                
            }
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
    
    func showAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takeAction = UIAlertAction(title: "Checkout as new Customer".localized, style: .default, handler: new)
        let upload = UIAlertAction(title: "Checkout as existing Customer".localized, style: .default, handler: existing)
        let socialLogin = UIAlertAction(title: "Checkout as Social Login".localized, style: .default, handler: existingSocialLogin)
        let guestAction = UIAlertAction(title: "Checkout as guest Customer".localized, style: .default, handler: guest)
        let CancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: cancel)
        
        alert.addAction(takeAction)
        alert.addAction(upload)
       // alert.addAction(socialLogin)
        if let cartModel =  cartViewModalObject?.cartModel, cartModel.isAllowedGuestCheckout  {
            alert.addAction(guestAction)
        }
        
        alert.addAction(CancelAction)
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x:self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height - 60, width : 1.0, height : 1.0)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func new(alertAction: UIAlertAction!) {
        let customerCreateAccountVC = CreateAnAccountViewController.instantiate(fromAppStoryboard: .customer)
        let nav = UINavigationController(rootViewController: customerCreateAccountVC)
        //nav.navigationBar.tintColor = AppStaticColors.accentColor
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    func existing(alertAction: UIAlertAction!) {
        LaunchHome.needAppRefresh = false
        let customerLoginVC = LoginViewController.instantiate(fromAppStoryboard: .customer)
        let nav = UINavigationController(rootViewController: customerLoginVC)
        //nav.navigationBar.tintColor = AppStaticColors.accentColor
        self.present(nav, animated: true, completion: nil)
    }
    
    func existingSocialLogin(alertAction: UIAlertAction!) {
        LaunchHome.needAppRefresh = false
        let customerLoginVC = SocialLoginViewController.instantiate(fromAppStoryboard: .customer)
        let nav = UINavigationController(rootViewController: customerLoginVC)
        //nav.navigationBar.tintColor = AppStaticColors.accentColor
        self.navigationController?.pushViewController(customerLoginVC, animated: false)
    }
    
    func cancel(alertAction: UIAlertAction!) {
        
    }
    
    func guest(alertAction: UIAlertAction!) {
        let viewController = CheckoutDataViewController.instantiate(fromAppStoryboard: .checkout)
        let nav = UINavigationController(rootViewController: viewController)
        //nav.navigationBar.tintColor = AppStaticColors.accentColor
        viewController.isVirtual = self.cartViewModalObject?.cartModel.isVirtual
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    func localCartNotification() {
  

        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        }
        
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = "Cart notification".localized
        content.title = "Your Cart Misses You!".localized
        content.body = "You have products waiting in your cart to checkout. Running out of stock! Hurry!".localized
        content.badge = 0;
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 7200, repeats: false);
        let uuidString = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: "cartLocalNotification", content: content, trigger: trigger)
        center.add(request) { (error) in
            // for error
        }

        let likeaction = UNNotificationAction.init(identifier: "View", title: "View".localized, options: UNNotificationActionOptions.foreground)
        let deleteaction = UNNotificationAction.init(identifier: "Delete", title: "Delete".localized, options: .destructive)
        let category = UNNotificationCategory.init(identifier: content.categoryIdentifier, actions: [likeaction,deleteaction], intentIdentifiers: [], options: []);
        center.setNotificationCategories([category])
        
        center.add(request) { (error) in
            // for error
        }

    }
    
}
