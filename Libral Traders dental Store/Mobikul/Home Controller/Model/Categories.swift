//
//  Categories.swift
//
//  Created by rakesh on 21/07/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Categories {
    
    var thumbnail: String!
    var banner: String!
    var bannerDominantColor: String!
    var id: String!
    var hasChildren: Bool!
    var thumbnailDominantColor: String!
    var name: String!
    var collapse: Bool?
    var childCategories = [Categories]()
    var childCategoriesData =  [ChildCategory]()
    init(json: JSON) {
        thumbnail = json["thumbnail"].stringValue
        banner = json["banner"].stringValue
        bannerDominantColor = json["bannerDominantColor"].stringValue
        id = json["id"].stringValue
        hasChildren = json["hasChildren"].boolValue
        thumbnailDominantColor = json["thumbnailDominantColor"].stringValue
        name = json["name"].stringValue
        collapse = false
        if let arr = json["childCategories"].array {
            childCategories = arr.map({ (value) -> Categories in
                return Categories(json: value)
            })
            
        }
        if let arr = json["childCategories"].array {
            childCategoriesData = arr.map({ (value) -> ChildCategory in
                return ChildCategory(json: value)
            })
        }
        var cat = ChildCategory(json: "")
        cat.id = id
        cat.name = "View All".localized
        cat.title = name
        cat.viewAllCategoryCheck = true
        cat.hasChildren = false
        cat.thumbnail = thumbnail
        childCategoriesData.append(cat)
    }
    
}

struct ChildCategory {
    var name: String!
    var id: String!
    var title: String!
    var viewAllCategoryCheck = false
    var hasChildren: Bool!
    var thumbnail: String!
    init(json: JSON) {
        name = json["name"].stringValue
        id = json["id"].stringValue
        hasChildren = json["hasChildren"].boolValue
        thumbnail = json["thumbnail"].stringValue

    }
}
