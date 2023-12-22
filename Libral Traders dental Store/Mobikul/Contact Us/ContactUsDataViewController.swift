//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: ContactUsDataViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class ContactUsDataViewController: UIViewController {
    
    fileprivate var form = Form()
    @IBOutlet weak var senMessageBtn: UIButton!
    var dataDict = [String: Any]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        senMessageBtn.backgroundColor = AppStaticColors.buttonBackGroundColor
        senMessageBtn.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
        self.navigationItem.title = "Contact Us".localized
        senMessageBtn.setTitle("Submit".localized, for: .normal)
        self.prepareSubViews()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.createTextField(placeholder: "Name".localized, isRequired: true, key: "name", heading: "Name".localized, value: Defaults.customerName ?? "")
        self.createTextField(placeholder: "Email".localized, isRequired: true, key: "email", heading: "Email".localized, value: Defaults.customerEmail ?? "")
        self.createTextField(placeholder: "Phone Number".localized, isRequired: false, key: "telephone", heading: "Phone Number".localized)
        self.createTextView(placeholder: "What's on your mind?".localized, isRequired: true, key: "comment", heading: "What's on your mind?".localized)
        self.theme()
        self.tableView.reloadData()
        
        // Do any additional setup after loading the view.
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.theme()
        self.tableView.reloadData()
    }
    func theme() {
        if #available(iOS 12.0, *) {
            
            if self.traitCollection.userInterfaceStyle == .dark {
                
                
                senMessageBtn.backgroundColor = AppStaticColors.darkButtonBackGroundColor
                senMessageBtn.setTitleColor(AppStaticColors.darkButtonTextColor, for: .normal)
                UINavigationBar.appearance().barTintColor = AppStaticColors.darkPrimaryColor
                self.navigationController?.navigationBar.barTintColor = AppStaticColors.darkPrimaryColor
                self.navigationController?.navigationBar.tintColor = AppStaticColors.darkItemTintColor
                UINavigationBar.appearance().tintColor = AppStaticColors.darkItemTintColor
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.darkItemTintColor]
                UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.darkItemTintColor]
                
                
            } else {
                
                senMessageBtn.backgroundColor = AppStaticColors.buttonBackGroundColor
                senMessageBtn.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
                UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
                self.navigationController?.navigationBar.barTintColor = AppStaticColors.primaryColor
                self.navigationController?.navigationBar.tintColor = AppStaticColors.itemTintColor
                UINavigationBar.appearance().tintColor = AppStaticColors.itemTintColor
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
                UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
                
            }
        } else {
            
            senMessageBtn.backgroundColor = AppStaticColors.buttonBackGroundColor
            senMessageBtn.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
            UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
            self.navigationController?.navigationBar.barTintColor = AppStaticColors.primaryColor
            self.navigationController?.navigationBar.tintColor = AppStaticColors.itemTintColor
            UINavigationBar.appearance().tintColor = AppStaticColors.itemTintColor
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
            
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        // Trait collection will change. Use this one so you know what the state is changing to.
    }
    private func prepareSubViews() {
        //Prepare tableView
        FormItemCellType.registerCells(for: self.tableView)
        self.tableView.allowsSelection = false
        self.tableView.estimatedRowHeight = 180
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
    
    func callingHttppApi(completion: @escaping (Bool) -> Void) {
        NetworkManager.sharedInstance.showLoader()
        
        var requstParams = [String: Any]()
        
        requstParams = dataDict
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .post, apiname: .contactPost, currentView: UIViewController()) { [weak self] success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            guard let self = self else { return }
            if success == 1 {                
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                if jsonResponse["success"].boolValue == true {
                    print(jsonResponse)
                    ShowNotificationMessages.sharedInstance.showSuccessSnackBar(message: jsonResponse["message"].stringValue)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    if jsonResponse["message"].stringValue.removeWhiteSpace.count > 0 {
                        ShowNotificationMessages.sharedInstance.warningView(message: jsonResponse["message"].stringValue)
                    } else {
                        ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
                    }
                }
            } else if success == 2 {   // Retry in case of error
                NetworkManager.sharedInstance.dismissLoader()
                self.callingHttppApi {success in
                    completion(success)
                    
                }
            } else if success == 3 {   // No Changes
                //                let jsonResponse =  DBManager.sharedInstance.getJSONDatafromDatabase(hashKey: GetHashKey.sharedInstance.getHashKey(controllerName: "addressData"))
                //                self.doFurtherProcessingWithResult(data: jsonResponse) { success in
                //                    completion(success)
                //                }
                
            }
        }
    }
    
    @IBAction func contactUsClicked(_ sender: Any) {
        if !form.isValid().0 {
            let contactUsInfoData =  (form.getFormData())
            if (form.isValid().1 == "Email".localized) && (contactUsInfoData["email"]as? String ?? "") != "" {
                ShowNotificationMessages.sharedInstance.warningView(message: form.isValid().1 + " " + "input value is not valid".localized)
            } else {
                ShowNotificationMessages.sharedInstance.warningView(message: "Enter the".localized + " " + form.isValid().1)
            }
        } else {
            dataDict = form.getFormData()
            self.callingHttppApi { _ in
                
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func createTextField(placeholder: String, isRequired: Bool = false, pwdType: Bool = false, key: String = "", heading: String, valiidationType: String = "", value: String = "") {
        let fieldItem = FormItem(placeholder: placeholder)
        fieldItem.uiProperties.cellType = FormItemCellType.textField
        fieldItem.isRequired = isRequired
        fieldItem.isSecure = pwdType
        fieldItem.keyType = key
        fieldItem.heading = heading
        fieldItem.valiidationType = valiidationType
        fieldItem.value = value
        if key == "telephone" {
            fieldItem.uiProperties.keyboardType = .numberPad
        }
        
        if key == "email" {
            fieldItem.emailType = true
        }
        
        
        fieldItem.valueCompletion = { [weak fieldItem] value in
            fieldItem?.value = value
        }
        self.form.formItems.append(fieldItem)
    }
    
    func createTextView(placeholder: String, isRequired: Bool = false, pwdType: Bool = false, key: String = "", heading: String, valiidationType: String = "") {
        let fieldItem = FormItem(placeholder: placeholder)
        fieldItem.uiProperties.cellType = FormItemCellType.textView
        fieldItem.isRequired = isRequired
        fieldItem.isSecure = pwdType
        fieldItem.keyType = key
        fieldItem.heading = heading
        fieldItem.valiidationType = valiidationType
        
        fieldItem.valueCompletion = { [weak fieldItem] value in
            fieldItem?.value = value
        }
        self.form.formItems.append(fieldItem)
    }
    
}

extension ContactUsDataViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.form.formItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.form.formItems[indexPath.row]
        let cell: UITableViewCell
        if let cellType = self.form.formItems[indexPath.row].uiProperties.cellType {
            cell = cellType.dequeueCell(for: tableView, at: indexPath)
        } else {
            cell = UITableViewCell() //or anything you want
        }
        self.form.formItems[indexPath.row].indexPath = indexPath
        //        cell.backgroundColor = UIColor.yellow
        if let formUpdatableCell = cell as? FormUpdatable {
            item.indexPath = indexPath
            formUpdatableCell.update(with: item)
        }
        cell.contentView.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
