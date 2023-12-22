//
//  SearchDataViewController.swift
//  Mobikul Single App
//
//  Created by bhavuk.chawla on 03/01/19.
//  Copyright © 2019 kunal. All rights reserved.
//

import UIKit

class SearchDataViewController: UIViewController {
    
    @IBOutlet weak var advanceSearchBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var micBtn: UIBarButtonItem!
    @IBOutlet weak var camerabtn: UIBarButtonItem!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBackgroundView: UIView!
    
    let defaults = UserDefaults.standard
    var searchViewModel: SearchViewModel?
    var categories = [Categories]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Search Products".localized
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        backBtn.image = backBtn.image?.withRenderingMode(.alwaysTemplate).flipImage()
        theme()
        if Defaults.language == "ar" {
            advanceSearchBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        }
        advanceSearchBtn.setTitle("MAKE AN ADVANCE SEARCH".localized, for: .normal)
        self.textFieldDataChanges()
    }
    func theme() {
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                advanceSearchBtn.backgroundColor = AppStaticColors.darkButtonBackGroundColor
                advanceSearchBtn.setTitleColor(AppStaticColors.darkButtonTextColor, for: .normal)
                backBtn.tintColor = AppStaticColors.darkItemTintColor
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

                backBtn.tintColor = AppStaticColors.itemTintColor

                advanceSearchBtn.backgroundColor = AppStaticColors.buttonBackGroundColor
                advanceSearchBtn.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
            }
        } else {
            backBtn.tintColor = AppStaticColors.itemTintColor
            UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
            self.navigationController?.navigationBar.barTintColor = AppStaticColors.primaryColor
            self.navigationController?.navigationBar.tintColor = AppStaticColors.itemTintColor
            UINavigationBar.appearance().tintColor = AppStaticColors.itemTintColor
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]

            advanceSearchBtn.backgroundColor = AppStaticColors.buttonBackGroundColor
            advanceSearchBtn.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
        }


    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        DispatchQueue.main.async {
            self.theme()
            self.textFieldDataChanges()
        }
       }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        // Trait collection will change. Use this one so you know what the state is changing to.
    }

    func textFieldDataChanges() {
        searchViewModel = SearchViewModel()
        searchViewModel?.categories = self.categories
        searchViewModel?.delegate = self
        searchBar.placeholder = "Search For Products".localized
       // self.navigationItem.titleView = self.searchBar
        searchBar.delegate = self
        searchBar.textField?.backgroundColor = .clear
        tableView.register(cellType: SearchCategoryTableViewCell.self)
        tableView.register(cellType: SearchPageSuggestionTableViewCell.self)
        tableView.delegate = searchViewModel
        tableView.dataSource = searchViewModel
        tableView.tableFooterView = UIView()
        
        searchViewModel?.tableView = tableView
        searchViewModel?.reloadInfoWithData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //searchTextField.becomeFirstResponder()
        searchBar.becomeFirstResponder()
        searchBar.setShowsCancelButton(true, animated: true)
        self.searchBackgroundView.backgroundColor = UIColor().hexToColor(hexString: "bdf977")
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.textColor = UIColor.black
            searchTextField.backgroundColor = UIColor.white
            searchTextField.tintColor = UIColor.black // Set cursor color
        }
        
    }
    
    @IBAction func backClicked(_ sender: UIBarButtonItem) {
        self.backPress()
    }
    
    @IBAction func advanceSearchClicked(_ sender: Any) {
        let viewController = AdvanceSearchDataViewController.instantiate(fromAppStoryboard: .search)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func micClicked(_ sender: Any) {
        let viewController = AudioDetectionViewController.instantiate(fromAppStoryboard: .search)
        viewController.delegate = self
        let nav = UINavigationController(rootViewController: viewController)
        //nav.navigationBar.tintColor = AppStaticColors.accentColor
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func cameraClicked(_ sender: Any) {
        let viewController = CameraSearchViewController.instantiate(fromAppStoryboard: .search)
        let nav = UINavigationController(rootViewController: viewController)
        //nav.navigationBar.tintColor = AppStaticColors.accentColor
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func searchCharcterChange(_ sender: UITextField) {
        self.searchViewModel?.serachQueryText(query: sender.text ?? "", taskCallback: {[weak self] (data) in
            if data {
                self?.searchViewModel?.reloadInfoWithData()
            }
        })
    }
}

extension SearchDataViewController: SeachProtocols {
    
    func productListFromQuery(query: String) {
        let nextController = CategoryProductsViewController.instantiate(fromAppStoryboard: .product)
        nextController.categoryId = ""
        nextController.titleName = query
        nextController.categoryId = query
        nextController.searchText = query
        nextController.categoryType = "search"
        self.navigationController?.pushViewController(nextController, animated: true)
    }
    
    func productListFromCategory(id: String, name: String) {
        let nextController = CategoryProductsViewController.instantiate(fromAppStoryboard: .product)
        nextController.categoryId = id
        nextController.titleName = name
        nextController.categoryType = "category"
        self.navigationController?.pushViewController(nextController, animated: true)
    }
    
    func productFromCategory(id: String, name: String) {
        let nextController = ProductPageDataViewController.instantiate(fromAppStoryboard: .product)
        nextController.productId = id
        nextController.productName = name
        self.navigationController?.pushViewController(nextController, animated: true)
    }
    
    func productFromSubCategory(id: String, name: String) {
        let viewController = SubCategoriesViewController.instantiate(fromAppStoryboard: .product)
        viewController.categoryId = id
        viewController.categoryName = name
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension SearchDataViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchBar.isLoading = true
        self.searchViewModel?.serachQueryText(query: searchBar.text ?? "", taskCallback: {[weak self] (data) in
            if data {
                self?.searchBar.isLoading = false
                self?.searchViewModel?.reloadInfoWithData()
            }
        })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text, text.count > 0 {
            self.productListFromQuery(query: text)
            if Defaults.searchEnable == "1" {
                self.addSearcheQueryToDatabase(text: text)
            }
        }
    }
    
    func addSearcheQueryToDatabase(text: String) {
        let searchedData = SearchModel(data: text)
        do {
            try DBManager.sharedInstance.database?.write {
                DBManager.sharedInstance.database?.add(searchedData, update: .all)
            }
        } catch  let error {
            print(error.localizedDescription)
        }
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

}

extension UISearchBar {
    
    public var textField: UITextField? {
        let subViews = subviews.flatMap { $0.subviews }
        guard let textField = (subViews.filter { $0 is UITextField }).first as? UITextField else {
            return nil
        }
        return textField
    }
    
    public var activityIndicator: UIActivityIndicatorView? {
        return textField?.leftView?.subviews.compactMap{ $0 as? UIActivityIndicatorView }.first
    }
    
    var isLoading: Bool {
        get {
            return activityIndicator != nil
        } set {
            if newValue {
                if activityIndicator == nil {
                    let newActivityIndicator = UIActivityIndicatorView(style: .gray)
                    newActivityIndicator.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                    newActivityIndicator.startAnimating()
                    newActivityIndicator.backgroundColor = UIColor.white
                    textField?.leftView?.addSubview(newActivityIndicator)
                    let leftViewSize = textField?.leftView?.frame.size ?? CGSize.zero//CGSize(width: 20, height: 20)
                    newActivityIndicator.center = CGPoint(x: leftViewSize.width/2, y: leftViewSize.height/2)
                }
            } else {
                activityIndicator?.removeFromSuperview()
            }
        }
    }
}
