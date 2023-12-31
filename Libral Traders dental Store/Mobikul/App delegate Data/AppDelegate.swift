//

/*
 Mobikul_Magento2V3_App
 @Category Webkul
 @author Webkul
 FileName: AppDelegate.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html
 */

import UIKit
import Firebase
import Firebase
import IQKeyboardManager
import FirebaseMessaging
import FirebaseInstanceID
import UserNotifications
import SVProgressHUD
import Siren
import RealmSwift
import GooglePlacePicker
import GoogleMaps
import Alamofire
import ChatSDK
import ChatProvidersSDK
 
var localNotificationTapCheck = false
@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate {
     var window: UIWindow?
    
    override init() {
        super.init()
        UIFont.overrideInitialize()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SVProgressHUD.setDefaultMaskType(.black)
        Siren.shared.wail()
        self.checkSchema()

       

        self.setupPushNotification(application: application, launchOptions: launchOptions)
        self.setView()
        Fabric.sharedSDK().debug = true
        Chat.initialize(accountKey: "I9ebMyh75M5xOCa34IKHGWXfVrLsGfzT")
        
        application.applicationIconBadgeNumber = 0
        IQKeyboardManager.shared().isEnabled = true
        #if BTOB
        IQKeyboardManager.shared().disabledDistanceHandlingClasses.add(SupplierCustomerChatViewController.self)
        IQKeyboardManager.shared().disabledDistanceHandlingClasses.add(ChatViewController.self)
        #elseif MARKETPLACE
        IQKeyboardManager.shared().disabledDistanceHandlingClasses.add(ChatViewController.self)
        #endif
//       Fabric.with([Crashlytics.self])
        //Chat.initialize(accountKey: "I9ebMyh75M5xOCa34IKHGWXfVrLsGfzT", queue: .main)
        GMSServices.provideAPIKey("AIzaSyBgV8NDOeGncbSCRzc0-zrNNYyScNqxZWY")
        GMSPlacesClient.provideAPIKey("AIzaSyBgV8NDOeGncbSCRzc0-zrNNYyScNqxZWY")
        AppStaticColors.applyTheme()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        var handle:Bool = true
     

        //handle = GIDSignIn.sharedInstance().handle(url as URL?, sourceApplication: sourceApplication, annotation: annotation)
        
        return handle;
    }

    
   
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
       startMonitoring()
    }
    func startMonitoring() {
        let reachability = NetworkReachabilityManager()
        
        reachability?.startListening()
        reachability?.listener = { status in
            if let isNetworkReachable = reachability?.isReachable,
               isNetworkReachable == true {
                //Internet Available
                if Defaults.isShowAlert ?? false {
                    self.alertShow()
                }
            } else {
                
                print("Network became unreachable")
                //Internet Not Available"
            }
        }
    }
    
    
    func alertShow(){
        if (Defaults.addToCart ?? 0) > 0{
            Defaults.isShowAlert = false
            let alertController = UIAlertController(title: "Offline Cart".localized, message: "There are some pending add to cart instances on this device which are not synced with server. Would you like to sync them?".localized, preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "Sync Now".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                self.callingOfflineAddToCart()
            })
            let noBtn = UIAlertAction(title: "Clear All".localized, style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                if (Defaults.addToCart ?? 0) > 0{
                    for i in 1..<(Defaults.addToCart ?? 0) + 1{
                        DBManager.sharedInstance.deleteSpecificFromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "cartApis"+"\(i)"))
                    }
                    Defaults.addToCart = 0
                }
            })
            alertController.addAction(okBtn)
            alertController.addAction(noBtn)
            NetworkManager.sharedInstance.topMostController().present(alertController, animated: true, completion: { })
        }
    }
    
    func callingOfflineAddToCart(){
        if (Defaults.addToCart ?? 0) > 0{
            for i in 1..<(Defaults.addToCart ?? 0) + 1 {
                guard let params = DBManager.sharedInstance.convertToDictionary(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "cartApis"+"\(i)")) else { return }
                NetworkManager.sharedInstance.callingHttpRequest(params: params, method: .post, apiname: .addToCart, currentView: UIViewController()) { [weak self]
                    success, responseObject  in
                    NetworkManager.sharedInstance.dismissLoader()
                    if success == 1 {
                        let data =  JSON(responseObject as? NSDictionary ?? [:])
                        if data["success"].boolValue {
                            (Defaults.cartBadge) = data["cartCount"].stringValue
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "offlineCartUpdate"), object: nil, userInfo: nil)
                            if data["quoteId"].stringValue.count > 0  {
                                Defaults.quoteId = data["quoteId"].stringValue
                            }
                        }
                        DBManager.sharedInstance.deleteSpecificFromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "cartApis"+"\(i)"))
                        
                    } else {
                        DBManager.sharedInstance.deleteSpecificFromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "cartApis"+"\(i)"))
                    }
                }
            }
            Defaults.addToCart = 0
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
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
}


