//
//  OrderAgainViewModel.swift
//  Libral Traders
//
//  Created by Invention Hill on 02/10/23.
//

import UIKit

class OrderAgainViewModel: NSObject {
    
    weak var orderTableView: UITableView?
    var pageNumber = 1
    weak var delegate: Pagination?
    weak var reOrderDelegate: ReOrder?
    var orderListData = [ReOrderListDataStruct]()
//    var model: OrderListModel?
    var model: ReOrderListModel?
    weak var moveDelegate: moveToControlller?
    var orderId = ""
    var productQuantity: String = ""
    
    
    func callingHttppApi(apiType: ApiTypeForOrderList, completion: @escaping (Bool) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        requstParams["pageSize"] = 20
        requstParams["currentPage"] = 1
        
        switch apiType {
        case .details:
            requstParams["customerId"] = Defaults.customerId
            requstParams["pageNumber"] = pageNumber
            requstParams["eTag"] = DBManager.sharedInstance.geteTagFromDataBase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "reOrderListData"))
            NetworkManager.sharedInstance.apiRequestWithJson(params: requstParams, method: .post, apiname: .orderList, currentView: UIViewController()) { [weak self] success, responseObject  in
                if success == 1 {
                    
                    if let jsonData = (responseObject as? String)?.data(using: .utf8) {
                        do {
                            let apiResponse = try JSONDecoder().decode(ReOrderListModel.self, from: jsonData)
                            self?.model = apiResponse
                            if let orderListData = apiResponse.data  {
                                self?.orderListData = orderListData
                                completion(true)
                            }
                        } catch {
                            print("Error decoding JSON: \(error)")
                        }
                    }
                                        
//                    let jsonResponse = JSON(responseObject as? NSDictionary ?? [:])
//                    if jsonResponse["success"].boolValue == true {
//                        if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]) {
//                            DBManager.sharedInstance.storeDataToDataBase(data: data, eTag: jsonResponse["eTag"].stringValue, hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "reOrderListData"))
//                        }
//                        
//                        self?.doFurtherProcessingWithResult(apiType: apiType, data: jsonResponse) { success in
//                            completion(success)
//                        }
//                    } else {
//                        if jsonResponse["message"].stringValue.removeWhiteSpace.count > 0 {
//                            ShowNotificationMessages.sharedInstance.warningView(message: jsonResponse["message"].stringValue)
//                        } else {
//                            ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
//                        }
//                    }
                } else if success == 2 {   // Retry in case of error
                    NetworkManager.sharedInstance.dismissLoader()
                    self?.callingHttppApi(apiType: apiType) {success in
                        completion(success)
                        
                    }
                } else if success == 3 {   // No Changes
                    let jsonResponse =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "reOrderListData"))
                    self?.doFurtherProcessingWithResult(apiType: apiType, data: jsonResponse) { success in
                        completion(success)
                    }
                    
                }
            }
        case .reOrder:

         //   requstParams["incrementId"] = orderId
            requstParams["customerToken"] = Defaults.customerToken
            requstParams["quoteId"] = 0
            requstParams["productId"] = orderId
            requstParams["qty"] = productQuantity
            requstParams["params"] = [String: Any]()
            requstParams["relatedProducts"] = [Any]()
            requstParams["storeId"] = "1"
            
            NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .post, apiname: .addToCart, currentView: UIViewController()) { [weak self] success, responseObject  in
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
            break
//            model = OrderListModel(data: data)
//            if orderListData.count != model?.totalItem ?? 0 {
//                for i in 0..<model!.orderListData.count {
//                    orderListData.append((model?.orderListData[i])!)
//                }
//            }
//            //let orderComplete = orderListData.filter { $0.orderStatus == "Complete"}
//
//           // let uniqueOrders = Array(Set(orderListData))
//            let uniqueOrderListData = Set(orderListData)
//            orderListData = Array(uniqueOrderListData)
//
//            let orderComplete = orderListData.filter { $0.orderStatus == "Complete" }
//            orderListData = orderComplete
//            orderListData.sort { $0.orderDate ?? "" < $1.orderDate ?? "" }
//            completion(true)
        case .reOrder:
            if data["cartCount"] != JSON.null {
                Defaults.cartBadge = data["cartCount"].stringValue
            }
            moveDelegate?.moveController(id: orderId, name: data["message"].stringValue, dict: [:], jsonData: JSON.null, index: 0, controller: .none)
        default:
            print("")
        }
    }
}


extension OrderAgainViewModel: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(with: OrderAgainListCell.self, for: indexPath) {
            cell.didSetData()
            if orderListData.count > 0 {
                cell.configOrderAgainCell(item: orderListData[indexPath.row]) { updatedoOrderListData in
                    self.orderListData[indexPath.row] = updatedoOrderListData
                }
                cell.delegate = self
                cell.buyAgainButton.tag = indexPath.row
                cell.selectionStyle = .none
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        moveDelegate?.moveController(id: orderListData[indexPath.row].productid ?? "", name: "", dict: [:], jsonData: JSON.null, index: indexPath.row, controller: .orderDetailsDataViewController)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = SearchHeader(frame: CGRect(x: 0, y: 0, width: AppDimensions.screenWidth, height: 50))
        view.nameLbl.text = "Your recent order ".localized
        view.imgView.isHidden = true
        view.clearBtn.setTitle("", for: .normal)
        view.clearBtn.isHidden = true
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    @objc func scrollToFirstRow() {
        let indexPath = NSIndexPath(row: 0, section: 0)
        self.orderTableView?.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y > scrollView.contentSize.height - (orderTableView?.frame.size.height ?? 0) - 50 {
//            if orderListData.count < model?.totalItem ?? 0 {
//                orderTableView?.tableFooterView?.isHidden = true
//                pageNumber += 1
//                delegate?.pagination()
//            } else {
//                if orderListData.count == model?.totalItem ?? 0  && orderListData.count > 0 {
//                    if let footerView = (Bundle.main.loadNibNamed("OrderListFotterView", owner: self, options: nil)?[0] as? OrderListFotterView) , orderListData.count > 8 {
//                        footerView.backToTop.addTarget(self, action: #selector(scrollToFirstRow), for: .touchUpInside)
//                        orderTableView?.tableFooterView = footerView
//                        orderTableView?.tableFooterView?.frame.size.height = 100
//                        orderTableView?.tableFooterView?.isHidden = false
//                    }
//                }
//            }
//        }
//    }
}


extension OrderAgainViewModel: moveToControlller {
    
    func moveController(id: String, name: String, dict: [String: Any], jsonData: JSON, index: Int, controller: AllControllers) {
        if controller == .orderDetailsDataViewController {
           print("detail")
            
        } else if controller == .reOrder {
            orderId = orderListData[index].productid ?? ""
            productQuantity = Int(Double(orderListData[index].qty_order ?? "0.0") ?? 0).description
            reOrderDelegate?.reOrderAct()
            
        } else {
           
        }
    }
}
