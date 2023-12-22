//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: LaunchHome.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit

class LaunchHome {
    private init() {}
    static let shared = LaunchHome()
    static var needAppRefresh = false
    
    func launchHome() {
        LaunchHome.needAppRefresh = true
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        rootviewcontroller.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rootLaunchController")
        let mainwindow = (UIApplication.shared.delegate?.window!)!
        mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
        UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionFlipFromLeft, animations: { () -> Void in
        })
    }
    func setView() {
        if Defaults.language == "ar" {
            L102Language.setAppleLAnguageTo(lang: "ar")
            if #available(iOS 9.0, *) {
                UINavigationBar.appearance().semanticContentAttribute = .forceRightToLeft
                UITabBar.appearance().semanticContentAttribute = .forceRightToLeft
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
                UITableView.appearance().semanticContentAttribute = .forceRightToLeft
                UITextField.appearance().semanticContentAttribute = .forceRightToLeft
            } else {
                // Fallback on earlier versions
            }
        } else {
            L102Language.setAppleLAnguageTo(lang: "en")
            if #available(iOS 9.0, *) {
                UINavigationBar.appearance().semanticContentAttribute = .forceLeftToRight
                UITabBar.appearance().semanticContentAttribute =  .forceLeftToRight
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
                UITableView.appearance().semanticContentAttribute = .forceLeftToRight
                UITextField.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                // Fallback on earlier versions
            }
        }
    }
    func launchHomeTabbar() {
        LaunchHome.needAppRefresh = true
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        rootviewcontroller.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rootnav")
        let mainwindow = (UIApplication.shared.delegate?.window!)!
        mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
//        UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionFlipFromLeft, animations: { () -> Void in
//        })
    }
}