extension AppDelegate{
    func setupPushNotification(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
        //Push
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification), name: Notification.Name.MessagingRegistrationTokenRefreshed, object: nil)
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            FirebaseApp.configure()
            UNUserNotificationCenter.current().delegate = self
            Messaging.messaging().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        if let remoteNotif = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.application(application, didReceiveRemoteNotification: remoteNotif)
            })
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var tokenq = ""
        for i in 0..<deviceToken.count {
            tokenq = tokenq + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        Messaging.messaging().apnsToken = deviceToken as Data
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        if Messaging.messaging().fcmToken != nil {
            print("SSSSSSSS")
            Messaging.messaging().subscribe(toTopic: "libraltraders_live_ios")
        }
        connectToFcm()
    }
    
    @objc func tokenRefreshNotification(_ notification: Notification) {
             
              InstanceID.instanceID().instanceID { (result, error) in
                       if let error = error {
                         print("Error fetching remote instance ID: \(error)")
                       } else if let result = result {
                          Defaults.deviceToken = result.token
                                   Messaging.messaging().subscribe(toTopic: "libraltraders_live_ios")
                       }
          }
          // Connect to FCM since connection may have failed when attempted before having a token.
          connectToFcm()
      }
      
      func connectToFcm() {
          // Won't connect since there is no token
         InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
              print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
             Messaging.messaging().subscribe(toTopic: "libraltraders_live_ios")
              Messaging.messaging().isAutoInitEnabled = true
            }
          }

      }
    
    func callingHttppApi(){
        var requstParams = [String:Any]()
        requstParams["customerToken"] = Defaults.customerToken
        requstParams["token"] = Defaults.deviceToken
        requstParams["os"] = "ios"
        NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, method: .post, apiname:.registerDevice, currentView: UIViewController()){success,responseObject in
            if success == 1{
                print(responseObject)
            }else if success == 2{
            }
        }
    }
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationReceivedCartClick"), object: nil, userInfo: nil)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
        guard let notificationType = userInfo["notificationType"] as? String else { return }
        if UIApplication.shared.applicationState == .inactive || UIApplication.shared.applicationState == .background {// tap
            if notificationType  == "category"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforCategoryOnTap"), object: nil, userInfo: userInfo)
            }else if notificationType  == "product"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforProductOnTap"), object: nil, userInfo: userInfo)
            }else if notificationType  == "custom"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforCustomCollectionOnTap"), object: nil, userInfo: userInfo)
            }else if notificationType  == "other"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforOtherOnTap"), object: nil, userInfo: userInfo)
            }else if notificationType  == "order"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforOrderOnTap"), object: nil, userInfo: userInfo)
            }
        }
        
        if UIApplication.shared.applicationState == .background{
            var count:Int = 0
            if Defaults.notificationCount != nil{
                if let stored = Defaults.notificationCount {
                    count = Int(stored)! + 1
                    let data =  String(format: "%d", count as CVarArg)
                    Defaults.notificationCount = data
                }
            } else {
                Defaults.notificationCount = "1"
                count = 1
            }
            if count > 0{
                application.applicationIconBadgeNumber = count
            }
        }
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print full message.
        print(userInfo)
        // Change this to your preferred presentation option
        completionHandler(UNNotificationPresentationOptions.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            // topController should now be your topmost view controller
            if let tabVC = topController as? UITabBarController   {
                tabVC.selectedIndex = 0
                let navigation:UINavigationController = (topController as! UITabBarController).viewControllers?[0] as! UINavigationController
                navigation.popToRootViewController(animated: true)
            }
        }
        let type =  response.notification.request.identifier
        if type  == "cartLocalNotification"{
            localNotificationTapCheck = true
        }
        if type != "appuse"{
            guard let notificationType = userInfo["notificationType"] as? String else { return }
            if notificationType  == "category"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforCategoryOnTap"), object: nil, userInfo: userInfo)
            }else if notificationType  == "product"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforProductOnTap"), object: nil, userInfo: userInfo)
            }else if notificationType  == "custom"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforCustomCollectionOnTap"), object: nil, userInfo: userInfo)
            }else if notificationType  == "other"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforOtherOnTap"), object: nil, userInfo: userInfo)
            }else if notificationType  == "order"{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushNotificationforOrderOnTap"), object: nil, userInfo: userInfo)
            }
        }
        completionHandler()
    }
}

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        Messaging.messaging().subscribe(toTopic: "libraltraders_live_ios")
//        Messaging.messaging().dir = true
        connectToFcm()
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        print("Received data message: \(remoteMessage.appData)")
//    }
    
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//            print("Firebase registration token: \(fcmToken)")
//
//            let dataDict:[String: String] = ["token": fcmToken]
//
//            firebaseData.fcmToken = fcmToken
//
//            NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
//        }
    // [END ios_10_data_message]
}

