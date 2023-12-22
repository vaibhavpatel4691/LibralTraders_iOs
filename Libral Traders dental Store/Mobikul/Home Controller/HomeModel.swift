import Foundation
import UIKit

enum CarouselType: String {
    case product = "product"
    case image = "image"
}

struct Currency {
    var code: String!
    var label: String!
    
    init(data: JSON) {
        self.code = data["code"].stringValue
        self.label = data["label"].stringValue
    }
}

struct HomeModal {
    var recentViewData = [Productcollection]()
    var storeData = [StoreData]()
    var websiteData = [WebsiteData]()
    var categoryImages: [CategoryImages]!
    var defaultCurrency: String!
    var wishlistEnable: Bool! = false
    var showSwatchOnCollection: Bool! = false
    var carousel: [Carousel]!
    var priceFormat: PriceFormat!
    var eTag: String!
    var success: Bool! = false
    var bannerImages: [BannerImages]!
    var featuredCategories: [FeaturedCategories]!
    var categories: [Categories]!
    var message: String!
    var allowedCurrencies: [Currency]!
    var cmsData: [CMSdata]!
    var themeCode = 0
    var sortOrderData = [SortOrder]()
    var applogo = ""
    var darkApplogo = ""
    var sortDatByPostion = [SortOrderByPostion]()
    var walkThroughNewVersion = 1.0
    init?(data: JSON) {
        NetworkManager.AddonsChecks(data: data)
        if let arrayValue = data["sort_order"].array {
            self.sortOrderData = arrayValue.map({ (dataValue) -> SortOrder in
                return SortOrder(data: dataValue)
            })
        }
        //walkThrough
        walkThroughNewVersion = data["walkthroughVersion"].doubleValue.round(to: 2)
        print(data["walkthroughVersion"].doubleValue, walkThroughNewVersion)
        if walkThroughNewVersion > 1.0 {
        print(data["walkthroughVersion"].doubleValue, walkThroughNewVersion)
        if (Defaults.walkthroughShow) == true {
            if (walkThroughNewVersion == (Defaults.walkThroughVersion)) {
                Defaults.walkthroughShow = false
            } else {
                if (Defaults.walkThroughVersion ?? 0.0) < (walkThroughNewVersion) {
                    Defaults.walkthroughShow = true
                } else {
                    Defaults.walkthroughShow = false
                }
            }
            Defaults.walkThroughVersion = walkThroughNewVersion
        } else if (Defaults.walkthroughShow) == false {
            if (Defaults.walkThroughVersion) == nil && (walkThroughNewVersion != 0.0){
                 Defaults.walkThroughVersion = walkThroughNewVersion
                 Defaults.walkthroughShow = true
            } else if (Defaults.walkThroughVersion) == 0.0 && (walkThroughNewVersion != 0.0){
                 Defaults.walkThroughVersion = walkThroughNewVersion
                 Defaults.walkthroughShow = true
            } else if (Defaults.walkThroughVersion) == (walkThroughNewVersion){
                 Defaults.walkthroughShow = false
            } else if (Defaults.walkThroughVersion ?? 0.0) < (walkThroughNewVersion) {
                Defaults.walkthroughShow = true
            } else  {
                 Defaults.walkthroughShow = false
            }
            Defaults.walkThroughVersion = walkThroughNewVersion
        }
        } else {
            Defaults.walkthroughShow = false
            if walkThroughNewVersion != 0.0 {
                Defaults.walkThroughVersion = walkThroughNewVersion
            } else {
                Defaults.walkThroughVersion = 1.0
            }
            
        }
        #if BTOB
        
        #else
        if data["splashImage"] != JSON.null {
            Defaults.lightSplashScreen = data["splashImage"].stringValue
        }
        if data["darkSplashImage"] != JSON.null {
            Defaults.darkSplashScreen = data["darkSplashImage"].stringValue
        }
        //MARK:- Light theme
        applogo = data["appLogo"].string ?? data["lightAppLogo"].stringValue
        if let appThemeColor = data["lightAppThemeColor"].string{
            AppStaticColors.primaryColor = UIColor().hexToColor(hexString: appThemeColor)
            UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
        }
        if let appThemeColor = data["appThemeColor"].string{
            AppStaticColors.primaryColor = UIColor().hexToColor(hexString: appThemeColor)
            UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
        }
        if let buttonTextColor = data["lightButtonTextColor"].string{
            AppStaticColors.buttonTextColor = UIColor().hexToColor(hexString: buttonTextColor)
        }
        if let buttonTextColor = data["buttonTextColor"].string{
            AppStaticColors.buttonTextColor = UIColor().hexToColor(hexString: buttonTextColor)
        }
        if let appButtonColor = data["lightAppButtonColor"].string{
            AppStaticColors.buttonBackGroundColor = UIColor().hexToColor(hexString: appButtonColor)
        }
        if let appButtonColor = data["appButtonColor"].string{
            AppStaticColors.buttonBackGroundColor = UIColor().hexToColor(hexString: appButtonColor)
        }
        if let appThemeTextColor = data["lightAppThemeTextColor"].string{
            AppStaticColors.itemTintColor = UIColor().hexToColor(hexString: appThemeTextColor)
            UINavigationBar.appearance().tintColor = AppStaticColors.itemTintColor
        }
        
        if let appThemeTextColor = data["appThemeTextColor"].string{
            AppStaticColors.itemTintColor = UIColor().hexToColor(hexString: appThemeTextColor)
            UINavigationBar.appearance().tintColor = AppStaticColors.itemTintColor
        }
        
        //MARK:- dark theme
        
        darkApplogo = data["darkAppLogo"].stringValue
        if let appThemeColor = data["darkAppThemeColor"].string{
            AppStaticColors.darkPrimaryColor = UIColor().hexToColor(hexString: appThemeColor)
            UINavigationBar.appearance().barTintColor = AppStaticColors.darkPrimaryColor
        }
        if let buttonTextColor = data["darkButtonTextColor"].string{
            AppStaticColors.darkButtonTextColor = UIColor().hexToColor(hexString: buttonTextColor)
        }
        if let appButtonColor = data["darkAppButtonColor"].string{
            AppStaticColors.darkButtonBackGroundColor = UIColor().hexToColor(hexString: appButtonColor)
        }
        if let appThemeTextColor = data["darkAppThemeTextColor"].string{
            AppStaticColors.darkItemTintColor = UIColor().hexToColor(hexString: appThemeTextColor)
            UINavigationBar.appearance().tintColor = AppStaticColors.darkItemTintColor
        }
        
        #endif
        //
        //
        //UITabBar.appearance().barTintColor = AppStaticColors.primaryColor
        UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
        //UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: AppStaticColors.primaryColor], for: .selected)
        Defaults.cartBadge = data["cartCount"].stringValue
        categoryLayoutMode = data["tabCategoryView"].intValue
        themeCode = Int(data["themeType"].stringValue) ?? 0
        if let storeDataObj = data["storeData"].arrayObject {
            storeData = storeDataObj.map({ (value) -> StoreData in
                return StoreData(json: JSON(value))
            })
        }
        for i in 0..<sortOrderData.count {
            if let arr = sortOrderData[i].position {
                for j in 0..<arr.count {
                    self.sortDatByPostion.append(SortOrderByPostion(id:
                        sortOrderData[i].id ?? "", layout_id: sortOrderData[i].layout_id ?? "", label: sortOrderData[i].label ?? "", position: sortOrderData[i].position?[j] ?? "", type: sortOrderData[i].type ?? ""))
                }
            }
        }
        
        // Updated code:
        // Change the last position in the first number and after same.
//        let lastBanner = sortDatByPostion.removeLast()
//        sortDatByPostion.insert(lastBanner, at: 0)
        
        let last = sortDatByPostion.filter { $0.type == "banner" }
        sortDatByPostion.removeAll { $0.type == "banner" }
        sortDatByPostion.insert(contentsOf: last, at: 0)
        
        if let storeDataObj = data["websiteData"].arrayObject {
            websiteData = storeDataObj.map({ (value) -> WebsiteData in
                return WebsiteData(json: JSON(value))
            })
        }
        if let storeDataObj = data["websiteData"].arrayObject {
            GlobalVariables.websiteDataAddProducts = storeDataObj.map({ (value) -> WebsiteData in
                return WebsiteData(json: JSON(value))
            })
        }
        
        if let categoryImagesObj = data["categoryImages"].arrayObject {
            categoryImages = categoryImagesObj.map({ (value) -> CategoryImages in
                return CategoryImages(json: JSON(value))
            })
        }
       // self.sortDatByPostion = self.sortDatByPostion.sorted(by: { $0.position < $1.position })
//        if self.sortDatByPostion.count >= 2 {
//            self.sortDatByPostion.swapAt(0, self.sortDatByPostion.count - 1)
//        }
        
        
        defaultCurrency = data["defaultCurrency"].stringValue
        
        wishlistEnable = data["wishlistEnable"].boolValue
        
        showSwatchOnCollection = data["showSwatchOnCollection"].boolValue
        
        if let carouselObj = data["carousel"].arrayObject {
            carousel = carouselObj.map({ (value) -> Carousel in
                return Carousel(json: JSON(value))
            })
        }
        
        priceFormat = PriceFormat(json: data["priceFormat"])
        
        eTag = data["eTag"].stringValue
        
        success = data["success"].boolValue
        
        if let bannerImagesObj = data["bannerImages"].arrayObject, bannerImagesObj.count > 0 {
            bannerImages = bannerImagesObj.map({ (value) -> BannerImages in
                return BannerImages(json: JSON(value))
            })
        }
        
        if let featuredCategoriesObj = data["featuredCategories"].arrayObject {
            featuredCategories = featuredCategoriesObj.map({ (value) -> FeaturedCategories in
                return FeaturedCategories(json: JSON(value))
            })
        }
        
        if let categoriesObj = data["categories"].array {
            categories = categoriesObj.map({ (value) -> Categories in
                return Categories(json: value)
            })
        }
        
        message = data["message"].stringValue
        
        if let cmsObj = data["cmsData"].arrayObject {
            cmsData = cmsObj.map({ (value) -> CMSdata in
                return CMSdata(data: JSON(value))
            })
        }
        
        if let items = data["allowedCurrencies"].array {
            allowedCurrencies = items.map({ (value) -> Currency in
                return Currency(data: value)
            })
        }
        
    }
}

