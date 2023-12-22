//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: HomeViewModel.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit
import Alamofire

class HomeViewModel: NSObject {
    
    var items = [HomeViewModelItem]()
    var featuredProductCollectionModel = [Products]()
    var letestProductCollectionModel = [Products]()
    var categories = [Categories]()
    var carouselObj = [Carousel]()
    var languageData = [Languages]()
    var homeViewController: ViewController!
    weak var homeTableviewheight: NSLayoutConstraint?
    weak var homeTableView: UITableView!
    var guestCheckOut: Bool!
    var categoryImage = [CategoryImages]()
    var storeData = [StoreData]()
    var cmsData = [CMSdata]()
    var websiteData = [WebsiteData]()
    var allowedCurrencies: [Currency]!
    weak var moveDelegate: MoveController?
    var themeCode = 0
    var applogo = ""
    var darkApplogo = ""

    func getDataFromDB(data: JSON, recentViewData: [Productcollection]?, completion:(_ data: Bool) -> Void) {
        guard let data = HomeModal(data: data) else {
            return
        }
        self.homeViewController.cartBtn.badgeNumber = Int(Defaults.cartBadge ?? "0") ?? 0
        items.removeAll()
        
        self.themeCode = data.themeCode
        self.applogo = data.applogo
        self.darkApplogo = data.darkApplogo
        self.homeViewController.addLogoToNavigationBarItem()
        
        if self.themeCode == 1 {
            if data.sortDatByPostion.count > 0 {
                for m in 0..<data.sortDatByPostion.count {
                    if data.sortDatByPostion[m].layout_id == "bannerimage" {
                        if let bannerImage = data.bannerImages, bannerImage.count>0 {
                            let bannerDataCollectionItem = HomeViewModelBannerItem(categories: bannerImage)
                            items.append(bannerDataCollectionItem)
                        }
                    }
                    if data.sortDatByPostion[m].layout_id == "featuredcategories" {
                        if let featuredCategoryData = data.featuredCategories,  featuredCategoryData.count > 0 {
                            let featureCategoryCollectionItem = HomeViewModelFeatureCategoriesItem(categories: data.featuredCategories)
                            items.append(featureCategoryCollectionItem)
                        }
                    }
                    if let carouselItems = data.carousel, carouselItems.count>0 {
                        for i in 0 ..< carouselItems.count {
                            if data.sortDatByPostion[m].layout_id == carouselItems[i].id {
                                let carouselCollectionItem = HomeViewModelCarouselItem(categories: [carouselItems[i]])
                                items.append(carouselCollectionItem)
                            }
                        }
                    }
                }
            } else {
                if let bannerImage = data.bannerImages, bannerImage.count>0 {
                    let bannerDataCollectionItem = HomeViewModelBannerItem(categories: bannerImage)
                    items.append(bannerDataCollectionItem)
                }
                
                if let featuredCategoryData = data.featuredCategories,  featuredCategoryData.count > 0 {
                    let featureCategoryCollectionItem = HomeViewModelFeatureCategoriesItem(categories: data.featuredCategories)
                    items.append(featureCategoryCollectionItem)
                }
                
                if let carouselItems = data.carousel, carouselItems.count>0 {
                    for i in 0 ..< carouselItems.count {
                        let carouselCollectionItem = HomeViewModelCarouselItem(categories: [carouselItems[i]])
                        items.append(carouselCollectionItem)
                    }
                }
            }
        } else {
            
            if data.sortDatByPostion.count > 0 {
                for m in 0..<data.sortDatByPostion.count {
                    if data.sortDatByPostion[m].layout_id == "featuredcategories" {
                        if let featuredCategoryData = data.featuredCategories,  featuredCategoryData.count > 0 {
                            let featureCategoryCollectionItem = HomeViewModelFeatureCategoriesItem(categories: data.featuredCategories)
                            items.append(featureCategoryCollectionItem)
                        }
                    }
                    if data.sortDatByPostion[m].layout_id == "bannerimage" {
                        if let bannerImage = data.bannerImages, bannerImage.count>0 {
                            let bannerDataCollectionItem = HomeViewModelBannerItem(categories: bannerImage)
                            items.append(bannerDataCollectionItem)
                        }
                    }
                    
                    if let carouselItems = data.carousel, carouselItems.count>0 {
                        for i in 0 ..< carouselItems.count {
                            if data.sortDatByPostion[m].layout_id == carouselItems[i].id {
                                let carouselCollectionItem = HomeViewModelCarouselItem(categories: [carouselItems[i]])
                                items.append(carouselCollectionItem)
                            }
                        }
                    }
                }
            } else {
                if let featuredCategoryData = data.featuredCategories,  featuredCategoryData.count > 0 {
                    let featureCategoryCollectionItem = HomeViewModelFeatureCategoriesItem(categories: data.featuredCategories)
                    items.append(featureCategoryCollectionItem)
                }
                
                if let bannerImage = data.bannerImages, bannerImage.count>0 {
                    let bannerDataCollectionItem = HomeViewModelBannerItem(categories: bannerImage)
                    items.append(bannerDataCollectionItem)
                }
                
                if let carouselItems = data.carousel, carouselItems.count>0 {
                    for i in 0 ..< carouselItems.count {
                        let carouselCollectionItem = HomeViewModelCarouselItem(categories: [carouselItems[i]])
                        items.append(carouselCollectionItem)
                    }
                }
                
            }
        }
        if data.storeData.count > 0 {
            self.storeData = data.storeData
        }
        
        if data.websiteData.count > 0 {
            self.websiteData = data.websiteData
        }
        if data.cmsData != nil {
        self.cmsData = data.cmsData
        }
        if data.allowedCurrencies != nil {
            self.allowedCurrencies = data.allowedCurrencies

        }
        
        if data.categories != nil {
            self.categories = data.categories
        }
        
        if data.categoryImages != nil {
            self.categoryImage = data.categoryImages
        }
        
        completion(true)
        
    }
    
