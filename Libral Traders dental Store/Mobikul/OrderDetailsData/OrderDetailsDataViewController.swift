//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: OrderDetailsDataViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit
import BottomPopup

class OrderDetailsDataViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var orderId: String!
    var viewModel: OrderDetailsViewModal!
    
    @IBOutlet weak var reOrderButton: UIButton!
    @IBOutlet weak var trackButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = OrderDetailsViewModal(orderId: orderId)
        viewModel.controller = self
        tableView.register(cellType: OrderHeadingTableViewCell.self)
        tableView.register(cellType: OrderDetailProductTableViewCell.self)
        tableView.register(cellType: CartPriceTableViewCell.self)
        tableView.register(cellType: OrderDetailsExtraTableViewCell.self)
        tableView.register(cellType: OrderTrackTableViewCell.self)
        tableView.register(cellType: ReorderTableViewCell.self)
        tableView.register(cellType: DeliveryboyRatingTableViewCell.self)
        tableView.register(cellType: CustomerOrderRefundsDeatilsTableViewCell.self)
        tableView.register(ProductSectionHeading.nib, forHeaderFooterViewReuseIdentifier: ProductSectionHeading.identifier)
        tableView.register(OrderDetailsHeaderView.nib, forHeaderFooterViewReuseIdentifier: OrderDetailsHeaderView.identifier)
        tableView.register(cellType: OrderDetailInvoiceTableViewCell.self)
        
        viewModel.reloadSections = { [weak self] (section: Int) in
            self?.tableView?.beginUpdates()
            self?.tableView?.reloadSections([section], with: .fade)
            self?.tableView?.endUpdates()
        }
        
        viewModel.navigateAdminChatDelivery = { [weak self] (success: Bool) in
            if success {
                let vc = CustomerAdminChatViewController.instantiate(fromAppStoryboard: .customer)
                vc.otherUserId = "deliveryAdmin"
                vc.otherUserName = "Admin"
                vc.accountType = "customer"
                let customerId = "customer-"+(Defaults.customerId ?? "")
                let ownerId = "owner-"+(self?.viewModel.sellerId ?? "")
                vc.childIdKey = customerId+"+"+ownerId
                vc.senderId = customerId
                vc.senderDisplayName = Defaults.customerName
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        viewModel.navigateToMap = { [weak self] (lat: String, long: String) in
            let vc = PinLocationController.instantiate(fromAppStoryboard: .customer)
            vc.deliveryBoyLatLong = (lat: lat, long: long)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        tableView.tableFooterView = UIView()
        //self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "sharp-cross")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(backPress))
        self.appTheme()
        self.callRequest()
        // Do any additional setup after loading the view.
        
        reOrderButton.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
        reOrderButton.backgroundColor = AppStaticColors.buttonBackGroundColor
        trackButton.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
        trackButton.backgroundColor = AppStaticColors.buttonBackGroundColor
        
    }
    
    func appTheme() {
        if #available(iOS 12.0, *) {

            if self.traitCollection.userInterfaceStyle == .dark {
                self.navigationItem.leftBarButtonItem?.tintColor = AppStaticColors.darkItemTintColor
             UINavigationBar.appearance().barTintColor = AppStaticColors.darkPrimaryColor
             self.navigationController?.navigationBar.barTintColor = AppStaticColors.darkPrimaryColor
             self.navigationController?.navigationBar.tintColor = AppStaticColors.darkItemTintColor
             UINavigationBar.appearance().tintColor = AppStaticColors.darkItemTintColor
             self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.darkItemTintColor]
             UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.darkItemTintColor]
                

            } else {
                self.navigationItem.leftBarButtonItem?.tintColor = AppStaticColors.itemTintColor
             UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
             self.navigationController?.navigationBar.barTintColor = AppStaticColors.primaryColor
             self.navigationController?.navigationBar.tintColor = AppStaticColors.itemTintColor
             UINavigationBar.appearance().tintColor = AppStaticColors.itemTintColor
             self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
             UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
             
         }
        } else {
           UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
            self.navigationController?.navigationBar.barTintColor = AppStaticColors.primaryColor
            self.navigationController?.navigationBar.tintColor = AppStaticColors.itemTintColor
            UINavigationBar.appearance().tintColor = AppStaticColors.itemTintColor
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]

        }
    }
    
    @IBAction func trackButtonPressed(_ sender: UIButton) {
        let orderTrack = OrderTrackViewController.instantiate(fromAppStoryboard: .customer)
        orderTrack.incrementId = self.viewModel.model.incrementId
        orderTrack.shipmentId = self.viewModel.model.shipmentList.first?.id
        let nav = UINavigationController(rootViewController: orderTrack)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func reOrderButtonPressed(_ sender: UIButton) {
        viewModel.apiCall = "reOrder"
        viewModel.callingHttppApi { (_) in
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        DispatchQueue.main.async {
            self.appTheme()
            self.tableView.reloadData()
        }
       }

          override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
              // Trait collection will change. Use this one so you know what the state is changing to.
          }
    func callRequest() {
        viewModel?.callingHttppApi { [weak self] success in
            guard let self = self else { return }
            if success {
                self.tableView.delegate = self.viewModel
                self.tableView.dataSource = self.viewModel
                self.tableView.reloadData()
            } else {
                
            }
        }
    }
}


extension OrderDetailsDataViewController: BottomPopupDelegate {
    
    func bottomPopupViewLoaded() {
        print("bottomPopupViewLoaded")
    }
    
    func bottomPopupWillAppear() {
        print("bottomPopupWillAppear")
    }
    
    func bottomPopupDidAppear() {
        print("bottomPopupDidAppear")
    }
    
    func bottomPopupWillDismiss() {
        print("bottomPopupWillDismiss")
//        self.refresh(refreshControl)
//        self.orderListTable.reloadData()
    }
    
    func bottomPopupDidDismiss() {
        print("bottomPopupDidDismiss")
    }
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        print("bottomPopupDismissInteractionPercentChanged fromValue: \(oldValue) to: \(newValue)")
    }
}