public class BannerData {
    var bannerType: String!
    var imageUrl: String!
    var bannerId: String!
    var bannerName: String!
    var productId: String!
    var productName: String!
    
    init(data: JSON) {
        bannerType = data["bannerType"].stringValue
        imageUrl  = data["url"].stringValue
        bannerId = data["categoryId"].stringValue
        bannerName = data["categoryName"].stringValue
        productId = data["productId"].stringValue
        productName = data["productName"].stringValue
    }
    
}

class FeatureCategories {
    var categoryID: String = ""
    var categoryName: String = ""
    var imageUrl: String = ""
    
    init(data: JSON) {
        self.categoryID = data["categoryId"].stringValue
        self.categoryName = data["categoryName"].stringValue
        self.imageUrl = data["url"].stringValue
    }
}

struct Products {
    var hasOption: Int!
    var name: String!
    var price: String!
    var productID: String!
    var showSpecialPrice: String!
    var image: String!
    var isInRange: Int!
    var isInWishList: Bool!
    var originalPrice: Double!
    var specialPrice: Double!
    var formatedPrice: String!
    var typeID: String!
    var groupedPrice: String!
    var formatedMinPrice: String!
    var formatedMaxPrice: String!
    var wishlistItemId: String!
    
    init(data: JSON) {
        self.hasOption = data["hasOption"].intValue
        self.name = data["name"].stringValue
        self.price = data["formatedFinalPrice"].stringValue
        self.productID = data["entityId"].stringValue
        self.showSpecialPrice = data["formatedFinalPrice"].stringValue
        self.image = data["thumbNail"].stringValue
        self.originalPrice =  data["price"].doubleValue
        self.specialPrice = data["finalPrice"].doubleValue
        self.isInRange = data["isInRange"].intValue
        self.isInWishList = data["isInWishlist"].boolValue
        self.formatedPrice = data["formatedPrice"].stringValue
        self.typeID = data["typeId"].stringValue
        self.groupedPrice = data["groupedPrice"].stringValue
        self.formatedMaxPrice = data["formatedMaxPrice"].stringValue
        self.formatedMinPrice = data["formatedMinPrice"].stringValue
        self.wishlistItemId = data["wishlistItemId"].stringValue
    }
}

