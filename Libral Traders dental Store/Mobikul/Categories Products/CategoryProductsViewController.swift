//
//  CategoryProductsViewController.swift
//  Mobikul Single App
//
//  Created by akash on 27/01/19.
//  Copyright © 2019 kunal. All rights reserved.
//

import UIKit
import Firebase

class CategoryProductsViewController: UIViewController {
    
    @IBOutlet weak var sortFilterGridListView: SortFilterGridListView!
    @IBOutlet weak var sortFilterHeight: NSLayoutConstraint!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var cartBtn: BadgeBarButtonItem!
    @IBOutlet weak var searchBtn: UIBarButtonItem!
    var categoryProductsViewModal = CategoryProductsViewModal()
    var categoryId: String!
    var categoryType: String!
    var selectedSortIndex: Int!
    var searchQuery: String!
    var titleName = ""
    var searchText = ""
    var emptyView: EmptyView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.titleName
        Analytics.setScreenName("CategoryProducts", screenClass: "CategoryProductsViewController.class")
        self.sortFilterGridListView.shadowBorder()
        self.categoryProductsViewModal.productDegisn = .grid
        self.categoryProductsViewModal.categoryId = categoryId
        self.categoryProductsViewModal.categoryType = categoryType
        self.categoryProductsViewModal.searchQuery = searchQuery
        //        self.categoryProductsViewModal.categories = categories
        self.categoryProductsViewModal.sortFilterHeight = sortFilterHeight
        //        if self.categories.count == 0 {
        //            self.sortFilterHeight.constant = 56
        //        }
        categoryProductsViewModal.moveDelegate = self
        self.setGridListView()
        self.sortFilterGridListView.delegate = self
        self.categoryProductsViewModal.delegate = self
        cartBtn.badgeNumber = Int(Defaults.cartBadge) ?? 0
        self.productsCollectionView.register(cellType: GridProductCollectionViewCell.self)
        self.productsCollectionView.register(cellType: ListProductCollectionViewCell.self)
        self.productsCollectionView.register(reusableViewType: CategoryHeaderCollectionReusableView.self, ofKind: UICollectionView.elementKindSectionHeader, bundle: nil)
        self.categoryProductsViewModal.productsCollectionView = self.productsCollectionView
        appTheme()
        //        if searchText.count > 0 {
        //            self.categoryProductsViewModal.apiName = .searchQuery
        //            self.categoryProductsViewModal.searchText =  searchText
        //        }
        
        #if MARKETPLACE || BTOB || HYPERLOCAL
        if self.categoryType == "sellercollection" {
            self.categoryProductsViewModal.apiName = .sellerCollection
        }
        #endif
        
