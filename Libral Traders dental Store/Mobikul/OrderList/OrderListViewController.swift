//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: OrderListViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit
import BottomPopup

class OrderListViewController: UIViewController {
    
    //@IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var orderListTable: UITableView!
    var emptyView: EmptyView!
    var refreshControl: UIRefreshControl!
    var viewModel: OrderListViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //backBtn.image = backBtn.image?.flipImage()
        orderListTable.register(cellType: OrderListTableViewCell.self)
        viewModel = OrderListViewModel()
        viewModel.delegate = self
        viewModel.orderListTable = self.orderListTable
        //add refresh control to tableview
        refreshControl = UIRefreshControl()
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let attributedTitle = NSAttributedString(string: "Refreshing...".localized, attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            orderListTable.refreshControl = refreshControl
        } else {
            orderListTable.backgroundView = refreshControl
        }
        viewModel.reOrderDelegate = self
        viewModel.moveDelegate = self
        orderListTable.separatorStyle = .none
        self.navigationItem.title = "My Orders".localized
        callRequest(apiType: ApiTypeForOrderList.details)
    }
    func appTheme() {
        if #available(iOS 12.0, *) {

            if self.traitCollection.userInterfaceStyle == .dark {
             UINavigationBar.appearance().barTintColor = AppStaticColors.darkPrimaryColor
             self.navigationController?.navigationBar.barTintColor = AppStaticColors.darkPrimaryColor
             self.navigationController?.navigationBar.tintColor = AppStaticColors.darkItemTintColor
             UINavigationBar.appearance().tintColor = AppStaticColors.darkItemTintColor
             self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.darkItemTintColor]
             UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.darkItemTintColor]
                

            } else {
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
    

    func callRequest(apiType: ApiTypeForOrderList) {
        viewModel?.callingHttppApi(apiType: apiType) { [weak self] success in
            guard let self = self else { return }
            if success {
                switch apiType {
                case .details:
                    self.refreshControl.endRefreshing()
                    if self.viewModel.orderListData.count > 0 {
                        self.emptyView.isHidden = true
                        self.orderListTable.isHidden = false
                        self.orderListTable.delegate = self.viewModel
                        self.orderListTable.dataSource = self.viewModel
                        self.orderListTable.reloadData()
                    } else {
                        self.emptyView.isHidden = false
                        self.orderListTable.isHidden = true
                        LottieHandler.sharedInstance.playLoattieAnimation()
                    }
                    
                    
                default:
                    print("")
                }
            } else {
                
            }
        }
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        refreshControl.isHidden = false
        self.viewModel.pageNumber = 1
        self.viewModel.orderListData.removeAll()
        callRequest(apiType: ApiTypeForOrderList.details)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if emptyView == nil {
            emptyView = EmptyView(frame: self.view.frame)
            self.view.addSubview(emptyView)
            emptyView.isHidden = true
            //            emptyView.emptyImages.image = UIImage(named: "illustration-box")
            emptyView.emptyImages.addSubview(LottieHandler.sharedInstance.initializeLottie(bounds: emptyView.emptyImages.bounds, fileName: "OrderFile"))
            emptyView.actionBtn.setTitle("Start Shopping".localized, for: .normal)
            emptyView.labelMessage.text = "You have not placed ay order with us yet.".localized
            emptyView.titleText.text = "No Orders".localized
            emptyView.actionBtn.addTapGestureRecognizer {
                self.emptyClicked()
            }
        }
    }
    
    
    func emptyClicked() {
        self.tabBarController?.selectedIndex = 0
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}

extension OrderListViewController: Pagination, moveToControlller, ReOrder {
    func reOrderAct() {
        callRequest(apiType: ApiTypeForOrderList.reOrder)
    }
    
    func moveController(id: String, name: String, dict: [String: Any], jsonData: JSON, index: Int, controller: AllControllers) {
        if controller == .orderDetailsDataViewController {
            let viewController = OrderDetailsDataViewController.instantiate(fromAppStoryboard: .customer)
            viewController.orderId = id
            let nav = UINavigationController(rootViewController: viewController)
            //nav.navigationBar.tintColor = AppStaticColors.accentColor
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        } else if controller == .reOrder {
            self.tabBarController!.tabBar.items?[3].badgeValue = jsonData["cartCount"].stringValue
            let AC = UIAlertController(title: id, message: jsonData["message"].stringValue, preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                self.tabBarController?.selectedIndex =  3
            })
            AC.addAction(okBtn)
            self.present(AC, animated: true, completion: {})
        } else if controller == .orderReview {
            let viewController = OrderReviewListProductViewController.instantiate(fromAppStoryboard: .customer)
            viewController.orderId = id
            viewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(viewController, animated: true, completion: nil)
        } else if controller == .orderListViewController {
            let orderCancel = OrderCancelVC.instantiate(fromAppStoryboard: .customer)
            orderCancel.orderID = id
            orderCancel.popupDelegate = self
            self.present(orderCancel, animated: true, completion: nil)
        } else {
            let AC = UIAlertController(title: "Reorder".localized, message: "Product(s) has been added to cart".localized, preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "Go to Cart".localized.uppercased(), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                let viewController = CartDataViewController.instantiate(fromAppStoryboard: .product)
                let nav = UINavigationController(rootViewController: viewController)
                //nav.navigationBar.tintColor = AppStaticColors.accentColor
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            })
            let cancelBtn = UIAlertAction(title: "Dismiss".localized.uppercased(), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                
            })
            AC.addAction(okBtn)
            AC.addAction(cancelBtn)
            self.present(AC, animated: true, completion: {})
        }
    }
    func pagination() {
        callRequest(apiType: ApiTypeForOrderList.details)
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.appTheme()
        self.orderListTable.reloadData()
       }

       override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
           // Trait collection will change. Use this one so you know what the state is changing to.
       }
}


extension OrderListViewController: BottomPopupDelegate {
    
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
        self.refresh(refreshControl)
        self.orderListTable.reloadData()
    }
    
    func bottomPopupDidDismiss() {
        print("bottomPopupDidDismiss")
    }
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        print("bottomPopupDismissInteractionPercentChanged fromValue: \(oldValue) to: \(newValue)")
    }
}
