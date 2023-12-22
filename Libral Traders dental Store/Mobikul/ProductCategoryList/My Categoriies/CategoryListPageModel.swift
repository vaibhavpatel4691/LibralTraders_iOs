//
/**
* Webkul Software.
* @package  Mobikul Single App
* @Category Webkul
* @author Webkul <support@webkul.com>
* FileName: CategoryListPageModel.swift
* @Copyright (c) 2010-2019 Webkul Software Private Limited (https://webkul.com)
* @license https://store.webkul.com/license.html ASL Licence
* @link https://store.webkul.com/license.html

*/


import Foundation
enum CategoryViewModelItemType {
    case banner
    case product
    case hotSeller
    case categories
//    case subCategory
//    case shopByProduct
}

protocol CategoryViewModelItem {
    var type: CategoryViewModelItemType { get }
    var heading: String { get }
    var rowCount: Int { get }
}

class CatgeoryViewModelBannerItem: CategoryViewModelItem {
    var type: CategoryViewModelItemType {
        return .banner
    }
    
    var heading: String {
        return ""
    }
    
    var rowCount: Int {
        return banner.count
    }
    var banner: [BannerImage]
    
    init(banner: [BannerImage]) {
        self.banner = banner
    }
}

class CategoryViewModalProductItem: CategoryViewModelItem {
    
    var type: CategoryViewModelItemType {
        return .product
    }
    var heading: String {
        return productHeading
    }
    
    var rowCount: Int {
        return 1
    }
    
    var productHeading: String
    var productList: [RelatedProductList]
    
    init(productHeading: String, productList: [RelatedProductList]) {
        self.productHeading = productHeading
        self.productList = productList
    }
}

class CategoryViewModalHotSellerItem: CategoryViewModelItem {
    
    var type: CategoryViewModelItemType {
        return .hotSeller
    }
    var heading: String {
        return productHeading
    }
    
    var rowCount: Int {
        return 1
    }
    
    var productHeading: String
    var productList: [RelatedProductList]
    
    init(productHeading: String, productList: [RelatedProductList]) {
        self.productHeading = productHeading
        self.productList = productList
    }
}


class CategoryViewModalCategoriewsItem: CategoryViewModelItem {

    var type: CategoryViewModelItemType {
        return .categories
    }
    var heading: String {
        return categoryHeading
    }

    var rowCount: Int {
        return categoryList.count
    }

    var categoryHeading: String
    var categoryList: [Categories]

    init(categoryHeading: String, categoryList: [Categories]) {
        self.categoryHeading = categoryHeading
        self.categoryList = categoryList
    }
}
//class CategoryViewModalCategoriewsItem: CategoryViewModelItem {
//
//    var type: CategoryViewModelItemType {
//        return .categories
//    }
//    var heading: String {
//        return categoryHeading
//    }
//
//    var rowCount: Int {
//        return categoryList.count
//    }
//
//    var categoryHeading: String
//    var categoryList: [Categories]
//
//    init(categoryHeading: String, categoryList: [Categories]) {
//        self.categoryHeading = categoryHeading
//        self.categoryList = categoryList
//    }
//}
