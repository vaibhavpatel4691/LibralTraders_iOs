//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: ShipmentDetailViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class ShipmentDetailViewController: UIViewController {
    var viewModel: ShippmentViewModel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var trackBtn: UIButton!
    var shippmentId: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                trackBtn.backgroundColor = AppStaticColors.darkButtonBackGroundColor
                trackBtn.setTitleColor(AppStaticColors.darkButtonTextColor, for: .normal)
            } else {
                trackBtn.backgroundColor = AppStaticColors.buttonBackGroundColor
                trackBtn.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
            }
        } else {
            trackBtn.backgroundColor = AppStaticColors.buttonBackGroundColor
            trackBtn.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
        }

        self.trackBtn.setTitle("Track Shipment".localized, for: .normal)
        self.navigationItem.title = "Shipment".localized + " - #" + shippmentId
        tableView.register(cellType: InvoiceProductListTableViewCell.self)
        tableView.register(cellType: ShipmentDetailTableViewCell.self)
        tableView.register(ProductSectionHeading.nib, forHeaderFooterViewReuseIdentifier: ProductSectionHeading.identifier)
        viewModel = ShippmentViewModel(shippmentId: shippmentId)
        tableView.tableFooterView = UIView()
        appTheme()
        //        tableView.separatorStyle = .none
        self.callRequest()
        // Do any additional setup after loading the view.
    }
    
    func callRequest() {
        viewModel?.callingHttppApi { [weak self] success in
            guard let self = self else { return }
            if success {
                self.tableView.delegate = self.viewModel
                self.tableView.dataSource = self.viewModel
                self.tableView.reloadData()
                //                self.priceLabel.text = self.cartViewModalObject?.cartModel.grandtotal?.value
            } else {
            }
        }
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
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        DispatchQueue.main.async {
            self.appTheme()
            self.tableView.reloadData()
        }
       }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        // Trait collection will change. Use this one so you know what the state is changing to.
    }

    @IBAction func crossClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func trackClicked(_ sender: Any) {
        if let _ = viewModel.model {
            if viewModel.model.trackingData.count > 0 {
                let viewController = TrackingDataViewController.instantiate(fromAppStoryboard: .customer)
                viewController.trackingData = viewModel.model.trackingData
                self.navigationController?.pushViewController(viewController, animated: true)
            } else {
                ShowNotificationMessages.sharedInstance.warningView(message: "No data found".localized)
            }
        } else {
            ShowNotificationMessages.sharedInstance.warningView(message: "No data found".localized)
        }
    }
}
