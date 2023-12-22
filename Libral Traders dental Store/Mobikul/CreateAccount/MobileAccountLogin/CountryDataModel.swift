//
//  CountryDataModel.swift
//  Libral Traders
//
//  Created by khushboo on 31/03/23.
//


import Foundation
import UIKit
import SwiftyJSON

struct GetCountryData {
    var country_name:String!
    var image:String!
    var dial_code:String!
    var country_code:String!
    
    init(data: JSON) {
        
    
            self.country_name = data["country_name"].stringValue
            self.image = data["image"].stringValue
            self.dial_code = data["dail_code"].stringValue
            self.country_code = data["country_code"].stringValue
        }
    
}


