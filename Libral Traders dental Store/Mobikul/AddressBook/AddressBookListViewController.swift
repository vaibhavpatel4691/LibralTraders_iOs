//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: AddressBookListViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class AddressBookListViewController: UIViewController {
    
    @IBOutlet weak var addressBtn: UIButton!
    @IBOutlet weak var addressListTableView: UITableView!
    var addressBookListViewModelObject = AddressBookListViewModel()
    let defaults = UserDefaults.standard
    var apiCallName = ""
    var completionBlock: (() -> Void)?
    
    var emptyView: EmptyView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            //addressListTableView.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        addressBtn.setTitle("Add New Address".localized.uppercased(), for: .normal)
        if Defaults.language == "ar" {
            addressBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        }
        self.navigationItem.title = "Address Book".localized
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        addressBookListViewModelObject.addressListTableView = addressListTableView
        addressListTableView.delegate = addressBookListViewModelObject
        addressListTableView.dataSource = addressBookListViewModelObject
        addressBookListViewModelObject.delegate = self
        addressListTableView.register(cellType: AddressTextTableViewCell.self)
        theme()
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        // Do any additional setup after loading the view.
    }
    
    func theme() {
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                addressBtn.backgroundColor = AppStaticColors.darkButtonBackGroundColor
                addressBtn.setTitleColor(AppStaticColors.darkButtonTextColor, for: .normal)
                UINavigationBar.appearance().barTintColor = AppStaticColors.darkPrimaryColor
                self.navigationController?.navigationBar.barTintColor = AppStaticColors.darkPrimaryColor
                self.navigationController?.navigationBar.tintColor = AppStaticColors.darkItemTintColor
                UINavigationBar.appearance().tintColor = AppStaticColors.darkItemTintColor
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.darkItemTintColor]
                UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.darkItemTintColor]

            } else {
                addressBtn.backgroundColor = AppStaticColors.buttonBackGroundColor
                addressBtn.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
                UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
                self.navigationController?.navigationBar.barTintColor = AppStaticColors.primaryColor
                self.navigationController?.navigationBar.tintColor = AppStaticColors.itemTintColor
                UINavigationBar.appearance().tintColor = AppStaticColors.itemTintColor
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
                UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
            }
        } else {
            addressBtn.backgroundColor = AppStaticColors.buttonBackGroundColor
            addressBtn.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
            UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
            self.navigationController?.navigationBar.barTintColor = AppStaticColors.primaryColor
            self.navigationController?.navigationBar.tintColor = AppStaticColors.itemTintColor
            UINavigationBar.appearance().tintColor = AppStaticColors.itemTintColor
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
        }

    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        DispatchQueue.main.async {
            self.theme()
        }
       }

          override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
              // Trait collection will change. Use this one so you know what the state is changing to.
          }
    override func viewWillAppear(_ animated: Bool) {
        
        apiCallName = ""
        callingHttppApi(id: "")
        if emptyView == nil {
            emptyView = EmptyView(frame: self.view.frame)
            self.view.addSubview(emptyView)
            emptyView.isHidden = true
            //            emptyView.emptyImages.image = UIImage(named: "illustration-address")
            emptyView.emptyImages.addSubview(LottieHandler.sharedInstance.initializeLottie(bounds: emptyView.emptyImages.bounds, fileName: "AddressFile"))
            emptyView.actionBtn.setTitle("Add New Address".localized, for: .normal)
            emptyView.labelMessage.text = "You didn’t add any of your addresses yet.".localized
            emptyView.titleText.text = "No Addresses".localized
            emptyView.actionBtn.addTapGestureRecognizer {
                self.emptyClicked()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let completionBlock = self.completionBlock {
            completionBlock()
        }
    }
    func emptyClicked() {
        let viewController = NewAddressDataViewController.instantiate(fromAppStoryboard: .customer)
        viewController.isDefaultSave = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func callingHttppApi(id: String) {
        NetworkManager.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        var requstParams = [String: Any]()
        requstParams["token"] = Defaults.deviceToken
        
        if apiCallName == "deleteAddress"{
            requstParams["storeId"] = Defaults.storeId
            requstParams["quoteId"] = Defaults.quoteId
            requstParams["customerToken"] = Defaults.customerToken

            requstParams["addressId"] = id
            NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .delete, apiname: .deleteAddress, currentView: self) { [weak self] success, responseObject in
                guard let self = self else { return }
                if success == 1 {
                    
                    let data = JSON(responseObject!)
                    print(data)
                    NetworkManager.sharedInstance.dismissLoader()
                    let errorCode = data.boolValue
                    
                    if errorCode == true {
                        self.apiCallName = ""
                        self.showErrorSnackBar(msg: data["message"].stringValue)
                        self.callingHttppApi(id: id)
                    } else {
                        self.showSuccessSnackBar(msg: data["message"].stringValue)
                        self.apiCallName = ""
                        self.callingHttppApi(id: "")
                    }
                } else if success == 2 {
                    NetworkManager.sharedInstance.dismissLoader()
                    self.apiCallName = ""
                    self.callingHttppApi(id: "")
                }
            }
        } else {
            
            NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .get, apiname: .addressBook, currentView: self) { [weak self] success, responseObject in
                guard let self = self else { return }
                if success == 1 {
                    
                    NetworkManager.sharedInstance.dismissLoader()
                    self.view.isUserInteractionEnabled = true
                    print(responseObject!)
                    self.addressBookListViewModelObject.getValue(data: JSON(responseObject!)) { (data: Bool) in
                        if data {
                            DispatchQueue.main.async {
                                if self.addressBookListViewModelObject.addressCount > 0 {
                                    self.emptyView.isHidden = true
                                    self.addressListTableView.isHidden = false
                                } else {
                                    self.emptyView.isHidden = false
                                    LottieHandler.sharedInstance.playLoattieAnimation()
                                    self.addressListTableView.isHidden = true
                                }
                                
                                self.addressListTableView.reloadData()
                                self.apiCallName = ""
                            }
                        }
                    }
                    
                } else if success == 2 {
                    NetworkManager.sharedInstance.dismissLoader()
                    self.apiCallName = ""
                    self.callingHttppApi(id: "")
                }
            }
        }
    }
    @IBAction func newAddressClicked(_ sender: Any) {
        let viewController = NewAddressDataViewController.instantiate(fromAppStoryboard: .customer)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension AddressBookListViewController: RemoveAddressAction {
    func removeAddress(addressId: String) {
        apiCallName = "deleteAddress"
        callingHttppApi(id: addressId)
    }
    func editAddress(addressId: String) {
        let viewController = NewAddressDataViewController.instantiate(fromAppStoryboard: .customer)
        viewController.addressId = addressId
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

protocol RemoveAddressAction: NSObjectProtocol {
    func removeAddress(addressId: String)
    func editAddress(addressId: String)
}
