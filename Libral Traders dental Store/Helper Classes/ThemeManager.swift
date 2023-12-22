import Foundation
import UIKit

class ThemeManager {
    
    static func applyTheme(bar: UINavigationBar) {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor.white
        UITabBar.appearance().barStyle = .default
        UISwitch.appearance().onTintColor =  AppStaticColors.primaryColor.withAlphaComponent(0.3)
        UISwitch.appearance().thumbTintColor =  AppStaticColors.primaryColor
         UITabBar.appearance().tintColor =   UIColor.red
       // UITabBar.appearance().tintColor =   AppStaticColors.primaryColor
        
        let backButton = UIImage(named: "backArrow")
        let backButtonImage = backButton?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 10)
        let backBarButtonApperance = UIBarButtonItem.appearance()
        backBarButtonApperance.setBackButtonBackgroundImage(backButtonImage, for: .normal, barMetrics: .default)
        
    }
    
}

struct AppStaticColors {
    static let labelSecondaryColor = UIColor.gray//UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.58 / 1.0)
    static var accentColor = UIColor(named: "AccentColor") ?? .black
    static var accentColorCode = "000000"
    static var primaryColor = UIColor().hexToColor(hexString: "bdf977")
    static var buttonTextColor = UIColor(named: "DefaultColor") ?? UIColor.white
    static var buttonBackGroundColor = UIColor(named: "AccentColor") ?? .black
    
    static var darkPrimaryColor = UIColor(named: "primary") ?? .black
    static var darkButtonTextColor = UIColor(named: "DefaultColor") ?? UIColor.black
    static var darkButtonBackGroundColor = UIColor(named: "AccentColor") ?? .white
    static var darkItemTintColor = UIColor(named: "itemTintColor") ?? UIColor.white
    static var systemGrayColor = UIColor(named: "systemGrayColor") ?? UIColor.gray
    static let priceOrangeColor = UIColor(named: "PriceOrangeColor")
    static let mainHeadingDarkBlack = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.87 / 1.0)
    static let linkColor = UIColor().hexToColor(hexString: "000000")
    static let shadedColor = UIColor(named: "ShadedColor")
    static var itemTintColor = UIColor(named: "itemTintColor") ?? UIColor.black
    static let defaultColor = UIColor(named: "DefaultColor") ?? UIColor.white
    static let disabledColor = UIColor(named: "DisabledColor") ?? UIColor.gray
    static let startEmptyColor = UIColor(named: "StartEmptyColor") ?? UIColor.gray
    
    static let oneStar = UIColor(named: "oneStar")!
    static let twoStar = UIColor(named: "twoStar")!
    static let threeStar = UIColor(named: "threeStar")!
    static let fourStar = UIColor(named: "fourStar")!
    static let fiveStar = UIColor(named: "fiveStar")!
    static let blackColor = UIColor(named: "blackcolor") ?? .black
    static func applyTheme() {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = AppStaticColors.primaryColor
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = AppStaticColors.primaryColor // Required background color
        }
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
            
        }
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0.0
        }
        UITabBar.appearance().tintColor = AppStaticColors.accentColor
        UITabBar.appearance().unselectedItemTintColor = AppStaticColors.disabledColor
        UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor

        UINavigationBar.appearance().tintColor = AppStaticColors.itemTintColor
        //UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: AppStaticColors.blackColor], for: .selected)
        UINavigationBar.appearance().isTranslucent = false

        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
        UISwitch.appearance().onTintColor = AppStaticColors.accentColor.withAlphaComponent(0.3)
        UISwitch.appearance().thumbTintColor =  AppStaticColors.accentColor
        UITableView.appearance().backgroundColor = AppStaticColors.defaultColor
        UITableViewCell.appearance().backgroundColor = AppStaticColors.defaultColor
        UICollectionView.appearance().backgroundColor = AppStaticColors.defaultColor
        UICollectionViewCell.appearance().backgroundColor = AppStaticColors.defaultColor
    }
}
