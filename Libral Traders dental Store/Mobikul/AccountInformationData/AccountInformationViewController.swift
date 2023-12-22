//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: AccountInformationViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class AccountInformationViewController: UIViewController {
    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var deleteAccountBtn: UIButton!
    var viewModel: AccountInformationViewModal!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            //self.view.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        setView()
        self.navigationItem.title = "Account Information".localized
        deleteAccountBtn.setTitle("Delete Account", for: .normal)
        viewModel = AccountInformationViewModal()
        viewModel.tableView = tableView
        btn.setTitle("Save".localized.uppercased(), for: .normal)
        self.prepareSubViews()
        self.callRequest()
        // Do any additional setup after loading the view.
    }
    func setView() {
        if Defaults.language == "ar" {
            L102Language.setAppleLAnguageTo(lang: "ar")
            if #available(iOS 9.0, *) {
                UINavigationBar.appearance().semanticContentAttribute = .forceRightToLeft
                UITabBar.appearance().semanticContentAttribute = .forceRightToLeft
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
                UITableView.appearance().semanticContentAttribute = .forceRightToLeft
                UITextField.appearance().semanticContentAttribute = .forceRightToLeft
            } else {
                // Fallback on earlier versions
            }
        } else {
            L102Language.setAppleLAnguageTo(lang: "en")
            if #available(iOS 9.0, *) {
                UINavigationBar.appearance().semanticContentAttribute = .forceLeftToRight
                UITabBar.appearance().semanticContentAttribute =  .forceLeftToRight
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
                UITableView.appearance().semanticContentAttribute = .forceLeftToRight
                UITextField.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                // Fallback on earlier versions
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        theme()
    }
    
    func theme() {
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                self.btn.backgroundColor = AppStaticColors.darkButtonBackGroundColor
                self.btn.setTitleColor(AppStaticColors.darkButtonTextColor, for: .normal)
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
                self.btn.backgroundColor = AppStaticColors.buttonBackGroundColor
                self.btn.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
            }
        } else {
            self.btn.backgroundColor = AppStaticColors.buttonBackGroundColor
            self.btn.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
            UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
            self.navigationController?.navigationBar.barTintColor = AppStaticColors.primaryColor
            self.navigationController?.navigationBar.tintColor = AppStaticColors.itemTintColor
            UINavigationBar.appearance().tintColor = AppStaticColors.itemTintColor
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
        }
        
    }
    @IBAction func btnClicked(_ sender: Any) {
        viewModel?.saveAddressClicked { _ in
            self.navigationController?.popViewController(animated: true)
        }
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        DispatchQueue.main.async {
            self.theme()
            self.tableView.reloadData()
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        // Trait collection will change. Use this one so you know what the state is changing to.
    }
    
    private func prepareSubViews() {
        //Prepare tableView
        FormItemCellType.registerCells(for: self.tableView)
        self.tableView.allowsSelection = false
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
    func callRequest() {
        viewModel?.callingHttppApi { [weak self] success in
            guard let self = self else { return }
            if success {
                self.tableView.delegate = self.viewModel
                self.tableView.dataSource = self.viewModel
                self.tableView.reloadData()
                self.setView()
                //                self.priceLabel.text = self.cartViewModalObject?.cartModel.grandtotal?.value
            } else {
                
            }
        }
    }
    //MARK: - delete account
    
    @IBAction func deleteAccountAct(_ sender: Any) {
       
        let msg = "Deleting your account will result in removing all tha data of your account associated with" + " " + (Defaults.customerEmail ?? "") + " " + "from your services. This action can’t be undone."
                
        // search for word occurrence
        let range = (msg as NSString).range(of: (Defaults.customerEmail ?? ""))
       
           var myMutableString = NSMutableAttributedString()
           myMutableString = NSMutableAttributedString(string: msg as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Montserrat-Medium", size: 14.0)!])
           myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: range)
           
       
        let AC = UIAlertController(title: "Delete Account".localized, message: ""
                                   
                                   , preferredStyle: .alert)
        AC.setValue(myMutableString, forKey: "attributedMessage")
        AC.addTextField { (textField) in
            
            textField.placeholder = "Password".localized
            textField.isSecureTextEntry = true
            textField.text = ""
            let button = UIButton(type: .custom)
            textField.textContentType = UITextContentType(rawValue: "")
            button.setImage(UIImage(named: "closePassword"), for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            button.backgroundColor = .white
            button.addTapGestureRecognizer {
                textField.isSecureTextEntry = !textField.isSecureTextEntry
                if textField.isSecureTextEntry {
                    button.setImage(UIImage(named: "closePassword"), for: .normal)
                } else {
                    button.setImage(UIImage(named: "seePassword"), for: .normal)
                }
            }
            
            if Defaults.language == "ar" {
                button.frame = CGRect(x: CGFloat(25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
                textField.rightView = button
                textField.leftView = nil
                textField.rightViewMode = .always
                
            } else {
                textField.rightView = button
                textField.leftView = nil
                textField.rightViewMode = .always
                button.frame = CGRect(x: CGFloat(textField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
            }
        }
        let okBtn = UIAlertAction(title: "delete".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            let textField = AC.textFields![0]
            guard let password = textField.text, password.count>1 else {
                self.showWarningSnackBar(msg: "Please enter the password".localized)
                self.present(AC, animated: true, completion: {  })
                return
            }
            self.viewModel.apiType = "login"
            var dict = [String: String]()
            dict["username"] = Defaults.customerEmail ?? ""
            dict["password"] = password
            self.viewModel.callingHttppApi(completion: { success in
                if success {
                    self.viewModel.apiType = "deleteAccount"
                    self.viewModel.callingHttppApi(completion: { success in
                        if success {
                            for i in UserDefaults.standard.dictionaryRepresentation() {
                                if i.key == Defaults.Key.appleLanguages.rawValue || i.key == Defaults.Key.currency.rawValue || i.key == Defaults.Key.deviceToken.rawValue || i.key == Defaults.Key.language.rawValue || i.key == Defaults.Key.storeId.rawValue || i.key == Defaults.Key.customerId.rawValue {
                                    
                                } else {
                                    
                                    print(i.key)
                                    
                                    UserDefaults.standard.removeObject(forKey: i.key)
                                    
                                    UserDefaults.standard.synchronize()
                                    
                                }
                                
                            }
                            LaunchHome.shared.launchHomeTabbar()
                            //self.navigationController?.popViewController(animated: true)
                        } else {
                            
                        }
                    }, ["customerToken": Defaults.customerToken ?? ""])//Defaults.customerToken ?? ""
                   
                } else {
                    
                }
            }, dict)
        })
        let noBtn = UIAlertAction(title: "Cancel".localized, style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(okBtn)
        AC.addAction(noBtn)
        self.present(AC, animated: true, completion: {  })
    }
    
     
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