struct Languages {
    var code: String!
    var name: String!
    var id: String!
    
    init(data: JSON) {
        self.code = data["code"].stringValue
        self.name = data["name"].stringValue
        self.id = data["id"].stringValue
    }
}

class CMSdata {
    var id: String!
    var title: String!
    
    init(data: JSON) {
        self.id = data["id"].stringValue
        self.title = data["title"].stringValue
    }
}

struct SortOrder {
    var id: String?
    var layout_id: String?
    var label: String?
    var type: String?
    var position: [String]?
     
    init(data: JSON) {
        id = data["id"].stringValue
        layout_id = data["layout_id"].string ?? data["id"].stringValue
        label = data["label"].stringValue
        type = data["type"].stringValue
        if ((data["position"].stringValue).last) == "," {
             position = ((data["position"].stringValue).dropLast()).components(separatedBy: ",")
        } else {
             position = ((data["position"].stringValue)).components(separatedBy: ",")
        }
       
    }
}
struct SortOrderByPostion {
    var id: String?
    var layout_id: String?
    var label: String?
    var position: Int!
    var type: String?
     
    init(id: String, layout_id: String, label: String, position: String, type: String) {
        self.id = id
        self.layout_id = layout_id
        self.label = label
        self.position = Int(position)
        self.type = type
    }
}

struct WalkthroughData {
    var id: String?
    var title: String?
    var description: String?
    var image: String?
    var colorCode: String?
    var sortOrder: String?
    var status: String?
    var firstIndex = 0
    var imageDominantColor: String?
    init(data: JSON) {
        id = data["id"].stringValue
        imageDominantColor = data["imageDominantColor"].stringValue
        title = data["title"].stringValue
        description = data["content"].stringValue
        image = data["image"].stringValue
        colorCode = data["colorCode"].stringValue
        sortOrder = data["sortOrder"].stringValue
        status = data["status"].stringValue
    }

}
extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
