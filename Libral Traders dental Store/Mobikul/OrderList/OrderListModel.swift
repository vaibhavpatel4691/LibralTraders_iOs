//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: OrderListModel.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation

class OrderListModel {
    var orderListData = [OrderListDataStruct]()
    var totalItem: Int?
    init?(data: JSON) {
        print("Response data: ", data)
        totalItem = data["totalCount"].intValue
        for i in 0..<data["orderList"].count {
            orderListData.append(OrderListDataStruct.init(data: data["orderList"][i]))
        }
    }
}


struct OrderListDataStruct: Equatable, Hashable {
    var orderId: String?
    var orderStatus: String?
    var orderDate: String?
    var orderPrice: String?
    var canReorder: Bool?
    var statusColorCode: String!
    var itemImageUrl: String!
    var isExpanded: Bool = false
    init(data: JSON) {
        orderId = data["order_id"].stringValue
        orderStatus = data["status"].stringValue
        orderDate = data["date"].stringValue
        orderPrice = data["order_total"].stringValue
        canReorder = data["canReorder"].boolValue
        statusColorCode = data["statusColorCode"].stringValue
        itemImageUrl = data["item_image_url"].stringValue
    }
    
    static func == (lhs: OrderListDataStruct, rhs: OrderListDataStruct) -> Bool {
        return lhs.orderId == rhs.orderId
    }
}

class ReOrderListModel: Codable {
    let status : Bool?
    let data : [ReOrderListDataStruct]?
}

class ReOrderListDataStruct: Codable {
    let sku : String?
    let productid : String?
    let name : String?
    let price : String?
    let product_type : String?
    let stock_status : String?
    var qty_order : String?
    let image : String?
    let create_at : String?
    let currency : String?
}

struct TrackOrderModel: Codable {
    let carrier_title : String?
    let tracking_number : String?
    let track_summary : Track_summary?
    var orderObject: [OrderObject]?
    var ORIGIN: String?
    var DESTINATION: String?
    var BOOKING_DATE: String?
    var BOOKING_TIME: String?
    var SERVICE_TYPE: String?
    var CURRENT_STATUS: String?
    
}

struct Shipments : Codable {
    let Status : String?
    let Scans : Scan?
}

struct Scan: Codable {
    let ScanDetail : [ScanDetails]?
}

struct ScanDetails : Codable {
    let Scan : String?
    let ScanCode : String?
    let ScanType : String?
    let ScanGroupType : String?
    let ScanDate : String?
    let ScanTime : String?
    let ScannedLocation : String?
    let ScannedLocationCode : String?
}

struct BookingsData : Codable {
    let FromCenter : String?
    let ToCenter : String?
    let BookingDate : String?
    let BookingTime : String?
    let ReceiverName : String?
}

struct TransitsHistory : Codable {
    let Transit : [Transits]?
}

struct Transits : Codable {
    let Job : String?
    let TransitDate : String?
    let Route : String?
    let TransitTime : String?
}

struct Track_summary : Codable {
    // trackon orderModel
    let summaryTrack : SummaryTrack?
    let CustomersummaryTrack : String?
    let lstDetails : [LstDetails]?
    let ResponseStatus : ResponseStatus?
    
    let AwbNumber : String?
    let BookingData : BookingsData?
    let TransitHistory : TransitsHistory?
    let Status : String?
    let Shipment : Shipments?
}

// Ecomm Order
class OrderObject : Codable {
    let delivery: String
    let name: String
    let date: String
    
    init(delivery: String, name: String, date: String) {
        self.delivery = delivery
        self.name = name
        self.date = date
    }
}

// trackon orderModel
struct SummaryTrack : Codable {
    let AWBNO : String?
    let REF_NO : String?
    let BOOKING_DATE : String?
    let ORIGIN : String?
    let NO_OF_PIECES : String?
    let PINCODE : String?
    let DESTINATION : String?
    let PRODUCT : String?
    let SERVICE_TYPE : String?
    let CHARGED_WEIGHT : String?
    let CURRENT_STATUS : String?
    let CURRENT_CITY : String?
    let EVENTDATE : String?
    let EVENTTIME : String?
    let TRACKING_CODE : String?
    let NDR_REASON : String?
}

struct ResponseStatus : Codable {
    let ErrorCode : String?
    let Message : String?
    let StackTrace : String?
    let Errors : String?
}

struct LstDetails : Codable {
    let CURRENT_CITY : String?
    let CURRENT_STATUS : String?
    let EVENTDATE : String?
    let EVENTTIME : String?
    let TRACKING_CODE : String?
}
