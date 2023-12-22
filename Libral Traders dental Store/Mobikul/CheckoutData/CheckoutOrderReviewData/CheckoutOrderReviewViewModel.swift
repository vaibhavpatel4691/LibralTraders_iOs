//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: CheckoutOrderReview.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit
import Alamofire

class CheckoutOrderReviewViewModel: NSObject {
    
    var shippingMethod: String!
    var model: OrderReviewModel!
    var isVirtual: Bool!
    var totalSections = 0
    var paymentMethod: PaymentMethods?
    var billingAvailable = false
    weak var tableView: UITableView!
    var selectedRow = 0
    var addressId = ""
    var paymentId = ""
    var address = [Address]()
    var apicall = ""
    private var whichApiCall: WhichApiCall = .checkoutAddress
    private  var cartCoupon: String?
    
    func callingHttppApi(completion: @escaping (Bool) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        var requstParams = [String: Any]()
        var apiName: WhichApiCall = .checkoutAddress
        var verbs: HTTPMethod = .get
        switch whichApiCall {
        case .checkoutAddress:
            if apicall == "isVirtual" {
                apiName = .checkoutAddress
                verbs = .get
            } else {
                requstParams["width"] = UrlParams.width
                requstParams["method"] = "customer"
                requstParams["shippingMethod"] = shippingMethod
                requstParams["selectedPaymentMethod"] = paymentId
                apiName = .checkoutOrderReview
                verbs = .post
            }
        case .couponForCart:
            apiName = .couponForCart
            requstParams["couponCode"] = cartCoupon
            requstParams["fromApp"] = "1"
            verbs = . post
        case .removeCoupon:
            apiName = .couponForCart
            requstParams["couponCode"] = cartCoupon
            requstParams["removeCoupon"] = "1"
            requstParams["fromApp"] = "1"
            verbs = . post
        case .selectedPayment:
            requstParams["width"] = UrlParams.width
            requstParams["method"] = "customer"
            requstParams["shippingMethod"] = shippingMethod
            requstParams["selectedPaymentMethod"] = paymentId
           // if paymentId == "razorpay" {
                var billingDict = [String: Any]()
                    billingDict["addressId"] = self.addressId
                    billingDict["newAddress"] = self.address[self.selectedRow].newAddress
                    billingDict["sameAsShipping"] = "0"
                requstParams["billingData"] = billingDict.convertDictionaryToString()
            //}
            apiName = .selectedPayment
            verbs = .post
        default:
            break;
        }
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: verbs, apiname: apiName, currentView: UIViewController()) { [weak self] success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            if success == 1 {                
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                if jsonResponse["success"].boolValue == true {
                    if let data = NetworkManager.sharedInstance.json(from: responseObject as? NSDictionary ?? [:]), self?.whichApiCall == .checkoutAddress {
                        DBManager.sharedInstance.storeDataToDataBase(data: data, eTag: jsonResponse["eTag"].stringValue, hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "checkoutOrderReview"))
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
                let jsonResponse =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "checkoutOrderReview"))
                self?.doFurtherProcessingWithResult(data: jsonResponse) { success in
                    completion(success)
                }
                
            }
        }
    }
    
    func doFurtherProcessingWithResult(data: JSON, completion: @escaping (Bool) -> Void) {
        switch whichApiCall {
        case .couponForCart,.removeCoupon:
            if data["success"].boolValue {
                ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: data["message"].stringValue)
                self.whichApiCall = .checkoutAddress
                self.callingHttppApi {success in
                    completion(success)
                }
            }else{
                ShowNotificationMessages.sharedInstance.warningView(message: data["message"].stringValue)
            }
        case .checkoutAddress:
            if apicall == "isVirtual" {
                let  addressModel = CheckoutAddressModel(json: data)
                if addressModel.address.count > 0 {
                    addressId = addressModel.address[selectedRow].id
                    address = addressModel.address
                    apicall = ""
                    self.callingHttppApi {success in
                        completion(success)
                    }
                    
                } else {
                    apicall = ""
                    self.callingHttppApi {success in
                        completion(success)
                    }
                }
            } else {
                model = OrderReviewModel(json: data)
                totalSections = 7
                completion(true)
            }
        case .selectedPayment:
            completion(true)
        default:
            break
        }
    }
}