    func getData(jsonData: JSON, recentViewData: [Productcollection]?, completion:(_ data: Bool) -> Void) {
        guard let data = HomeModal(data: jsonData) else {
            return
        }
        items.removeAll()
        self.themeCode = data.themeCode
        self.applogo = data.applogo
        self.darkApplogo = data.darkApplogo
        self.homeViewController.addLogoToNavigationBarItem()
        self.homeViewController.cartBtn.badgeNumber = Int(Defaults.cartBadge ?? "0") ?? 0
        print(data.sortDatByPostion)
        if self.themeCode == 1 {
            if data.sortDatByPostion.count > 0 {
                for m in 0..<data.sortDatByPostion.count {
                    if data.sortDatByPostion[m].layout_id == "bannerimage" {
                        if let bannerImage = data.bannerImages, bannerImage.count>0 {
                            let bannerDataCollectionItem = HomeViewModelBannerItem(categories: bannerImage)
                            items.append(bannerDataCollectionItem)
                        }
                    }
                    
                    if data.sortDatByPostion[m].layout_id == "featuredcategories" {
                        if let featuredCategoryData = data.featuredCategories,  featuredCategoryData.count > 0 {
                            let featureCategoryCollectionItem = HomeViewModelFeatureCategoriesItem(categories: data.featuredCategories)
                            items.append(featureCategoryCollectionItem)
                        }
                    }
                    if let carouselItems = data.carousel, carouselItems.count>0 {
                        for i in 0 ..< carouselItems.count {
                            if data.sortDatByPostion[m].layout_id == carouselItems[i].id {
                                let carouselCollectionItem = HomeViewModelCarouselItem(categories: [carouselItems[i]])
                                items.append(carouselCollectionItem)
                            }
                        }
                    }
                }
                if Defaults.searchEnable == "1" {
                    if let recentViewData = recentViewData, recentViewData.count > 0 {
                        let recents = HomeViewModelRecentViewItem(categories: recentViewData)
                        items.append(recents)
                    }
                }
            } else {
                if let bannerImage = data.bannerImages, bannerImage.count>0 {
                    let bannerDataCollectionItem = HomeViewModelBannerItem(categories: bannerImage)
                    items.append(bannerDataCollectionItem)
                }
                if let featuredCategoryData = data.featuredCategories,  featuredCategoryData.count > 0 {
                    let featureCategoryCollectionItem = HomeViewModelFeatureCategoriesItem(categories: data.featuredCategories)
                    items.append(featureCategoryCollectionItem)
                }
                if let carouselItems = data.carousel, carouselItems.count>0 {
                    for i in 0 ..< carouselItems.count {
                        let carouselCollectionItem = HomeViewModelCarouselItem(categories: [carouselItems[i]])
                        items.append(carouselCollectionItem)
                        
                    }
                }
                if Defaults.searchEnable == "1" {
                    if let recentViewData = recentViewData, recentViewData.count > 0 {
                        let recents = HomeViewModelRecentViewItem(categories: recentViewData)
                        items.append(recents)
                    }
                }
            }
            print(items)
        } else {
            if data.sortDatByPostion.count > 0 {
                for m in 0..<data.sortDatByPostion.count {
                    if data.sortDatByPostion[m].layout_id == "featuredcategories" {
                        if let featuredCategoryData = data.featuredCategories,  featuredCategoryData.count > 0 {
                            let featureCategoryCollectionItem = HomeViewModelFeatureCategoriesItem(categories: data.featuredCategories)
                            items.append(featureCategoryCollectionItem)
                        }
                    }
                    
                    if let carouselItems = data.carousel, carouselItems.count>0 {
                        for i in 0 ..< carouselItems.count {
                            if data.sortDatByPostion[m].layout_id == carouselItems[i].id {
                                let carouselCollectionItem = HomeViewModelCarouselItem(categories: [carouselItems[i]])
                                items.append(carouselCollectionItem)
                            }
                        }
                    }
                    if data.sortDatByPostion[m].layout_id == "bannerimage" {
                        if let bannerImage = data.bannerImages, bannerImage.count>0 {
                            let bannerDataCollectionItem = HomeViewModelBannerItem(categories: bannerImage)
                            items.append(bannerDataCollectionItem)
                        }
                    }
                }
                if Defaults.searchEnable == "1" {
                    if let recentViewData = recentViewData, recentViewData.count > 0 {
                        let recents = HomeViewModelRecentViewItem(categories: recentViewData)
                        items.append(recents)
                    }
                }
            } else {
                if let featuredCategoryData = data.featuredCategories,  featuredCategoryData.count > 0 {
                    let featureCategoryCollectionItem = HomeViewModelFeatureCategoriesItem(categories: data.featuredCategories)
                    items.append(featureCategoryCollectionItem)
                }
                if let carouselItems = data.carousel, carouselItems.count>0 {
                    for i in 0 ..< carouselItems.count {
                        
                        let carouselCollectionItem = HomeViewModelCarouselItem(categories: [carouselItems[i]])
                        items.append(carouselCollectionItem)
                        
                    }
                }
                
                if let bannerImage = data.bannerImages, bannerImage.count>0 {
                    let bannerDataCollectionItem = HomeViewModelBannerItem(categories: bannerImage)
                    items.append(bannerDataCollectionItem)
                }
                if Defaults.searchEnable == "1" {
                    if let recentViewData = recentViewData, recentViewData.count > 0 {
                        let recents = HomeViewModelRecentViewItem(categories: recentViewData)
                        items.append(recents)
                    }
                }
            }
            print(items)
        }
        
        if data.categories != nil {
            self.categories = data.categories
        }
        if data.websiteData.count > 0 {
            self.websiteData = data.websiteData
        }
        if data.allowedCurrencies != nil {
        self.allowedCurrencies = data.allowedCurrencies
        }
        if data.storeData.count > 0 {
            self.storeData = data.storeData
        }
        
        if data.categoryImages != nil {
            self.categoryImage = data.categoryImages
        }
        if data.cmsData != nil {
        self.cmsData = data.cmsData
        }
        
        completion(true)
    }
    
