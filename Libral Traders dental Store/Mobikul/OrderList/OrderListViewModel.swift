//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: OrderListViewModel.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit
import Alamofire
import BottomPopup

class OrderListViewModel: NSObject {
    var model: OrderListModel?
    var pageNumber = 1
    var orderListData = [OrderListDataStruct]()
    var trackOrderData = [TrackOrderModel]()
    weak var delegate: Pagination?
    weak var moveDelegate: moveToControlller?
    weak var reOrderDelegate: ReOrder?
    weak var orderListReviewProductDelegate: OrderListReviewProduct?
    var modelProductReviewData: OrderDetailsModel?
    @IBOutlet weak var orderListTable: UITableView!
    @IBOutlet weak var reviewProductListTable: UITableView!
    var orderId = ""
    var isExpanded = false
    
    
    func callingHttppApi(apiType: ApiTypeForOrderList, completion: @escaping (Bool) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        requstParams["pageNumber"] = pageNumber
        switch apiType {
        case .details:
            requstParams["pageNumber"] = pageNumber
            requstParams["eTag"] = DBManager.sharedInstance.geteTagFromDataBase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "orderListData"))
            NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .get, apiname: .orderDetailsList, currentView: UIViewController()) { [weak self] success, responseObject  in
                if success == 1 {
                    let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                    if jsonResponse["success"].boolValue == true {
                        if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]) {
                            DBManager.sharedInstance.storeDataToDataBase(data: data, eTag: jsonResponse["eTag"].stringValue, hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "orderListData"))
                        }
                        
                        self?.doFurtherProcessingWithResult(apiType: apiType, data: jsonResponse) { success in
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
                    self?.callingHttppApi(apiType: apiType) {success in
                        completion(success)
                        
                    }
                } else if success == 3 {   // No Changes
                    let jsonResponse =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "orderListData"))
                    self?.doFurtherProcessingWithResult(apiType: apiType, data: jsonResponse) { success in
                        completion(success)
                    }
                    
                }
            }
        case .reOrder:

            requstParams["incrementId"] = orderId
            NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .post, apiname: .reorder, currentView: UIViewController()) { [weak self] success, responseObject  in
                if success == 1 {
                    NetworkManager.sharedInstance.dismissLoader()
                    let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                    if jsonResponse["success"].boolValue == true {
                        if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]) {
                            print(data)
                        }
                        self?.doFurtherProcessingWithResult(apiType: apiType, data: jsonResponse) { success in
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
                    self?.callingHttppApi(apiType: apiType) {success in
                        completion(success)
                        
                    }
                } else if success == 3 {   // No Changes
                    let jsonResponse =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "orderListReOrderData"))
                    self?.doFurtherProcessingWithResult(apiType: apiType, data: jsonResponse) { success in
                        completion(success)
                    }
                }
            }
        default :
            print("")
        }
    }
    
    func doFurtherProcessingWithResult(apiType: ApiTypeForOrderList, data: JSON, completion: (Bool) -> Void) {
        NetworkManager.sharedInstance.dismissLoader()
        switch apiType {
        case .details:
            model = OrderListModel(data: data)
            if orderListData.count != model?.totalItem ?? 0 {
                for i in 0..<model!.orderListData.count {
                    orderListData.append((model?.orderListData[i])!)
                }
            }
            completion(true)
        case .reOrder:
            if data["cartCount"] != JSON.null {
                Defaults.cartBadge = data["cartCount"].stringValue
            }
            moveDelegate?.moveController(id: orderId, name: data["message"].stringValue, dict: [:], jsonData: JSON.null, index: 0, controller: .none)
        default:
            print("")
        }
    }
    
    func cancelOrderHttppApi(orderID: String, cancelReason: String, comment: String, completion: @escaping (Bool) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        requstParams["orderId"] = orderID
        requstParams["cancelReasosns"] = cancelReason
        requstParams["comment"] = comment
        
        NetworkManager.sharedInstance.apiRequestWithJson(params: requstParams, method: .post, apiname: .cancelOrder, currentView: UIViewController()) { [weak self] success, responseObject  in
            
            if success == 1 {
                let jsonResponse =  JSON(responseObject as? NSArray ?? [])
                let responseJSON = JSON(jsonResponse[0].rawValue as? NSDictionary ?? [:])
               
                self?.doOrderCancelFurtherProcessingWithResult(data: responseJSON) { success in
                    completion(success)
                }
            } else if success == 2 {
                NetworkManager.sharedInstance.dismissLoader()
                self?.cancelOrderHttppApi(orderID: orderID, cancelReason: cancelReason, comment: comment) { success in
                    completion(success)
                }
            }
        }
    }
    
    func doOrderCancelFurtherProcessingWithResult(data: JSON, completion: (Bool) -> Void) {
        if data["status"].boolValue {
            ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: data["message"].stringValue)
            completion(true)
        } else {
            ShowNotificationMessages.sharedInstance.warningView(message: data["message"].stringValue)
        }
    }
    
    
    func trackOrderHttppApi(shipmentId: String, completion: @escaping (Bool) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        requstParams["shipmentId"] = shipmentId
        requstParams["customerId"] = Defaults.customerId
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .get, apiname: .trackOrder, currentView: UIViewController()) { [weak self] success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            if success == 1 {
                
                if let jsonData = (responseObject as? String)?.data(using: .utf8) {
                    do {
                        
                        if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                            let carrierTitle = json.first?["carrier_title"] as! String
                            let trackingNumber = json.first?["tracking_number"] as! String
                            
                            if carrierTitle == "Ecomm Ordertracking" {
                               
                                if let trackSummary = json.first?["track_summary"] as? [String: Any],
                                   let object = trackSummary["object"] as? [String: Any],
                                   let fields = object["field"] as? [Any] {
                                    
                                    var orderObject: [OrderObject] = []
                                    
                                    for field in fields {
                                        if let fieldDict = field as? [String: Any],
                                           let fieldObjects = fieldDict["object"] as? [Any] {
                                            
                                            for fieldObject in fieldObjects {
                                                if let fieldObjectDict = fieldObject as? [String: Any],
                                                   let lineResponse = fieldObjectDict["field"] as? [Any] {
                                                    let delivery = "\(lineResponse[4])(\(lineResponse[1]))"
                                                    let name = "\(lineResponse[8])(\(lineResponse[9]))"
                                                    let date = "\(lineResponse[0])"
                                                    
                                                    let order = OrderObject(delivery: delivery, name: name, date: date)
                                                    orderObject.append(order)
                                                }
                                            }
                                        }
                                    }
                                    
                                    let obj = TrackOrderModel(carrier_title: carrierTitle, tracking_number: trackingNumber, track_summary: nil, orderObject: orderObject)
                                    self?.trackOrderData = [obj]
                                    completion(true)
                                }
                            } else if carrierTitle == "Trackon" {
                                let apiResponse = try JSONDecoder().decode([TrackOrderModel].self, from: jsonData)
                            
                                var orderObject: [OrderObject] = []
                                                            
                                for fieldObject in apiResponse.first?.track_summary?.lstDetails ?? [] {
                                    let order = OrderObject(delivery: fieldObject.CURRENT_STATUS ?? "",
                                                            name: fieldObject.CURRENT_CITY ?? "",
                                                            date: "\(fieldObject.EVENTDATE ?? ""), \(fieldObject.EVENTTIME ?? "")")
                                    orderObject.append(order)
                                }
                                let details = apiResponse.first
                                let productDetails = details?.track_summary?.summaryTrack
                                
                                let obj = TrackOrderModel(carrier_title: details?.carrier_title,
                                                               tracking_number: details?.tracking_number,
                                                               track_summary: nil,
                                                               orderObject: orderObject,
                                                               ORIGIN: productDetails?.ORIGIN,
                                                               DESTINATION: productDetails?.DESTINATION,
                                                               BOOKING_DATE: productDetails?.BOOKING_DATE,
                                                               SERVICE_TYPE: productDetails?.SERVICE_TYPE,
                                                               CURRENT_STATUS: productDetails?.CURRENT_STATUS)
                                
                                self?.trackOrderData = [obj]
                                completion(true)
                            } else if carrierTitle == "Bluedart" {
                                let apiResponse = try JSONDecoder().decode([TrackOrderModel].self, from: jsonData)
                                var orderObject: [OrderObject] = []
                                
                                for fieldObject in apiResponse.first?.track_summary?.Shipment?.Scans?.ScanDetail ?? [] {
                                    let order = OrderObject(delivery: fieldObject.Scan ?? "",
                                                            name: fieldObject.ScannedLocation ?? "",
                                                            date: "\(fieldObject.ScanDate ?? ""), \(fieldObject.ScanTime ?? "")")
                                    orderObject.append(order)
                                }
                                
                                let details = apiResponse.first
                                let productDetails = details?.track_summary?.Shipment
                                
                                let obj = TrackOrderModel(carrier_title: details?.carrier_title,
                                                               tracking_number: details?.tracking_number,
                                                               track_summary: nil,
                                                               orderObject: orderObject,
                                                               ORIGIN: productDetails?.Status)
                                self?.trackOrderData = [obj]
                                completion(true)
                                
                            } else if carrierTitle == "ShreeTirupati" {
                                let apiResponse = try JSONDecoder().decode([TrackOrderModel].self, from: jsonData)
                                
                                var orderObject: [OrderObject] = []
                                
                                for fieldObject in apiResponse.first?.track_summary?.TransitHistory?.Transit ?? [] {
                                    let order = OrderObject(delivery: fieldObject.Job ?? "",
                                                            name: fieldObject.Route ?? "",
                                                            date: "\(fieldObject.TransitDate ?? ""), \(fieldObject.TransitTime ?? "")")
                                    orderObject.append(order)
                                }
                                
                                let details = apiResponse.first
                                let productDetails = details?.track_summary?.BookingData
                                
                                let obj = TrackOrderModel(carrier_title: details?.carrier_title,
                                                          tracking_number: details?.tracking_number,
                                                          track_summary: nil,
                                                          orderObject: orderObject,
                                                          ORIGIN: productDetails?.ToCenter,
                                                          DESTINATION: productDetails?.FromCenter,
                                                          BOOKING_DATE: productDetails?.BookingDate,
                                                          BOOKING_TIME: productDetails?.BookingTime,
                                                          CURRENT_STATUS: details?.track_summary?.Status)
                                
                                self?.trackOrderData = [obj]
                                completion(true)
                            }
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            } else if success == 2 {
                self?.trackOrderHttppApi(shipmentId: shipmentId) { success in
                    completion(success)
                }
            }
        }
    }
}