extension CheckoutOrderReviewViewModel: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return totalSections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if isVirtual {
                return 0
            } else {
                return 1
            }
        case 1:
            if isVirtual {
                return 1
            } else {
                return billingAvailable ? 1 : 0
            }
        case 2:
            if isVirtual {
                return 0
            } else {
                return 1
            }
        case 3:
            return model.orderReviewData?.orderReviewProducts.count ?? 0
            
        case 4:
            return model.paymentMethods.count
        default:
            return 1
        }
        
    }
    
    func applyCoupon() {
        if let cartCoupon = cartCoupon, cartCoupon.count > 0 {
            self.whichApiCall = .couponForCart
            self.callingHttppApi {success in
                self.model.couponCode = self.cartCoupon
                self.tableView.reloadData()
            }
        } else {
            ShowNotificationMessages.sharedInstance.warningView(message: "Enter Coupon Code".localized)
        }
    }
    
    func deleteCoupon() {
        self.whichApiCall = .removeCoupon
        self.callingHttppApi {success in
            self.model.couponCode = nil
            self.tableView.reloadData()
        }
    }
    
    @objc func switchValueDidChange(_ sender: UISwitch) {
        if sender.isOn {
            billingAvailable = false
        } else {
            billingAvailable = true
        }
        tableView?.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell: SelectionAddressTableViewCell = tableView.dequeueReusableCell(with: SelectionAddressTableViewCell.self, for: indexPath) {
                cell.selectionStyle = .none
                cell.billingSwitch.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
                if billingAvailable {
                    cell.billingSwitch.isOn = false
                } else {
                    cell.billingSwitch.isOn = true
                }
                return cell
            }
        case 1:
            if (address.count > 0) {
                let cellType = ShippingAddressTableViewCell.self
                if let cell: ShippingAddressTableViewCell = tableView.dequeueReusableCell(with: cellType, for: indexPath) {
                    cell.addressLabel.text = address[selectedRow].value
                    cell.addressId = address[selectedRow].id
                    addressId = address[selectedRow].id
                    cell.shippingAddressLabel.text = "Billing Adddress".localized
                    cell.arrowLabel.isHidden = true
                    cell.address = address
                    if address[selectedRow].id == "0" {
                        cell.newAddressBtn.setTitle( " " + "Edit Address".localized, for: .normal)
                    } else {
                        cell.newAddressBtn.setTitle("  New Address".localized, for: .normal)
                    }
                    cell.selectionStyle = .none
                    return cell
                }
            } else {
                let cellType = CheckoutNewAddressTableViewCell.self
                if let cell: CheckoutNewAddressTableViewCell = tableView.dequeueReusableCell(with: cellType, for: indexPath) {
                    cell.shippingAddressLabel.text = "Billing Adddress".localized
                    cell.selectionStyle = .none
                    return cell
                }
            }
        case 2:
            if let cell: OrderReviewShippingTableViewCell = tableView.dequeueReusableCell(with: OrderReviewShippingTableViewCell.self, for: indexPath) {
                cell.shippingMethodValue.text = model.shippingMethod
                cell.shippingAddressValue.text = model.shippingAddress?.html2String
                cell.selectionStyle = .none
                return cell
            }
        case 3:
            if let cell: OrderItemsTableViewCell = tableView.dequeueReusableCell(with: OrderItemsTableViewCell.self, for: indexPath) {
                cell.selectionStyle = .none
                cell.item = model.orderReviewData?.orderReviewProducts[indexPath.row]
                return cell
            }
//        case 4:
//            if let cell: CartVoucherTableViewCell = tableView.dequeueReusableCell(with: CartVoucherTableViewCell.self, for: indexPath) {
//                cell.selectionStyle = .none
//                cell.arrowBtn.image = nil
//                cell.bottomView.isHidden = false
//                cell.bottomViewHeight.constant = 88
//                if let couponCode = model.couponCode, couponCode != "" {
//                    cell.textField.text = couponCode
//                    cell.textField.isUserInteractionEnabled = false
//                    cell.applyBtn.setTitle("Remove".localized, for: .normal)
//                    cell.applyBtn.addTapGestureRecognizer {
//                        self.cartCoupon = cell.textField.text
//                        self.deleteCoupon()
//                    }
//                } else {
//                    cell.textField.text = ""
//                    cell.applyBtn.setTitle("Apply".localized, for: .normal)
//                    cell.textField.isUserInteractionEnabled = true
//                    cell.applyBtn.addTapGestureRecognizer {
//                        self.cartCoupon = cell.textField.text
//                        self.applyCoupon()
//                    }
//                }
//                return cell
//            }
        case 4:
            if let cell: SelectionMethodTableViewCell = tableView.dequeueReusableCell(with: SelectionMethodTableViewCell.self, for: indexPath) {
                cell.theme()
                if paymentId == model.paymentMethods[indexPath.row].code {
                    if model.paymentMethods[indexPath.row].extraInformation != "" {
                        cell.methodName.text = (model.paymentMethods[indexPath.row].title) + "\n" + (model.paymentMethods[indexPath.row].extraInformation)
                        cell.methodName.numberOfLines = 0
                    } else {
                        cell.methodName.text = model.paymentMethods[indexPath.row].title
                    }
                    cell.internalImageView.backgroundColor = AppStaticColors.accentColor
                } else {
                    cell.methodName.text = model.paymentMethods[indexPath.row].title
                    if #available(iOS 12.0, *) {
                        if tableView.traitCollection.userInterfaceStyle == .dark {
                            cell.internalImageView.backgroundColor = UIColor.black
                        } else {
                            cell.internalImageView.backgroundColor = UIColor.white
                        }
                    } else {
                        cell.internalImageView.backgroundColor = UIColor.white
                    }
                }
                cell.selectionStyle = .none
                return cell
            }
            return UITableViewCell()
            
        case 5:
            if let cell: CartPriceTableViewCell = tableView.dequeueReusableCell(with: CartPriceTableViewCell.self, for: indexPath) {
                cell.selectionStyle = .none
                cell.dropIcon.isHidden = true
                cell.item = model.orderReviewData?.totals
                cell.orderTotalPrice.text = model.cartTotal
                cell.tableViewHeight.constant = CGFloat(cell.totalsData.count * 44)
                return cell
            }
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 4 {
            self.paymentId = model.paymentMethods[indexPath.row].code
            self.paymentMethod = model.paymentMethods[indexPath.row]
            UIView.performWithoutAnimation {
                //                let loc = tableView.contentOffset
                tableView.reloadRows(at: [indexPath], with: .automatic)
                tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
                //               tableView.contentOffset = loc
            }
            apicall = ""
            whichApiCall = .selectedPayment
            self.callingHttppApi {success in
                self.apicall = ""
                self.whichApiCall = .checkoutAddress
                self.callingHttppApi { success in
                    
                    self.tableView.reloadData()
                }
            }
            //tableView.reloadSections(IndexSet(integer: 5), with: .none)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 3 || section == 4) {
            return 54
        }
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 3 {
            if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProductSectionHeading.identifier) as? ProductSectionHeading {
                headerView.arrowLabel.isHidden = true
                if (model.orderReviewData?.orderReviewProducts.count ?? 0) == 1 {
                    headerView.titleLabel?.text = String(model.orderReviewData?.orderReviewProducts.count ?? 0) + " " + "Item".localized
                } else {
                    headerView.titleLabel?.text = String(model.orderReviewData?.orderReviewProducts.count ?? 0) + " " + "Item(s)".localized
                }
                return headerView
            }
        }
        
        if section == 4 {
            if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProductSectionHeading.identifier) as? ProductSectionHeading {
                headerView.arrowLabel.isHidden = true
                headerView.titleLabel?.text = "Payment methods".localized
                return headerView
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = AppStaticColors.systemGrayColor
    }
}

extension CheckoutOrderReviewViewModel: SendPaymentId {
    func sendPaymentId(paymentData: PaymentMethods) {
        self.paymentMethod = paymentData
    }
}