    func updateRecentlyViewed(recentViewData: [Productcollection]?, completion:(_ section: Int?) -> Void) {
        var haveRecentObject = false
        if let recentViewData = recentViewData, recentViewData.count > 0 {
            for item in items where item.type == .recentViewData {
                haveRecentObject = true
                if let item = item as? HomeViewModelRecentViewItem {
                    item.recentViewProductData = recentViewData
                }
                if let index = items.firstIndex(where: {$0.type == item.type}) {
                    completion(index)
                }
            }
            if !haveRecentObject {
                let recents = HomeViewModelRecentViewItem(categories: recentViewData)
                items.append(recents)
                completion(nil)
            }
        }
    }
    
    func setWishListFlagToFeaturedProductModel(data: Bool, pos: Int) {
        featuredProductCollectionModel[pos].isInWishList = data
    }
    
    func setWishListItemIdToFeaturedProductModel(data: String, pos: Int) {
        featuredProductCollectionModel[pos].wishlistItemId = data
    }
    
    func setWishListFlagToLatestProductModel(data: Bool, pos: Int) {
        letestProductCollectionModel[pos].isInWishList = data
    }
    
    func setWishListItemIdToLatestProductModel(data: String, pos: Int) {
        letestProductCollectionModel[pos].wishlistItemId = data
    }
}

