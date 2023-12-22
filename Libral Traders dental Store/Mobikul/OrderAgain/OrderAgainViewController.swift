//
//  OrderAgainViewController.swift
//  Libral Traders
//
//  Created by Invention Hill on 02/10/23.
//

import UIKit

class OrderAgainViewController: UIViewController {

    @IBOutlet weak var orderTableView: UITableView!
    var viewModel: OrderAgainViewModel!
    var emptyView: EmptyView!
    weak var moveDelegate: moveToControlller?
    @IBOutlet weak var cartButton: BadgeBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // super.viewWillAppear(animated)
        cartButton.badgeNumber = Int(Defaults.cartBadge) ?? 0
        
        if emptyView == nil {
            emptyView = EmptyView(frame: self.view.frame)
            self.view.addSubview(emptyView)
            emptyView.isHidden = true
            //            emptyView.emptyImages.image = UIImage(named: "illustration-box")
            emptyView.emptyImages.addSubview(LottieHandler.sharedInstance.initializeLottie(bounds: emptyView.emptyImages.bounds, fileName: "OrderFile"))
            emptyView.actionBtn.setTitle("Start Shopping".localized, for: .normal)
            emptyView.labelMessage.text = "You have not recent order yet.".localized
            emptyView.titleText.text = "No Recent Orders".localized
            emptyView.actionBtn.addTapGestureRecognizer {
                self.emptyClicked()
            }
        }
    }

    @IBAction func btnAddAllToCart(_ sender: Any) {
        for index in viewModel.orderListData.indices {
            self.viewModel.moveController(id: "", name: "", dict: [:], jsonData: JSON.null, index: index, controller: .reOrder)
        }
    }
    
    func emptyClicked() {
        self.tabBarController?.selectedIndex = 0
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpView() {
        self.navigationItem.title = "Order Again".localized
        self.appTheme()
        viewModel = OrderAgainViewModel()
        viewModel.delegate = self
        viewModel.reOrderDelegate = self
        viewModel.moveDelegate = self
        
        orderTableView.delegate = viewModel
        orderTableView.dataSource = viewModel
        orderTableView.register(cellType: RecommendListCell.self)
        orderTableView.register(cellType: OrderAgainListCell.self)
        orderTableView.tableFooterView = UIView()
        viewModel?.orderTableView = orderTableView
        
        callRequestForReOrderList(apiType: ApiTypeForOrderList.details)
    }
    
    func callRequestForReOrderList(apiType: ApiTypeForOrderList) {
        viewModel?.callingHttppApi(apiType: apiType) { [weak self] success in
            guard let self = self else { return }
            if success {
                switch apiType {
                case .details:
                   // self.refreshControl.endRefreshing()
                    if self.viewModel.orderListData.count > 0 {
                        self.emptyView.isHidden = true
                        self.orderTableView.isHidden = false
                        self.orderTableView.delegate = self.viewModel
                        self.orderTableView.dataSource = self.viewModel
                        self.orderTableView.reloadData()
                    } else {
                        self.emptyView.isHidden = false
                        self.orderTableView.isHidden = true
                        LottieHandler.sharedInstance.playLoattieAnimation()
                    }
                    
                    
                default:
                    print("")
                }
            } else {
                
            }
        }
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

    @IBAction func searchBarButtonClicked(_ sender: UIBarButtonItem) {
        let viewController = CartDataViewController.instantiate(fromAppStoryboard: .product)
        let nav = UINavigationController(rootViewController: viewController)
        //nav.navigationBar.tintColor = AppStaticColors.accentColor
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
        
//        let viewController = SearchDataViewController.instantiate(fromAppStoryboard: .search)
//        self.navigationController?.pushViewController(viewController, animated: true)
    }
}


extension OrderAgainViewController: Pagination, moveToControlller, ReOrder {
    func reOrderAct() {
        callRequestForReOrderList(apiType: ApiTypeForOrderList.reOrder)
    }
    
    func moveController(id: String, name: String, dict: [String: Any], jsonData: JSON, index: Int, controller: AllControllers) {
        if controller == .orderDetailsDataViewController {
            let viewController = OrderDetailsDataViewController.instantiate(fromAppStoryboard: .customer)
            viewController.orderId = id
            let nav = UINavigationController(rootViewController: viewController)
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
        }  else {
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
        callRequestForReOrderList(apiType: ApiTypeForOrderList.details)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.appTheme()
        self.orderTableView.reloadData()
       }

       override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
           // Trait collection will change. Use this one so you know what the state is changing to.
       }
}