extension OrderListViewModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderListData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: OrderListTableViewCell = tableView.dequeueReusableCell(with: OrderListTableViewCell.self, for: indexPath) {
            if orderListData.count > 0 {
            cell.item = orderListData[indexPath.row]
            cell.delegate = self
            cell.detailBtn.tag = indexPath.row
            cell.reOrderBtn.tag = indexPath.row
            cell.reviewBtn.tag = indexPath.row
            cell.selectionStyle = .none
            //cell.setTrackProgress(progress: 0.60)
            }
            return cell
        }
        return UITableViewCell()
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 400
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        moveDelegate?.moveController(id: orderListData[indexPath.row].orderId ?? "", name: "", dict: [:], jsonData: JSON.null, index: indexPath.row, controller: .orderDetailsDataViewController)
    }
    
    @objc func scrollToFirstRow() {
        let indexPath = NSIndexPath(row: 0, section: 0)
        self.orderListTable.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - orderListTable.frame.size.height - 50 {
            if orderListData.count < model?.totalItem ?? 0 {
                orderListTable.tableFooterView?.isHidden = true
                pageNumber += 1
                delegate?.pagination()
            } else {
                if orderListData.count == model?.totalItem ?? 0  && orderListData.count > 0 {
                    if let footerView = (Bundle.main.loadNibNamed("OrderListFotterView", owner: self, options: nil)?[0] as? OrderListFotterView) , orderListData.count > 8 {
                        footerView.backToTop.addTarget(self, action: #selector(scrollToFirstRow), for: .touchUpInside)
                        orderListTable.tableFooterView = footerView
                        orderListTable.tableFooterView?.frame.size.height = 100
                        orderListTable.tableFooterView?.isHidden = false
                    }
                }
            }
        }
    }
}

