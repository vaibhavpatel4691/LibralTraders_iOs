//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: UserDefaultsData.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation

struct Defaults {
    enum Key: String {
        case storeId = "storeId"
        case customerToken = "customerToken"
        case customerId = "customerId"
        case touchEmail = "touchEmail"
        case touchPassword = "touchPassword"
        case touchFlag = "touchFlag"
        case quoteId = "quoteId"
        case currency = "currency"
        case language = "language"
        case eTag = "eTag"
        case customerEmail = "customerEmail"
        case customerName = "customerName"
        case profilePicture = "profilePicture"
        case profileBanner = "profileBanner"
        case deviceToken = "deviceToken"
        case isAdmin = "isAdmin"
        case isSeller = "isSeller"
        case isSupplier = "isSupplier"
        case isPending = "isPending"
        case appleLanguages = "AppleLanguages"
        case cartBadge = "cartBadge"
        case notificationCount = "notificationCount"
        case searchEnable  = "searchEnable"
        case websiteId  = "websiteId"
        case latitude = "latitude"
        case langitude = "langitude"
        case placeName = "placeName"
        case addToCart = "addToCart"
        case isShowAlert = "isShowAlert"
        case city = "city";
        case country = "country"
        case state = "state"
        case lightSplashScreen = "lightSplashImage"
        case darkSplashScreen = "darkSplashScreen"
        case walkThroughVersion = "walkThroughVersion"
        case walkthroughShow = "walkthroughShow"
        
    }
    
