//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: ProductCategoryFilterViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class ProductCategoryFilterViewController: UIViewController {
    
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var filterTblView: UITableView!
    @IBOutlet weak var filtersTitle: UILabel!
    @IBOutlet weak var clearAllBtn: UIButton!
    var layeredData =  [LayeredData]()
    var topIdArray = [String]()
    var subIdArray = [String]()
    var subNameArray = [String]()
    var productCategoryFilterViewModel = ProductCategoryFilterViewModel()
    weak var delegate: FilterDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyBtn.setTitle("Apply".localized, for: .normal)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "Filters".localized
        // Do any additional setup after loading the view.
        filtersTitle.text = "Filters".localized
        clearAllBtn.setTitle("Clear All".localized.uppercased(), for: .normal)
        productCategoryFilterViewModel.filterDelegate = self
        productCategoryFilterViewModel.subIdArray = subIdArray
        productCategoryFilterViewModel.subNameArray = subNameArray
        productCategoryFilterViewModel.topIdArray = topIdArray
        clearAllBtn.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        clearAllBtn.layer.borderWidth = 1.0
        appTheme()
        filterTblView.register(FilterListTableViewCell.nib, forCellReuseIdentifier: FilterListTableViewCell.identifier)
        filterTblView.register(cellType: SelectedFilterTableViewCell.self)
        filterTblView.rowHeight = UITableView.automaticDimension
        filterTblView.estimatedRowHeight = 200
        filterTblView.delegate = productCategoryFilterViewModel
        filterTblView.dataSource = productCategoryFilterViewModel
        productCategoryFilterViewModel.layeredData = layeredData
        filterTblView.tableFooterView = UIView()
        self.filterTblView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
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
            self.filterTblView.reloadData()
        }
       }

          override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
              // Trait collection will change. Use this one so you know what the state is changing to.
          }
    @IBAction func clearAllBtnClicked(_ sender: UIButton) {
        productCategoryFilterViewModel.clearAll { _ in
            self.filterTblView.reloadData()
            delegate?.filterData(topIdArray: [], subIdArray: [], subNameArray: [])
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func applyBtnClicked(_ sender: Any) {
        productCategoryFilterViewModel.fetchSelectedArray { (topIdArray, subIdArray, subNameArray) in
            if topIdArray.count > 0 {
                delegate?.filterData(topIdArray: topIdArray, subIdArray: subIdArray, subNameArray: subNameArray)
                self.navigationController?.popViewController(animated: true)
            } else {
                ShowNotificationMessages.sharedInstance.warningView(message: "Please select fillters")
            }
        }
    }
}

extension ProductCategoryFilterViewController: FilterDelegate {
    func filterData(topIdArray: [String], subIdArray: [String], subNameArray: [String]) {
        delegate?.filterData(topIdArray: topIdArray, subIdArray: subIdArray, subNameArray: subNameArray)
        self.navigationController?.popViewController(animated: true)
    }
}

protocol FilterDelegate: NSObjectProtocol {
    func filterData(topIdArray: [String], subIdArray: [String], subNameArray: [String])
}