extension HomeViewModel: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(tableView.contentSize.height)
        let item = items[section]
        switch item.type {
        case .carousel:
            return 1
        default:
            return 1
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrool1",scrollView.contentSize,scrollView.contentSize.height)
       
        if scrollView.contentSize.height >= (AppDimensions.screenHeight * 1.3 ) {
            self.homeViewController.historyToolBarView?.isHidden = false
            self.homeViewController.historyToolBarView?.bottomLabelMessage.isHidden = false
            self.homeViewController.historyToolBarView?.backToTopButton.isHidden = false
        } else {
            self.homeViewController.historyToolBarView?.isHidden = true
            self.homeViewController.historyToolBarView?.bottomLabelMessage.isHidden = true
            self.homeViewController.historyToolBarView?.backToTopButton.isHidden = true

        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        switch item.type {
        case .banner:
            if self.themeCode == 1 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: SliderTableViewCell.identifier) as? SliderTableViewCell {
                    cell.selectionStyle = .none
                    cell.bannerCollectionModel = ((item as? HomeViewModelBannerItem)?.bannerCollectionModel)!
                    cell.sliderCollectionView.reloadData()
                    return cell
                }
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: BannerTableViewCell.identifier) as? BannerTableViewCell {
                    cell.selectionStyle = .none
                    cell.bannerCollectionModel = ((item as? HomeViewModelBannerItem)?.bannerCollectionModel)!
                    cell.textTitleLabel.text = "Offers for you".localized.uppercased()
                    cell.frame = tableView.bounds
                    cell.layoutIfNeeded()
                    cell.bannerCollectionView.reloadData()
                    cell.bannerCollectionViewHeight.constant = cell.bannerCollectionView.collectionViewLayout.collectionViewContentSize.height
                    return cell
                }
            }
        case .featureCategory:
            if let cell = tableView.dequeueReusableCell(withIdentifier: TopCategoryTableViewCell.identifier) as? TopCategoryTableViewCell {
                cell.featureCategoryCollectionModel = ((item as? HomeViewModelFeatureCategoriesItem)?.featureCategories)!
                cell.themeCode = self.themeCode
                cell.selectionStyle = .none
                cell.delegate = homeViewController
                cell.categoryCollectionView.reloadData()
                cell.cellUpdate()
                return cell
            }
        case .recentViewData:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentHorizontalTableViewCell.identifier) as? RecentHorizontalTableViewCell,
                let carouselItem = (item as? HomeViewModelRecentViewItem) else { return UITableViewCell() }
            let unavailableProducts = carouselItem.recentViewProductData.filter { ($0.isAvailable == "0") }
            carouselItem.recentViewProductData.removeAll { ($0.isAvailable == "0") }
            carouselItem.recentViewProductData.append(contentsOf: unavailableProducts)
            cell.obj = self
            cell.selectionStyle = .none
            cell.products =  carouselItem.recentViewProductData
            cell.delegate = homeViewController
            //cell.productCollectionView.reloadData()
            return cell
        case .carousel:
            let carouselItem = ((item as? HomeViewModelCarouselItem)?.carouselCollectionModel)![indexPath.row]
            print("layoutType: ", carouselItem.layoutType as Any)
            let unavailableProducts = carouselItem.productList.filter { !$0.isAvailable! }
            carouselItem.productList.removeAll { !$0.isAvailable! }
            carouselItem.productList.append(contentsOf: unavailableProducts)
            if carouselItem.type == CarouselType.product.rawValue {
                if carouselItem.layoutType == 1 {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier) as? ProductTableViewCell else { return UITableViewCell() }
                    cell.obj = self
                    cell.selectionStyle = .none
                    cell.carouselCollectionModel = carouselItem
                    if carouselItem.productList.count > 1 {
                        cell.viewAllButton.isHidden = false
                        cell.buttonHeight.constant = 48
                    } else {
                        cell.viewAllButton.isHidden = true
                        cell.buttonHeight.constant = 0
                    }
                    if carouselItem.image.isEmpty {
                        cell.backGroundImage.isHidden = true
                    } else {
                        cell.backGroundImage.setImage(fromURL: carouselItem.image)
                        cell.backGroundImage.isHidden = false
                    }
                    cell.delegate = homeViewController
                    cell.titleLabel.text = carouselItem.label!.uppercased()
                    self.homeTableviewheight?.constant = tableView.contentSize.height
                    cell.frame = tableView.bounds
                    cell.layoutIfNeeded()
                    //cell.productCollectionView.reloadData()
                    cell.collectionViewheight.constant = cell.productCollectionView.collectionViewLayout.collectionViewContentSize.height
                    cell.viewAllButton.setTitle("viewall".localized.uppercased() + " " + carouselItem.label!.uppercased(), for: .normal)
                    cell.theme()
                    return cell
                } else if carouselItem.layoutType == 2 {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCellLayout2.identifier) as? ProductTableViewCellLayout2 else { return UITableViewCell() }
                    cell.obj = self
                    cell.selectionStyle = .none
                    cell.titleNameLabel.text = carouselItem.label!.uppercased()
                    cell.carouselCollectionModel = carouselItem
                    if carouselItem.productList.count > 1 {
                        cell.viewAllButton.isHidden = false
                    } else {
                        cell.viewAllButton.isHidden = true
                    }
                    if carouselItem.image.isEmpty {
                        cell.backGroundImage.isHidden = true
                    } else {
                        cell.backGroundImage.setImage(fromURL: carouselItem.image)
                        cell.backGroundImage.isHidden = false
                    }
                    cell.delegate = homeViewController
                    cell.frame = tableView.bounds
                    cell.layoutIfNeeded()
                    //cell.productCollectionView.reloadData()
                    cell.productCollectionVwHeight.constant = cell.productCollectionView.collectionViewLayout.collectionViewContentSize.height
                    
                    return cell
                } else if carouselItem.layoutType == 3 {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCellLayout3.identifier) as? ProductTableViewCellLayout3 else { return UITableViewCell() }
                    cell.obj = self
                    cell.selectionStyle = .none
                    cell.titleNameLabel.text = carouselItem.label!.uppercased()
                    cell.carouselCollectionModel = carouselItem
                    if carouselItem.productList.count > 1 {
                        cell.viewAllButton.isHidden = false
                    } else {
                        cell.viewAllButton.isHidden = true
                    }
                    if carouselItem.image.isEmpty {
                        cell.backGroundImage.isHidden = true
                    } else {
                        cell.backGroundImage.setImage(fromURL: carouselItem.image)
                        cell.backGroundImage.isHidden = false
                    }
                    cell.delegate = homeViewController
                    
                    //cell.productCollectionView.reloadData()
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCellLayout4.identifier) as? ProductTableViewCellLayout4 else { return UITableViewCell() }
                    cell.obj = self
                    cell.selectionStyle = .none
                    cell.titleNameLabel.text = carouselItem.label!.uppercased()
                    cell.carouselCollectionModel = carouselItem
                    if carouselItem.image.isEmpty {
                        cell.backGroundImage.isHidden = true
                    } else {
                        cell.backGroundImage.setImage(fromURL: carouselItem.image)
                        cell.backGroundImage.isHidden = false
                    }
                    if carouselItem.productList.count > 1 {
                        cell.viewAllButton.isHidden = false
                    } else {
                        cell.viewAllButton.isHidden = true
                    }
                    cell.delegate = homeViewController
                    
                    //cell.productCollectionView.reloadData()
                    return cell
                }
            } else if carouselItem.type == CarouselType.image.rawValue {
                if let cell = tableView.dequeueReusableCell(withIdentifier: ImageCarouselTableViewCell.identifier) as? ImageCarouselTableViewCell {
                    cell.imageCarouselCollectionModel = carouselItem.banners
                    cell.titleTextlabel.text = carouselItem.label!.uppercased()
                    cell.selectionStyle = .none
                    if carouselItem.image.isEmpty {
                        cell.backGroundImage.isHidden = true
                    } else {
                        cell.backGroundImage.setImage(fromURL: carouselItem.image)
                        cell.backGroundImage.isHidden = false
                    }
                    cell.imageCarouselCollectionView.reloadData()
                    self.homeTableviewheight?.constant = tableView.contentSize.height
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = items[indexPath.section]
        switch item.type {
        case .banner:
            return UITableView.automaticDimension
        case .featureCategory:
            //return 200
            if let item = item as? HomeViewModelFeatureCategoriesItem, self.themeCode == 1 {
                if CGFloat(item.featureCategories.count * 90) > 1.5 * AppDimensions.screenWidth {
                    return 280
                } else {
                    return 150 
                }
            }
            return 200 + 40
        case .recentViewData:
            return UITableView.automaticDimension
        case .carousel:
            let carouselItem = ((item as? HomeViewModelCarouselItem)?.carouselCollectionModel)![indexPath.row]
            if carouselItem.type == CarouselType.product.rawValue {
                return UITableView.automaticDimension
            } else if carouselItem.type == CarouselType.image.rawValue {
                return 2*AppDimensions.screenWidth/3 + 41
            }
        }
        return 0
    }
}