    static var notificationCount: String? {
        get {
            let notificationCount = UserDefaults.standard.string(forKey: Key.notificationCount.rawValue)
            return notificationCount ?? nil
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.notificationCount.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var searchEnable: String? {
        get {
            let searchEnable = UserDefaults.standard.string(forKey: Key.searchEnable.rawValue)
            return searchEnable
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.searchEnable.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var deviceToken: String? {
        get {
            let deviceToken = UserDefaults.standard.string(forKey: Key.deviceToken.rawValue)
            return deviceToken ?? nil
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.deviceToken.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var customerId: String? {
            get {
                let customerId = UserDefaults.standard.string(forKey: Key.customerId.rawValue)
                return customerId
            }
            set {
                UserDefaults.standard.set(newValue, forKey: Key.customerId.rawValue)
                UserDefaults.standard.synchronize()
            }
        }
    
    static var cartBadge: String {
        get {
            let cartBadge = UserDefaults.standard.string(forKey: Key.cartBadge.rawValue)
            return cartBadge ?? "0"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.cartBadge.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
//    static var isAdmin: String? {
//        get {
//            let isAdmin = UserDefaults.standard.string(forKey: Key.isAdmin.rawValue)
//            return isAdmin ?? nil
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: Key.isAdmin.rawValue)
//            UserDefaults.standard.synchronize()
//        }
//    }
    
    static var isAdmin: Bool {
        get {
            let isAdmin = UserDefaults.standard.bool(forKey: Key.isAdmin.rawValue)
            return isAdmin
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.isAdmin.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var isSeller: Bool {
        get {
            let isSeller = UserDefaults.standard.bool(forKey: Key.isSeller.rawValue)
            return isSeller
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.isSeller.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var isSupplier: Bool {
        get {
            let isSupplier = UserDefaults.standard.bool(forKey: Key.isSupplier.rawValue)
            return isSupplier
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.isSupplier.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var isPending: Bool? {
        get {
            let isPending = UserDefaults.standard.bool(forKey: Key.isPending.rawValue)
            return isPending
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.isPending.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var profileBanner: String? {
        get {
            let profileBanner = UserDefaults.standard.string(forKey: Key.profileBanner.rawValue)
            return profileBanner ?? nil
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.profileBanner.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var profilePicture: String? {
        get {
            let profilePicture = UserDefaults.standard.string(forKey: Key.profilePicture.rawValue)
            return profilePicture ?? nil
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.profilePicture.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var customerName: String? {
        get {
            let customerName = UserDefaults.standard.string(forKey: Key.customerName.rawValue)
            return customerName ?? nil
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.customerName.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var customerEmail: String? {
        get {
            let customerEmail = UserDefaults.standard.string(forKey: Key.customerEmail.rawValue)
            return customerEmail ?? nil
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.customerEmail.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var language: String? {
        get {
            let language = UserDefaults.standard.string(forKey: Key.language.rawValue)
            return language ?? nil
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.language.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    static var addToCart: Int? {
        get {
            let addToCart = UserDefaults.standard.integer(forKey: Key.addToCart.rawValue)
            return addToCart ?? 0
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.addToCart.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var isShowAlert: Bool? {
        get {
            let isShowAlert = UserDefaults.standard.bool(forKey: Key.isShowAlert.rawValue)
            return isShowAlert ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.isShowAlert.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    static var currency: String? {
        get {
            let currency = UserDefaults.standard.string(forKey: Key.currency.rawValue)
            return currency
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.currency.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var storeId: String {
        get {
            let storeId = UserDefaults.standard.string(forKey: Key.storeId.rawValue)
            return storeId ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.storeId.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var quoteId: String {
        get {
            let quoteId = UserDefaults.standard.string(forKey: Key.quoteId.rawValue)
            return quoteId ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.quoteId.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var customerToken: String? {
        get {
            let customerToken = UserDefaults.standard.string(forKey: Key.customerToken.rawValue)
            return customerToken
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.customerToken.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    static var walkThroughVersion: Double? {
        get {
            let iswalkThroughVersion = UserDefaults.standard.double(forKey: Key.walkThroughVersion.rawValue)
            return iswalkThroughVersion
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.walkThroughVersion.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    static var walkthroughShow: Bool {
        get {
            let iswalkThrough = UserDefaults.standard.bool(forKey: Key.walkthroughShow.rawValue)
            return iswalkThrough
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.walkthroughShow.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var touchEmail: String? {
        get {
            let customerToken = UserDefaults.standard.string(forKey: Key.touchEmail.rawValue)
            return customerToken
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.touchEmail.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var touchPassword: String? {
        get {
            let customerToken = UserDefaults.standard.string(forKey: Key.touchPassword.rawValue)
            return customerToken
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.touchPassword.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var touchFlag: String? {
        get {
            let customerToken = UserDefaults.standard.string(forKey: Key.touchFlag.rawValue)
            return customerToken
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.touchFlag.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var lightSplashScreen: String? {
        get {
            let customerToken = UserDefaults.standard.string(forKey: Key.lightSplashScreen.rawValue)
            return customerToken
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.lightSplashScreen.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    static var darkSplashScreen: String? {
        get {
            let customerToken = UserDefaults.standard.string(forKey: Key.darkSplashScreen.rawValue)
            return customerToken
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.darkSplashScreen.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    static var eTag: String {
        get {
            let eTag = UserDefaults.standard.string(forKey: Key.eTag.rawValue)
            return eTag ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.eTag.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var websiteId: String {
        get {
            let websiteId = UserDefaults.standard.string(forKey: Key.websiteId.rawValue)
            return websiteId ?? "1"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.websiteId.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    static var latitude:String{
              get {
                  let latitude = UserDefaults.standard.string(forKey: Key.latitude.rawValue)
                  return latitude ?? ""
              }
              set {
                  UserDefaults.standard.set(newValue, forKey: Key.latitude.rawValue)
                  UserDefaults.standard.synchronize()
              }
          }
          
          static var langitude:String{
              get {
                  let langitude = UserDefaults.standard.string(forKey: Key.langitude.rawValue)
                  return langitude ?? ""
              }
              set {
                  UserDefaults.standard.set(newValue, forKey: Key.langitude.rawValue)
                  UserDefaults.standard.synchronize()
              }
          }
          
          static var placeName:String{
              get {
                  let placeName = UserDefaults.standard.string(forKey: Key.placeName.rawValue)
                  return placeName ?? "No Location is set".localized
              }
              set {
                  UserDefaults.standard.set(newValue, forKey: Key.placeName.rawValue)
                  UserDefaults.standard.synchronize()
              }
          }
          
          static var city:String{
              get {
                  let city = UserDefaults.standard.string(forKey: Key.city.rawValue)
                  return city ?? ""
              }
              set {
                  UserDefaults.standard.set(newValue, forKey: Key.city.rawValue)
                  UserDefaults.standard.synchronize()
              }
          }
          
          
          static var state:String{
              get {
                  let state = UserDefaults.standard.string(forKey: Key.state.rawValue)
                  return state ?? ""
              }
              set {
                  UserDefaults.standard.set(newValue, forKey: Key.state.rawValue)
                  UserDefaults.standard.synchronize()
              }
          }
          
          static var country:String{
              get {
                  let country = UserDefaults.standard.string(forKey: Key.country.rawValue)
                  return country ?? ""
              }
              set {
                  UserDefaults.standard.set(newValue, forKey: Key.country.rawValue)
                  UserDefaults.standard.synchronize()
              }
          }
          
}