struct AppFontName {
    static let regular = "Montserrat-Regular"
    static let bold = "Montserrat-SemiBold"
    static let italic = "PingFangSC-Semibold"
    static let medium = "Montserrat-Medium"
}

extension UIFont {
    
    @objc class func mySystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.regular, size: size)!
    }
    
    @objc class func myBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.bold, size: size)!
    }
    
    @objc class func myItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFontName.italic, size: size)!
    }
    
    @objc convenience init(myCoder aDecoder: NSCoder) {
        if let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor {
            if let fontAttribute = fontDescriptor.fontAttributes[UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")] as? String {
                var fontName = ""
                switch fontAttribute {
                case "CTFontRegularUsage":
                    fontName = AppFontName.regular
                case "CTFontEmphasizedUsage", "CTFontBoldUsage":
                    fontName = AppFontName.bold
                case "CTFontObliqueUsage":
                    fontName = AppFontName.italic
                case "CTFontHeavyUsage":
                    fontName = AppFontName.bold
                default:
                    fontName = AppFontName.regular
                }
                self.init(name: fontName, size: fontDescriptor.pointSize)!
            } else {
                self.init(myCoder: aDecoder)
            }
        } else {
            self.init(myCoder: aDecoder)
        }
    }
    
    class func overrideInitialize() {
        if self == UIFont.self {
            let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:)))
            let mySystemFontMethod = class_getClassMethod(self, #selector(mySystemFont(ofSize:)))
            method_exchangeImplementations(systemFontMethod!, mySystemFontMethod!)
            
            let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:)))
            let myBoldSystemFontMethod = class_getClassMethod(self, #selector(myBoldSystemFont(ofSize:)))
            method_exchangeImplementations(boldSystemFontMethod!, myBoldSystemFontMethod!)
            
            let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:)))
            let myItalicSystemFontMethod = class_getClassMethod(self, #selector(myItalicSystemFont(ofSize:)))
            method_exchangeImplementations(italicSystemFontMethod!, myItalicSystemFontMethod!)
            
            let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))) // Trick to get over the lack of UIFont.init(coder:))
            let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:)))
            method_exchangeImplementations(initCoderMethod!, myInitCoderMethod!)
        }
    }
}


