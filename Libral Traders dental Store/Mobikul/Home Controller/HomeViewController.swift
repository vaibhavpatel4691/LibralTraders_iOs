//

/*
 Mobikul_Magento2V3_App
 @Category Webkul
 @author Webkul
 FileName: ViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html
 */

import UIKit
import RealmSwift
import CoreLocation
import FirebaseAnalytics
class ViewController: UIViewController, UIScrollViewDelegate {
    var homeViewModel: HomeViewModel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBackgroundView: UIView!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var cartBtn: BadgeBarButtonItem!
    @IBOutlet weak var notificationBtn: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var tableviewHeight: NSLayoutConstraint!
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var refreshingView: UIView!
    @IBOutlet weak var refreshLbl: UILabel!
    @IBOutlet weak var hyperlocalViewHeight: NSLayoutConstraint!
    @IBOutlet weak var hyperlocalView: UIView!
    @IBOutlet weak var userAddress: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    let icons = ["Icon1", "Icon1", "Icon2", "Icon3", "Icon4","Icon5"]
    
    var refreshControl: UIRefreshControl!
    let defaults = UserDefaults.standard
    var locationManager: CLLocationManager?
    
    var homeJsonData: JSON = ""
    var historyToolBarView: BottomMoveToTopTableView?
    var checkFotter = false
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if #available(iOS 16.0, *) {
            searchButton.isHidden = true
        } else {
            // Fallback on earlier versions
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushNotificationReceivedCartClick), name: NSNotification.Name(rawValue: "pushNotificationReceivedCartClick"), object: nil)
        
        if localNotificationTapCheck {
            localNotificationTapCheck = false
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationReceivedCartClick"), object: nil, userInfo: nil)
        }
        UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
        self.navigationController?.navigationBar.barTintColor = AppStaticColors.primaryColor
        self.searchBackgroundView.backgroundColor = UIColor().hexToColor(hexString: "bdf977")
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.textColor = UIColor.white
            searchTextField.backgroundColor = UIColor.white //.withAlphaComponent(0.3) // Set background color if needed
            searchTextField.tintColor = UIColor.white // Set cursor color
        }
        self.setView()
        Analytics.setScreenName("HomePage", screenClass: "HomeViewController.class")
        homeViewModel = HomeViewModel()
        self.homeViewModel.homeViewController = self
        self.appNavigationTheme()
        self.addLogoToNavigationBarItem()
        refreshingView.layer.cornerRadius = 5
        refreshingView.layer.masksToBounds = true
        refreshLbl.text = "Refreshing...".localized
        homeTableView.register(cellType: TopCategoryTableViewCell.self)
        homeTableView.register(cellType: BannerTableViewCell.self)
        homeTableView.register(cellType: ImageCarouselTableViewCell.self)
        homeTableView.register(cellType: ProductTableViewCell.self)
        homeTableView.register(cellType: ProductTableViewCellLayout2.self)
        homeTableView.register(cellType: ProductTableViewCellLayout3.self)
        homeTableView.register(cellType: ProductTableViewCellLayout4.self)
        homeTableView.register(cellType: RecentHorizontalTableViewCell.self)
        homeTableView.register(cellType: SliderTableViewCell.self)
        self.setupTableFooterView()
        homeViewModel.homeTableView = homeTableView
        self.homeTableView?.dataSource = homeViewModel
        self.homeTableView?.delegate = homeViewModel
        homeViewModel.moveDelegate = self
        if Defaults.searchEnable == nil {
            Defaults.searchEnable = "1"
        }
        
        homeTableView.rowHeight = UITableView.automaticDimension
        self.homeTableView.estimatedRowHeight = 100
        self.homeTableView.separatorColor = UIColor.clear
        
        //self.navigationItem.title = applicationName
        
        //add refresh control to tableview
        refreshControl = UIRefreshControl()
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let attributedTitle = NSAttributedString(string: "Refreshing...".localized, attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            homeTableView.refreshControl = refreshControl
        } else {
            homeTableView.backgroundView = refreshControl
        }
        //self.setupTableFooterView()
        self.tabBarController?.tabBar.items?[0].title = "Home".localized
        self.tabBarController?.tabBar.items?[1].title = "Categories".localized
        self.tabBarController?.tabBar.items?[2].title = "Order again".localized
        self.tabBarController?.tabBar.items?[3].title = "Account".localized
        self.tabBarController?.tabBar.items?[4].title = "More".localized
        self.registerToReceiveNotification()
        if (homeJsonData != "") {
            self.homeViewModel.getData(jsonData: homeJsonData, recentViewData: self.getProductDataFromDB()) {(data: Bool) in
                if data {
                    self.processDataForHomeController()
                    self.appNavigationTheme()
                    addLogoToNavigationBarItem()
                }
            }
        } else {   // No Changes
            let data =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "homedata"))
            if let products = self.getProductDataFromDB() {
                if data  != "" {
                    self.homeViewModel.getDataFromDB(data: data, recentViewData: products, completion: { (data: Bool) in
                        if data {
                            self.processDataForHomeController()
                            self.appNavigationTheme()
                            addLogoToNavigationBarItem()
                        }
                    })
                }
            }
        }
        DispatchQueue.main.async {
            self.locationManager = CLLocationManager()
            self.fetchLocation()
        }
        self.setupRefreshHome()
        if LaunchHome.needAppRefresh {
            self.refreshingView.isHidden = false
            //self.callingHttppApi(showLoader: false)
            self.refreshHomePageData()
            self.appNavigationTheme()
            addLogoToNavigationBarItem()
        }
        
        if let tabbar = self.parent?.parent {
            print(tabbar)
            tabbar.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
        self.navigationController?.navigationBar.draw(CGRect(x: 0, y: 0, width: 30, height: 30))
        self.navigationItem.rightBarButtonItem?.customView?.frame.size.width = 30
        self.initHyperLocalView()
    }
    
    func setView() {
        if Defaults.language == "ar" {
            L102Language.setAppleLAnguageTo(lang: "ar")
            if #available(iOS 9.0, *) {
                UINavigationBar.appearance().semanticContentAttribute = .forceRightToLeft
                UITabBar.appearance().semanticContentAttribute = .forceRightToLeft
                
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
                
            } else {
                // Fallback on earlier versions
            }
            
        } else {
            
            L102Language.setAppleLAnguageTo(lang: "en")
            if #available(iOS 9.0, *) {
                UINavigationBar.appearance().semanticContentAttribute = .forceLeftToRight
                UITabBar.appearance().semanticContentAttribute =  .forceLeftToRight
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
                
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        callingHttppApi()
    }
    
    @IBAction func changeButtonClick(_ sender: UIButton) {
#if HYPERLOCAL
        let viewController = AddressSuggestionController.instantiate(fromAppStoryboard: .hyperlocal)
        let navController = UINavigationController(rootViewController: viewController)
        self.present(navController, animated: true)
#endif
        
    }
    
    func addLogoToNavigationBarItem() {
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                titleImage.setImageHomeLogo(fromURL: homeViewModel.applogo)
                //self.navigationItem.titleView?.backgroundColor = UIColor.clear
                
                self.navigationItem.titleView = customTitleView(titleImage.image!)
                // self.navigationController?.navigationItem.titleView?.backgroundColor = AppStaticColors.darkPrimaryColor
                //print(titleImage, homeViewModel.darkApplogo, self.navigationItem.titleView, "ghgg")
            } else {
                titleImage.setImageHomeLogo(fromURL: homeViewModel.applogo)
                self.navigationItem.titleView?.backgroundColor = UIColor.clear
                self.navigationItem.titleView = customTitleView(titleImage.image!)
                self.navigationController?.navigationItem.titleView?.backgroundColor = AppStaticColors.primaryColor
                
            }
        } else {
            titleImage.setImageHomeLogo(fromURL: homeViewModel.applogo)
            self.navigationItem.titleView?.backgroundColor = UIColor.clear
            self.navigationItem.titleView = customTitleView(titleImage.image!)
            self.navigationController?.navigationItem.titleView?.backgroundColor = AppStaticColors.primaryColor
        }
        
        
    }

    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if UIApplication.shared.applicationState != .background {
            
        }
        DispatchQueue.main.async {
            self.addLogoToNavigationBarItem()
            self.appNavigationTheme()
            self.homeTableView.reloadData()
        }
        
        
    }
   /* private func customTitleView(_ imageView: UIImage) -> UIView {
           let backView = UIView(frame: CGRect(x: 0, y: 0, width: AppDimensions.screenWidth - 90, height: 40))
           let img = UIImageView(frame: CGRect(x: 0, y: 0, width: backView.frame.width, height: backView.frame.height))
           img.image = imageView
           img.contentMode = .scaleAspectFit
           img.transform = CGAffineTransform(translationX: -(img.frame.width / 4), y: 0)
           backView.addSubview(img)
           return backView
       }*/
    
    private func customTitleView(_ imageView: UIImage) -> UIView {
            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
            let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height))
            logoImageView.image = imageView
            logoImageView.contentMode = .scaleAspectFit
            containerView.addSubview(logoImageView)
            return containerView
        }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        // Trait collection will change. Use this one so you know what the state is changing to.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        appNavigationTheme()
        cartBtn.badgeNumber = Int(Defaults.cartBadge) ?? 0
        self.tabBarController?.tabBar.isHidden = false
