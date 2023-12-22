//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: CreateAnAccountViewController.swift
 Copyright (c) 2010-2021 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit
import Firebase

class CreateAnAccountViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: SaveFooterView!
    var viewModel: CreateAnAccountViewModel!
    var customerDetails: AccountInformationModel!
    var socialRequiredCheck = false
    var parentController = ""
    var orderId = ""
    var mobileNo = ""
    var callback: (()->())?
    weak var delegate: LoginPop?
    var countryData = [GetCountryData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create an Account".localized
        self.prepareSubViews()
        viewModel = CreateAnAccountViewModel()
        viewModel.customerDetails = customerDetails
        viewModel.tableView = tableView
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        viewModel.socialRequiredCheck = socialRequiredCheck
        viewModel.footerView = footerView
        viewModel.delegate = self
        viewModel.orderId = orderId
        viewModel.mobile = mobileNo
        
        //MARK:- SIGN_UP Analytics

        Analytics.setScreenName("CreateAccount", screenClass: "CreateAnAccountViewController.class")
        viewModel.newAccountClousre = {[weak self] customerToken in
            Analytics.logEvent("SIGN_UP", parameters: ["id":customerToken])

        }
        self.callRequest()
        // Do any additional setup after loading the view.
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
            self.tableView.reloadData()
            if self.footerView != nil {
                self.footerView.theme()
            }
        }
    }

       override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
           // Trait collection will change. Use this one so you know what the state is changing to.
       }
    private func prepareSubViews() {
        //Prepare tableView
        FormItemCellType.registerCells(for: self.tableView)
        self.tableView.register(cellType: PasswordTableViewCell.self)
        self.tableView.register(cellType: NewsLaterCheckTableViewCell.self)
        #if MARKETPLACE || HYPERLOCAL
        self.tableView.register(cellType: RegisterSellerTableViewCell.self)
        #endif
        self.tableView.allowsSelection = false
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
    func callRequest() {
        viewModel?.callingHttppApi { [weak self] success in
            guard let self = self else { return }
            NetworkManager.sharedInstance.dismissLoader()
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                if self.viewModel.saveData {
                    self.dismiss(animated: true, completion: {
                        self.delegate?.loginPop()
                        self.callback?()
                    })
                }
            } else {
                
            }
        }
    }
    
    @IBAction func backAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension CreateAnAccountViewController: moveToControlller {
    func moveController(id: String, name: String, dict: [String: Any], jsonData: JSON, index: Int, controller: AllControllers) {
        if controller == .none {
            if self.viewModel.saveData {
                LaunchHome.shared.launchHomeTabbar()
                self.delegate?.loginPop()
                self.callback?()
//                self.dismiss(animated: true, completion: {
//
//                })
            }
        } else {
            if parentController == "signIn" {
                self.navigationController?.popViewController(animated: true)
            } else {
                let customerLoginVC = LoginViewController.instantiate(fromAppStoryboard: .customer)
                customerLoginVC.parentController = "signUp"
                customerLoginVC.delegate = delegate
                self.navigationController?.pushViewController(customerLoginVC, animated: true)
            }
            
        }
        
    }
    
}