extension HomeViewModel {
    
    func callingHttppApi(productId: String, apiType: String,productName:String, completion: @escaping (Bool, JSON) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        var apiName: WhichApiCall = .addToWishList
        var verbs: HTTPMethod = .post
        if apiType == "delete" {
            verbs = .delete
            apiName = .removeFromWishList
            requstParams["itemId"] = productId
        } else {
            verbs = .post
            requstParams["productId"] = productId
        }
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: verbs, apiname: apiName, currentView: UIViewController()) { [weak self] success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            if success == 1 {                
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                if jsonResponse["success"].boolValue == true {
                   
                    self?.doFurtherProcessingWithResult(data: jsonResponse) { success in
                        completion(success, jsonResponse)
                    }
                } else {
                    if jsonResponse["message"].stringValue.removeWhiteSpace.count > 0 {
                        ShowNotificationMessages.sharedInstance.warningView(message: jsonResponse["message"].stringValue)
                    } else {
                        ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
                    }
                    completion(false, JSON.null)
                }
            } else if success == 2 {   // Retry in case of error
                NetworkManager.sharedInstance.dismissLoader()
                self?.callingHttppApi(productId: productId, apiType: apiType, productName: productName) {success,jsonResponse  in
                    completion(success, jsonResponse)
                }
            }
        }
    }
    
    func doFurtherProcessingWithResult(data: JSON, completion: (Bool) -> Void) {
        if data["success"].boolValue {
            let message = data["message"].stringValue.count > 0 ?  data["message"].stringValue : "Product added to wishlist".localized
            ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: message )
        } else {
            ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
        }
        completion(true)
    }
}

class DynamicHeightCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size,self.intrinsicContentSize){
            self.invalidateIntrinsicContentSize()
        }
    }
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}