#if HYPERLOCAL
        if Defaults.latitude == "" {
            Defaults.latitude = "28.629687"
            Defaults.langitude = "77.378179"
            Defaults.placeName = "H-28, ARV Park, Sector 63, Noida, Uttar Pradesh 201301 (India)"
            Defaults.city = "Noida"
            Defaults.state = "Uttar Pradesh"
            Defaults.country = "India"
            initHyperLocalView()
        }
#endif
    }
    func appNavigationTheme() {
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                self.navigationItem.leftBarButtonItem?.tintColor = AppStaticColors.darkItemTintColor
                self.navigationItem.rightBarButtonItem?.tintColor = AppStaticColors.darkItemTintColor
                
                self.tabBarController?.tabBar.tintColor = AppStaticColors.accentColor
                UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: AppStaticColors.accentColor], for: .selected)
                UINavigationBar.appearance().barTintColor = AppStaticColors.darkPrimaryColor
                UITabBar.appearance().tintColor =   AppStaticColors.accentColor
                self.navigationController?.navigationBar.barTintColor = AppStaticColors.darkPrimaryColor
                self.navigationController?.navigationBar.backgroundColor = AppStaticColors.darkPrimaryColor
                self.navigationController?.navigationBar.tintColor = AppStaticColors.darkItemTintColor
                UINavigationBar.appearance().tintColor = AppStaticColors.darkItemTintColor
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.darkItemTintColor]
                UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.darkItemTintColor]
                
            } else {
                self.navigationItem.leftBarButtonItem?.tintColor = AppStaticColors.itemTintColor
                self.navigationItem.rightBarButtonItem?.tintColor = AppStaticColors.itemTintColor
                
                self.tabBarController?.tabBar.tintColor = AppStaticColors.accentColor
                UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: AppStaticColors.accentColor], for: .selected)
                UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
                UITabBar.appearance().tintColor =   AppStaticColors.accentColor
                self.navigationController?.navigationBar.barTintColor = AppStaticColors.primaryColor
                self.navigationController?.navigationBar.tintColor = AppStaticColors.itemTintColor
                UINavigationBar.appearance().tintColor = AppStaticColors.itemTintColor
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
                UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
                
            }
        } else {
            self.navigationItem.leftBarButtonItem?.tintColor = AppStaticColors.itemTintColor
            self.navigationItem.rightBarButtonItem?.tintColor = AppStaticColors.itemTintColor
            self.tabBarController?.tabBar.tintColor = AppStaticColors.accentColor
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: AppStaticColors.accentColor], for: .selected)
            UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
            UITabBar.appearance().tintColor =   AppStaticColors.accentColor
            self.navigationController?.navigationBar.barTintColor = AppStaticColors.primaryColor
            self.navigationController?.navigationBar.tintColor = AppStaticColors.itemTintColor
            UINavigationBar.appearance().tintColor = AppStaticColors.itemTintColor
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
            
        }
        
        
    }
    func callingHttppApi(showLoader: Bool = true) {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = false
            var requstParams = [String: Any]()
            NetworkManager.sharedInstance.showLoader()
            if self.refreshControl.isRefreshing {
                NetworkManager.sharedInstance.dismissLoader()
            } else if !showLoader {
                NetworkManager.sharedInstance.dismissLoader()
                self.view.isUserInteractionEnabled = true
            }
            requstParams["eTag"] = DBManager.sharedInstance.geteTagFromDataBase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "homedata"))
            
            NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .get, apiname: .loadHome, currentView: self) {success, responseObject in
                self.refreshingView.isHidden = true
                if success == 1 {
                    NetworkManager.sharedInstance.dismissLoader()
                    self.view.isUserInteractionEnabled = true
                    let jsonResponse = JSON(responseObject as? NSDictionary ?? [:])
                    if jsonResponse["success"].boolValue == true {
                        
                        self.changeIcon(iconName: self.icons[Int(jsonResponse["launcherIconType"].stringValue) ?? 0])
                        
                        if jsonResponse["storeId"] != JSON.null {
                            let storeId: String = String(format: "%@", jsonResponse["storeId"].stringValue)
                            if storeId != "0"{
                                self.defaults .set(storeId, forKey: "storeId")
                            }
                        }
                        
                        if jsonResponse["defaultCurrency"] != JSON.null {
                            if self.defaults.object(forKey: "currency") == nil {
                                self.defaults .set(jsonResponse["defaultCurrency"].stringValue, forKey: "currency")
                            }
                        }
                        
                        let dict =  JSON(responseObject as? NSDictionary ?? [:])
                        
                        // store the data to data base
                        if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]) {
                            DBManager.sharedInstance.storeDataToDataBase(data: data, eTag: dict["eTag"].stringValue, hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "homedata"))
                        }
                        //                        if let products = self.getProductDataFromDB() {
                        self.homeViewModel.getData(jsonData: dict, recentViewData: self.getProductDataFromDB()) {(data: Bool) in
                            if data {
                                //save etag
                                Defaults.eTag = dict["eTag"].stringValue
                                self.appNavigationTheme()
                                self.addLogoToNavigationBarItem()
                                self.processDataForHomeController()
                            }
                        }
                        //                        }
                        
                    } else {
                        self.showErrorSnackBar(msg: "somethingWentWrong".localized)
                    }
                } else if success == 2 {   // Retry in case of error
                    NetworkManager.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                } else if success == 3 {   // No Changes
                    let data =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "homedata"))
                    print(data)
                    
                    self.changeIcon(iconName: self.icons[Int(data["launcherIconType"].stringValue) ?? 0])
                    
                    if let products = self.getProductDataFromDB() {
                        self.homeViewModel.getDataFromDB(data: data, recentViewData: products, completion: { (data: Bool) in
                            if data {
                                self.processDataForHomeController()
                            }
                        })
                    }
                }
            }
        }
    }
    
    
    
    func getProductDataFromDB() -> [Productcollection]? {
        if  let results: Results<Productcollection> = DBManager.sharedInstance.database?.objects(Productcollection.self) {
            return ((Array(results)).sorted(by: { $0.dateTime.compare($1.dateTime) == .orderedDescending }))
        } else {
            return nil
        }
    }
    
    func setupTableFooterView() {
        historyToolBarView?.isHidden = true
        historyToolBarView = Bundle.main.loadNibNamed("BottomMoveToTopTableView", owner: nil, options: nil)![0] as? BottomMoveToTopTableView
        historyToolBarView?.tableView = self.homeTableView
        historyToolBarView?.bottomLabelMessage.isHidden = true
        historyToolBarView?.backToTopButton.isHidden = true
        historyToolBarView?.translatesAutoresizingMaskIntoConstraints = false
        if historyToolBarView != nil {
            historyToolBarView?.addConstraints(
                [NSLayoutConstraint.init(item: historyToolBarView!,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: 103),
                 NSLayoutConstraint.init(item: historyToolBarView!,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: UIScreen.main.bounds.size.width)])
            
            // Create a container of your footer view called footerView and set it as a tableFooterView
            let footerView = UIView(frame: CGRect.init(x: 0, y: 0, width: self.homeTableView.frame.width, height: 103))
            //footerView.backgroundColor = UIColor.green
            homeTableView.tableFooterView = footerView
            checkFotter = true
            // Add your footer view to the container
            footerView.addSubview(historyToolBarView!)
        }
    }
    
    func processDataForHomeController() {
        self.refreshControl.endRefreshing()
        
        self.homeViewModel.homeTableviewheight = self.tableviewHeight
        self.homeTableView.reloadDataWithAutoSizingCellWorkAround()
        
        self.tabBarController?.tabBar.isHidden = false
        self.view.isUserInteractionEnabled = true
        if NetworkManager.AddOnsEnabled.wishlistEnable {
            self.tabBarController?.tabBar.items?[2].isEnabled = true
        } else {
            self.tabBarController?.tabBar.items?[2].isEnabled = false
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("pushNotificationforCategoryOnTap"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("pushNotificationforProductOnTap"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("pushNotificationforCustomCollectionOnTap"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("pushNotificationforOtherOnTap"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("offlineCartUpdate"), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("pushNotificationforOrderOnTap"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("pushNotificationReceivedCartClick"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("refreshHome"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("updateRecentlyViewed"), object: nil)
    }
}

extension ViewController: MoveController {
    func moveController(id: String, name: String, dict: DictType, jsonData: JSON, type: String, controller: AllControllers) {
        self.navigationController?.navigationBar.isHidden = false
        switch controller {
        case .productcategory:
            let nextController = CategoryProductsViewController.instantiate(fromAppStoryboard: .product)
            nextController.categoryId = id
            nextController.titleName = name
            nextController.categoryType = type
            //            nextController.categories = self.homeViewModel.categories
            self.navigationController?.pushViewController(nextController, animated: true)
        case .signInController:
            let customerLoginVC = LoginViewController.instantiate(fromAppStoryboard: .customer)
            let nav = UINavigationController(rootViewController: customerLoginVC)
            nav.modalPresentationStyle = .fullScreen
            //nav.navigationBar.tintColor = AppStaticColors.accentColor
            self.present(nav, animated: true, completion: nil)
        default:
            break
        }
    }
}

// For barbutton actions

extension ViewController {
    
    @IBAction func tapOnSearchBarPressed(_ sender: UIButton) {
        self.tabBarController?.tabBar.isHidden = true
        let viewController = SearchDataViewController.instantiate(fromAppStoryboard: .search)
        //viewController.modalPresentationStyle = .overCurrentContext
        viewController.categories = self.homeViewModel.categories
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func searchClicked(_ sender: UIBarButtonItem) {
        self.tabBarController?.tabBar.isHidden = true
        let viewController = SearchDataViewController.instantiate(fromAppStoryboard: .search)
        //viewController.modalPresentationStyle = .overCurrentContext
        viewController.categories = self.homeViewModel.categories
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func notificationClicked(_ sender: UIBarButtonItem) {
        self.tabBarController?.tabBar.isHidden = true
        let viewController = NotificationDataViewController.instantiate(fromAppStoryboard: .main)
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    @IBAction func cartClicked(_ sender: UIBarButtonItem) {
        let viewController = CartDataViewController.instantiate(fromAppStoryboard: .product)
        let nav = UINavigationController(rootViewController: viewController)
        //nav.navigationBar.tintColor = AppStaticColors.accentColor
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
    }
    
    
}
extension ViewController{
    func registerToReceiveNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushNotificationReceivedCategoryTap), name: NSNotification.Name(rawValue: "pushNotificationforCategoryOnTap"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushNotificationReceivedProductTap), name: NSNotification.Name(rawValue: "pushNotificationforProductOnTap"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.cartBadgeUpdate), name: NSNotification.Name(rawValue: "offlineCartUpdate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushNotificationReceivedCustomCollectionTap), name: NSNotification.Name(rawValue: "pushNotificationforCustomCollectionOnTap"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushNotificationReceivedOtherTap), name: NSNotification.Name(rawValue: "pushNotificationforOtherOnTap"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushNotificationReceivedOrderTap), name: NSNotification.Name(rawValue: "pushNotificationforOrderOnTap"), object: nil)
        
    }
    
    @objc func pushNotificationReceivedCategoryTap(_ note: Notification) {
        let root  = note.userInfo
        let nextController = CategoryProductsViewController.instantiate(fromAppStoryboard: .product)
        nextController.categoryId = root?["categoryId"] as? String ?? ""
        nextController.titleName = root?["categoryName"] as? String ?? ""
        nextController.categoryType = ""
        //            nextController.categories = self.homeViewModel.categories
        self.navigationController?.pushViewController(nextController, animated: true)
        
    }
    @objc func cartBadgeUpdate(_ note: Notification) {
        cartBtn.badgeNumber = Int(Defaults.cartBadge ?? "0") ?? 0
    }
    @objc func pushNotificationReceivedProductTap(_ note: Notification) {
        let root = note.userInfo
        
        let nextController = ProductPageDataViewController.instantiate(fromAppStoryboard: .product)
        nextController.productId = root?["productId"] as? String ?? ""
        nextController.productName = root?["productName"] as? String ?? ""
        self.navigationController?.pushViewController(nextController, animated: true)
    }
    
    @objc func pushNotificationReceivedCustomCollectionTap(_ note: Notification) {
        let root = note.userInfo;
        
        let nextController = CategoryProductsViewController.instantiate(fromAppStoryboard: .product)
        nextController.categoryId = root?["id"] as? String ?? ""
        nextController.titleName = root?["title"] as? String ?? ""
        nextController.categoryType = "custom"
        //            nextController.categories = self.homeViewModel.categories
        self.navigationController?.pushViewController(nextController, animated: true)
        
    }
    
    @objc func pushNotificationReceivedOtherTap(_ note: Notification) {
        let root = note.userInfo;
        let title = root?["title"] as? String ?? ""
        let content = root?["message"] as? String ?? ""
        let AC = UIAlertController(title: title, message: content, preferredStyle: .alert)
        
        let okBtn = UIAlertAction(title: "ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.callingHttppApi();
        })
        AC.addAction(okBtn)
        self.parent!.present(AC, animated: true, completion: { })
    }
    
    @objc func pushNotificationReceivedOrderTap(_ note: Notification) {
        let root = note.userInfo;
        let viewController = OrderDetailsDataViewController.instantiate(fromAppStoryboard: .customer)
        viewController.orderId = root?["incrementId"] as? String ?? ""
        let nav = UINavigationController(rootViewController: viewController)
        //nav.navigationBar.tintColor = AppStaticColors.accentColor
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    @objc func pushNotificationReceivedCartClick(_ note: Notification) {
        let viewController = CartDataViewController.instantiate(fromAppStoryboard: .product)
        let nav = UINavigationController(rootViewController: viewController)
        //nav.navigationBar.tintColor = AppStaticColors.accentColor
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}


extension ViewController: CLLocationManagerDelegate {
    func fetchLocation() {
        DispatchQueue.main.async {
            
            //            self.locationManager = CLLocationManager()
            //            self.locationManager?.delegate = self
            //            self.locationManager?.distanceFilter = 1;
            //            self.locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            //            self.buildings = [[NSMutableArray alloc] init];
            
            self.locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation//kCLLocationAccuracyBest
            self.locationManager?.delegate = self
            self.locationManager?.distanceFilter = 1
            self.locationManager?.requestWhenInUseAuthorization()
            self.locationManager?.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
            let latestLocation = locations.last
            let g = CLGeocoder()
            var p:CLPlacemark?
            g.reverseGeocodeLocation(latestLocation!, completionHandler: {
                (placemarks, error) in
                let pm = placemarks
                if ((pm != nil) && (pm?.count)! > 0){
                    // p = CLPlacemark()
                    p = CLPlacemark(placemark: (pm?[0])!)
                    
                    var addressDict = [String: Any]()
                    var streetArray = [String]()
                    if let names = Defaults.customerName?.components(separatedBy: " "), names.count > 1 {
                        addressDict["firstname"] = names[0]
                        addressDict["lastname"] = names[names.count - 1]
                    } else {
                        addressDict["firstname"] = Defaults.customerName
                        addressDict["lastname"] = ""
                    }
                    // addressDict["firstname"] = Defaults.customerName
                    // addressDict["lastname"] = Defaults.customerName
                    addressDict["postcode"] = p?.postalCode
                    addressDict["country_id"] = p?.isoCountryCode
                    addressDict["city"] = p?.subAdministrativeArea
                    
                    if let subLocality = p?.subLocality {
                        streetArray.append(subLocality)
                    }
                    if let regionId = p?.administrativeArea {
                        addressDict["region_id"] = regionId
                    }
                    if let locality = p?.locality {
                        streetArray.append(locality)
                    }
                    addressDict["street"] = streetArray
                    let jsonData = JSON(addressDict)
                    NetworkManager.addressData = StoredAddressData(json: jsonData)
                }
            })
        }
    }
}

extension ViewController {
    
    func setupRefreshHome() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshHomeData), name: NSNotification.Name(rawValue: "refreshHome"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshHomeApiData), name: NSNotification.Name(rawValue: "refreshHomeApiData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateRecentlyViewed), name: NSNotification.Name(rawValue: "updateRecentlyViewed"), object: nil)
    }
    
    @objc func updateRecentlyViewed() {
        self.homeViewModel.updateRecentlyViewed(recentViewData: self.getProductDataFromDB()) {(section: Int?) in
            self.homeViewModel.homeTableviewheight = self.tableviewHeight
            self.homeTableView.reloadDataWithAutoSizingCellWorkAround()
            //            if let section = section {
            //                self.homeTableView.reloadSections(IndexSet(arrayLiteral: section), with: .none)
            //            } else {
            //                self.homeTableView.reloadData()
            //            }
        }
    }
    
    @objc func refreshHomeApiData() {
        self.refreshingView.isHidden = false
        self.refreshHomePageData()
    }
    
    @objc func refreshHomeData() {
        (self.tabBarController?.viewControllers?[0] as? UINavigationController)?.popToRootViewController(animated: true)
        (self.tabBarController?.viewControllers?[1] as? UINavigationController)?.popToRootViewController(animated: true)
        (self.tabBarController?.viewControllers?[2] as? UINavigationController)?.popToRootViewController(animated: true)
        (self.tabBarController?.viewControllers?[4] as? UINavigationController)?.popToRootViewController(animated: true)
        self.refreshingView.isHidden = false
        self.refreshHomePageData()
    }
    
    func refreshHomePageData() {
        DispatchQueue.main.async {
            var requstParams = [String: Any]()
            requstParams["eTag"] = DBManager.sharedInstance.geteTagFromDataBase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "homedata"))
            NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .get, apiname: .loadHome, currentView: self) {success, responseObject in
                self.refreshingView.isHidden = true
                if success == 1 {
                    self.view.isUserInteractionEnabled = true
                    let jsonResponse = JSON(responseObject as? NSDictionary ?? [:])
                    if jsonResponse["success"].boolValue == true {
                        self.changeIcon(iconName: self.icons[Int(jsonResponse["launcherIconType"].stringValue) ?? 0])
                        
                        if jsonResponse["storeId"] != JSON.null {
                            let storeId: String = String(format: "%@", jsonResponse["storeId"].stringValue)
                            if storeId != "0"{
                                self.defaults .set(storeId, forKey: "storeId")
                            }
                        }
                        if jsonResponse["defaultCurrency"] != JSON.null {
                            if self.defaults.object(forKey: "currency") == nil {
                                self.defaults .set(jsonResponse["defaultCurrency"].stringValue, forKey: "currency")
                            }
                        }
                        let dict =  JSON(responseObject as? NSDictionary ?? [:])
                        if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]) {
                            DBManager.sharedInstance.storeDataToDataBase(data: data, eTag: dict["eTag"].stringValue, hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "homedata"))
                        }
                        self.homeViewModel.getData(jsonData: dict, recentViewData: self.getProductDataFromDB()) {(data: Bool) in
                            if data {
                                Defaults.eTag = dict["eTag"].stringValue
                                self.refreshControl.endRefreshing()
                                self.homeViewModel.homeTableviewheight = self.tableviewHeight
                                self.appNavigationTheme()
                                self.addLogoToNavigationBarItem()
                                self.homeTableView.reloadDataWithAutoSizingCellWorkAround()
                                if GlobalVariables.walkThroughFirstTime {
                                    GlobalVariables.walkThroughFirstTime = false
                                    Defaults.walkthroughShow = false
                                }
                                //self.processDataForHomeController()
                            }
                        }
                    } else {
                        self.showErrorSnackBar(msg: "somethingWentWrong".localized)
                    }
                } else if success == 2 {   // Retry in case of error
                    self.refreshHomePageData()
                } else if success == 3 {   // No Changes
                    let data =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "homedata"))
                    print(data)
                    self.changeIcon(iconName: self.icons[Int(data["launcherIconType"].stringValue) ?? 0])
                    if let products = self.getProductDataFromDB() {
                        self.homeViewModel.getDataFromDB(data: data, recentViewData: products, completion: { (data: Bool) in
                            if data {
                                if GlobalVariables.walkThroughFirstTime {
                                    GlobalVariables.walkThroughFirstTime = false
                                    Defaults.walkthroughShow = false
                                }
                                self.processDataForHomeController()
                            }
                        })
                    }
                }
            }
        }
    }
    
    func changeIcon(iconName: String) {
        
        //        if #available(iOS 10.3, *) {
        //               UIApplication.shared.setAlternateIconName(iconName)
        //            }
        
        if #available(iOS 10.3, *) {
            print(iconName)
            if UIApplication.shared.responds(to: #selector(getter: UIApplication.supportsAlternateIcons)) && UIApplication.shared.supportsAlternateIcons {
                
                typealias setAlternateIconName = @convention(c) (NSObject, Selector, NSString?, @escaping (NSError) -> ()) -> ()
                
                let selectorString = "_setAlternateIconName:completionHandler:"
                
                let selector = NSSelectorFromString(selectorString)
                let imp = UIApplication.shared.method(for: selector)
                let method = unsafeBitCast(imp, to: setAlternateIconName.self)
                method(UIApplication.shared, selector, iconName as NSString?, { _ in })
            }
        }
        
        
    }
    
}
//MARK:- Handle HyperLocal Part

extension ViewController{
    
    func initHyperLocalView(){
        changeButton.setTitle("change".localized, for: .normal)
        //changeButton.setTitleColor(AppStaticColors.accentColor, for: .normal)
        
#if HYPERLOCAL
        userAddress.text = Defaults.placeName
        hyperlocalView.shadowBorderWithCorner()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateLocation), name: NSNotification.Name(rawValue: "locationupdatenotification"), object: nil)
#else
        hyperlocalViewHeight.constant = 0
        hyperlocalView.isHidden = true
#endif
    }
    
    
    @objc func updateLocation(_ note: Notification) {
        userAddress.text = Defaults.placeName
        DBManager.sharedInstance.deleteAllFromDatabase()
        self.callingHttppApi()
    }
    
}