        self.categoryProductsViewModal.callingHttppApi(apiName: self.categoryProductsViewModal.apiName) { (success, _) in
            if success {
                self.reloadingCollectionView()
            } else {}
        }
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
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
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        DispatchQueue.main.async {
            self.appTheme()
            if self.emptyView != nil {
                self.emptyView.theme()
            }
        }
       }

          override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
              // Trait collection will change. Use this one so you know what the state is changing to.
          }
    override func viewWillAppear(_ animated: Bool) {
        
        if emptyView == nil {
            emptyView = EmptyView(frame: self.view.frame)
            self.view.addSubview(emptyView)
            emptyView.isHidden = true
            if categoryType != "search" {
                emptyView.emptyImages.addSubview(LottieHandler.sharedInstance.initializeLottie(bounds: emptyView.emptyImages.bounds, fileName: "CategoryFile"))
                //                emptyView.emptyImages.image = UIImage(named: "illustration-search")
                emptyView.actionBtn.setTitle("Show All Categories".localized, for: .normal)
                emptyView.labelMessage.text = "No products found here".localized
                emptyView.titleText.text = "Oops!".localized
            } else {
                emptyView.emptyImages.addSubview(LottieHandler.sharedInstance.initializeLottie(bounds: emptyView.emptyImages.bounds, fileName: "SearchFile"))
                //                emptyView.emptyImages.image = UIImage(named: "illustration-category")
                emptyView.actionBtn.setTitle("Search Again".localized, for: .normal)
                emptyView.labelMessage.text = "No search results found".localized
                emptyView.titleText.text = "Umm..".localized
            }
            
            emptyView.actionBtn.addTapGestureRecognizer {
                self.emptyClicked()
            }
        }
    }
    @IBAction func cartClicked(_ sender: UIBarButtonItem) {
        let viewController = CartDataViewController.instantiate(fromAppStoryboard: .product)
        let nav = UINavigationController(rootViewController: viewController)
        //nav.navigationBar.tintColor = AppStaticColors.accentColor
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func searchClicked(_ sender: UIBarButtonItem) {
        let viewController = SearchDataViewController.instantiate(fromAppStoryboard: .search)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    func emptyClicked() {
        if categoryType != "search" {
            self.tabBarController?.selectedIndex = 1
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func setGridListView() {
        switch self.categoryProductsViewModal.productDegisn {
        case .grid?:
            sortFilterGridListView.gridListBtn.setTitle("grid".localized, for: .normal)
            sortFilterGridListView.gridListBtn.setImage(UIImage(named: "grid"), for: .normal)
        case .list?:
            sortFilterGridListView.gridListBtn.setTitle("list".localized, for: .normal)
            sortFilterGridListView.gridListBtn.setImage(UIImage(named: "ic_list"), for: .normal)
        case .none:
            break
        }
        let index = IndexPath(row: 0, section: 0)
        if let headerView = productsCollectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: index) as? CategoryHeaderCollectionReusableView {
            switch self.categoryProductsViewModal.productDegisn {
            case .grid?:
                headerView.sortFilterGridListView.gridListBtn.setTitle("grid".localized, for: .normal)
                headerView.sortFilterGridListView.gridListBtn.setImage(UIImage(named: "grid"), for: .normal)
            case .list?:
                headerView.sortFilterGridListView.gridListBtn.setTitle("list".localized, for: .normal)
                headerView.sortFilterGridListView.gridListBtn.setImage(UIImage(named: "ic_list"), for: .normal)
            case .none:
                break
            }
        }
    }
}

extension CategoryProductsViewController: SortFilterGridListActions, SortingDelegate {
    func tappedSort() {
        if let productModal = self.categoryProductsViewModal.categoryProductsModal {
            let vc = SortViewController.instantiate(fromAppStoryboard: .product)
            vc.modalPresentationStyle = .overCurrentContext
            vc.selectedSortIndex = self.selectedSortIndex
            vc.getSortCollectionData = productModal.sortingData ?? []
            vc.delegate = self
            NetworkManager.sharedInstance.topMostController().present(vc, animated: true, completion: nil)
        }
    }
    
    func tappedFilter() {
        if let productModal = self.categoryProductsViewModal.categoryProductsModal {
            if !productModal.layeredData.isEmpty || self.categoryProductsViewModal.subIdArray.count > 0 {
                let vc = ProductCategoryFilterViewController.instantiate(fromAppStoryboard: .product)
                vc.layeredData = productModal.layeredData
                vc.topIdArray = self.categoryProductsViewModal.topIdArray
                vc.subIdArray = self.categoryProductsViewModal.subIdArray
                vc.subNameArray  = self.categoryProductsViewModal.subNameArray
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                ShowNotificationMessages.sharedInstance.warningView(message: "No filter options are available".localized)
            }
        }
    }
    
    func tappedGridList() {
        if self.categoryProductsViewModal.productDegisn == .grid {
            self.categoryProductsViewModal.productDegisn = .list
        } else {
            self.categoryProductsViewModal.productDegisn = .grid
        }
        self.setGridListView()
        self.productsCollectionView.reloadData()
    }
    
    func sortBy(index: Int) {
        if let sortArray = self.categoryProductsViewModal.categoryProductsModal.sortingData, index < sortArray.count {
            self.selectedSortIndex = index
            self.categoryProductsViewModal.page = 1
            self.categoryProductsViewModal.sortItem = self.categoryProductsViewModal.categoryProductsModal.sortingData?[index]
            self.categoryProductsViewModal.callingHttppApi(apiName: self.categoryProductsViewModal.apiName) { (success, _) in
                if success {
                    self.reloadingCollectionView()
                }
            }
        }
    }
    
    func reloadingCollectionView() {
        if let productList = self.categoryProductsViewModal.categoryProductsModal.productList, productList.count > 0 {
            if categoryType.lowercased().contains("search"){
                
                //MARK:- SEARCH Analytics

                Analytics.setScreenName("SearchPage", screenClass: "SearchDataViewController.class")
                Analytics.logEvent("SEARCH", parameters: ["text":titleName])

            }
            if categoryProductsViewModal.sortItem != nil {
                sortFilterGridListView.sortApplyView.isHidden = false
            } else {
                sortFilterGridListView.sortApplyView.isHidden = true
            }
            
            if  categoryProductsViewModal.topIdArray.count > 0 {
                sortFilterGridListView.filterApplyView.isHidden = false
            } else {
                sortFilterGridListView.filterApplyView.isHidden = true
            }
            self.productsCollectionView.isHidden = false
            self.emptyView.isHidden = true
            self.productsCollectionView.delegate = self.categoryProductsViewModal
            self.productsCollectionView.dataSource = self.categoryProductsViewModal
            self.productsCollectionView.reloadData()
            NetworkManager.sharedInstance.dismissLoader()
        } else {
            self.productsCollectionView.reloadData()
            if self.categoryProductsViewModal.sortItem != nil || self.categoryProductsViewModal.subIdArray.count > 0 {
                self.productsCollectionView.isHidden = false
                sortFilterGridListView.sortApplyView.isHidden = false
                self.view.bringSubviewToFront(sortFilterGridListView)
            } else {
                sortFilterGridListView.sortApplyView.isHidden = true
                self.productsCollectionView.isHidden = true
            }
            LottieHandler.sharedInstance.playLoattieAnimation()
            self.emptyView.isHidden = false
            NetworkManager.sharedInstance.dismissLoader()
        }
        
    }
    
}
extension CategoryProductsViewController: MoveController {
    func moveController(id: String, name: String, dict: DictType, jsonData: JSON, type: String, controller: AllControllers) {
        if controller == .signInController {
            let customerLoginVC = LoginViewController.instantiate(fromAppStoryboard: .customer)
            customerLoginVC.signInHandler = {
                if let productID = dict["productID"] as? String, let index = dict["index"] as? Int {
                    self.categoryProductsViewModal.productID = productID
                    self.categoryProductsViewModal.callingHttppApi(apiName: .addToWishList) { (success, jsonResponse) in
                        if success {
                            self.categoryProductsViewModal.categoryProductsModal.productList?[index].addItemId(wishlistItemId: jsonResponse["itemId"].stringValue)
                            self.categoryProductsViewModal.categoryProductsModal.productList?[index].isInWishlist = true
                            self.productsCollectionView.reloadData()
                        }
                    }
                }
            }
            let nav = UINavigationController(rootViewController: customerLoginVC)
            nav.modalPresentationStyle = .fullScreen
            //nav.navigationBar.tintColor = AppStaticColors.accentColor
            self.present(nav, animated: true, completion: nil)
        } else {
            let nextController = ProductPageDataViewController.instantiate(fromAppStoryboard: .product)
            nextController.productId = id
            nextController.productName = name
            self.navigationController?.pushViewController(nextController, animated: true)
        }
    }
}
extension CategoryProductsViewController: FilterDelegate {
    func filterData(topIdArray: [String], subIdArray: [String], subNameArray: [String]) {
        self.categoryProductsViewModal.page = 1
        self.categoryProductsViewModal.topIdArray = topIdArray
        self.categoryProductsViewModal.subIdArray = subIdArray
        self.categoryProductsViewModal.subNameArray = subNameArray
        self.categoryProductsViewModal.callingHttppApi(apiName: self.categoryProductsViewModal.apiName) { (success, _) in
            if success {
                self.reloadingCollectionView()
            }
        }
    }
    
}