extension OrderListViewModel: moveToControlller {
    func moveController(id: String, name: String, dict: [String: Any], jsonData: JSON, index: Int, controller: AllControllers) {
        if controller == .orderDetailsDataViewController {
            moveDelegate?.moveController(id: orderListData[index].orderId ?? "", name: "", dict: [:], jsonData: JSON.null, index: index, controller: .orderDetailsDataViewController)
//            orderListData[index].isExpanded.toggle()
//            let indexPath = IndexPath(row: index, section: 0)
//            self.orderListTable.reloadRows(at: [indexPath], with: .none)
            
        } else if controller == .reOrder {
            if name == "REORDER" {
                orderId = orderListData[index].orderId ?? ""
                reOrderDelegate?.reOrderAct()
            } else {
                print("Cancel...")
//                orderId = orderListData[index].orderId ?? ""
//                self.cancelOrderHttppApi(orderID: orderId)
                moveDelegate?.moveController(id: orderListData[index].orderId ?? "", name: "", dict: [:], jsonData: JSON.null, index: index, controller: .orderListViewController)
                
            }
            
        } else {
            moveDelegate?.moveController(id: orderListData[index].orderId ?? "", name: "", dict: [:], jsonData: JSON.null, index: index, controller: .orderReview)
        }
    }
}

enum ApiTypeForOrderList {
    case details
    case reOrder
    case review
}
