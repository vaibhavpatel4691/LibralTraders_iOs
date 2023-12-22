//
/**
* Webkul Software.
* @package  Mobikul Single App
* @Category Webkul
* @author Webkul <support@webkul.com>
* FileName: CategoryListViewModel.swift
* @Copyright (c) 2010-2019 Webkul Software Private Limited (https://webkul.com)
* @license https://store.webkul.com/license.html ASL Licence
* @link https://store.webkul.com/license.html

*/


import Foundation
extension CategoriesViewController {
    
func callingHttppApi(completion: @escaping (Bool) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        
        requstParams["categoryId"] = selectedMAinCategory
        
        requstParams["eTag"] = DBManager.sharedInstance.geteTagFromDataBase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "subCategoryData"))
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .get, apiname: .subCategoryData, currentView: UIViewController()) { [weak self]
            success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            if success == 1 {
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                if jsonResponse["success"].boolValue == true {
                    if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]) {
                        DBManager.sharedInstance.storeDataToDataBase(data: data, eTag: jsonResponse["eTag"].stringValue, hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "subCategoryData"))
                    }
                    
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
            } else if success == 3 {   // No Changes
                let jsonResponse =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "subCategoryData"))
                self?.doFurtherProcessingWithResult(data: jsonResponse) { success in
                    completion(success)
                }
                
            }
        }
    }
    
    func doFurtherProcessingWithResult(data: JSON, completion: (Bool) -> Void) {
        model = SubCategoryModel(json: data)
        items.removeAll()
        #if  B2B || HYPERLOCAL || GROCERY || MARKETPLACE
        if model.bannerImage.count > 0 {
            items.append(CatgeoryViewModelBannerItem(banner: model.bannerImage))
        }
        #else
        if model.tabCategoryBannerImage.count > 0 {
            items.append(CatgeoryViewModelBannerItem(banner: model.tabCategoryBannerImage))
        }
        #endif
        
        if model.categories.count > 0 {
            items.append(CategoryViewModalCategoriewsItem(categoryHeading: "Explore".localized + " ", categoryList: model.categories))
        }

        if model.productList.count > 0 {
            //items.append(SubCategoryViewModalProductItem(productHeading: categoryName + "'s".localized + "Products".localized, productList: model.productList))
            items.append(CategoryViewModalProductItem(productHeading: "Products".localized, productList: model.productList))
        }
        if model.hotSeller.count > 0 {
            items.append(CategoryViewModalHotSellerItem(productHeading: "Hot Seller".localized, productList: model.hotSeller))
        }
//        
        
        
        completion(true)
    }
    
}