//MARK:- ------------- Deep Linking Start ---------
extension AppDelegate {
    //    @available(iOS 8.0, *)
    func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        print(userActivityType)
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        print("Continue User Activity: ")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if userActivity.activityType == NSUserActivityTypeBrowsingWeb, let url = userActivity.webpageURL  {
                print(url.absoluteString)
                var requstParams = [String:Any]()
                NetworkManager.sharedInstance.showLoader()
                requstParams["storeId"] = Defaults.storeId
                requstParams["customerToken"] = Defaults.customerToken
                requstParams["quoteId"] = Defaults.quoteId
                requstParams["currency"] = Defaults.currency
                requstParams["isFromUrl"] = "1"
                requstParams["url"] = url.absoluteString
                requstParams["websiteId"] = UrlParams.defaultWebsiteId
                requstParams["width"] = UrlParams.width
                NetworkManager.sharedInstance.callingHttpRequest(params:requstParams, method: .get, apiname:.loadHome, currentView: UIViewController()){success,responseObject in
                    NetworkManager.sharedInstance.dismissLoader()
                    if success == 1{
                        print(responseObject)
                        let jsonResponse = JSON(responseObject as? NSDictionary ?? [:])
                        let id = jsonResponse["productId"].stringValue
                        if id.count > 0 {
                            let nextController = ProductPageDataViewController.instantiate(fromAppStoryboard: .product)
                            nextController.productId = id
                            nextController.productName = jsonResponse["productName"].stringValue
                            let nav = UINavigationController(rootViewController: nextController)
                            nav.navigationBar.tintColor = AppStaticColors.itemTintColor
                            nav.modalPresentationStyle = .fullScreen
                            NetworkManager.sharedInstance.topMostController().present(nav, animated: true, completion: nil)
                        }
                    }else if success == 2{
                    }
                }
            }
        }
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Check if the URL scheme matches your app's custom scheme or universal link
        if url.scheme == "Libral Traders" {
            // Extract the path component to determine which screen to open
            let pathComponents = url.pathComponents
            if pathComponents.contains("screen") && pathComponents.count > 1 {
                let screenId = pathComponents[1]
                // Open the specified screen
                // ...
                return true
            }
        }
        return false
    }
    @available(iOS 8.0, *)
    //    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Swift.Void) -> Bool {
    //
    //        logInfo(continue: userActivity)
    //
    //        if userActivity.activityType == "NSUserActivityTypeBrowsingWeb" {
    //            print(userActivity.webpageURL)
    //            let url = URL(string: userActivity.webpageURL?.description ?? "")
    //
    //            let myTabBar = self.window?.rootViewController as! UITabBarController
    //            myTabBar.selectedIndex = 0
    //
    //            //            guard let viewcontroller = UIApplication.topViewController() else { return false }
    //            //            if viewcontroller.isModal == true{
    //            //                viewcontroller.navigationController?.dismiss(animated: true, completion: nil)
    //            //            }else{
    //            //                viewcontroller.navigationController?.popToRootViewController(animated: true)
    //            //            }
    //            //
    //            //            if let topViewcontroller = UIApplication.topViewController() as? ViewController, let _ = topViewcontroller.storyboard?.instantiateViewController(withIdentifier: "catalogproduct") as? CatalogProduct{
    //            //                if url != nil   {
    //            //                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deepLink"), object: nil, userInfo: ["url":url?.absoluteString])
    //            //                }
    //            //            }
    //        }
    //        return true
    //    }
    
    func getQueryStringParameter(url: String, param: String) -> String? {
        let newurl = url.replacingOccurrences(of: "%3F", with: "?")
        guard let url = URLComponents(string: newurl) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
    @available(iOS 8.0, *)
    func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
        print(#function)
        print(userActivityType)
    }
    
    
    @available(iOS 8.0, *)
    func application(_ application: UIApplication, didUpdate userActivity: NSUserActivity) {
        print(#function)
        logInfo(continue: userActivity)
    }
    
    func logInfo(continue userActivity: NSUserActivity)  {
        //        print(userActivity)
        //        print(userActivity.activityType)
        //        print(userActivity.title as String!)
        //        print(userActivity.userInfo as [AnyHashable:Any]!)
        //        print(userActivity.webpageURL as URL!)
        ////        print(userActivity.expirationDate as Date!)
        //        print(userActivity.keywords)
    }    
}
