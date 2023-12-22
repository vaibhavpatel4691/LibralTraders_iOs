//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: OrderAndReturnsDataViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */


import UIKit

class OrderAndReturnsDataViewController: UIViewController {
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    fileprivate var form = Form()
    var requstParams = [String: Any]()
    var extraArry = ["Email Address".localized, "Zip Code".localized]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Order and Returns".localized
        self.submitBtn.setTitle("Submit".localized, for: .normal)
        theme()

        self.prepareSubViews()
        // Do any additional setup after loading the view.
    }
    
    func theme() {
        if #available(iOS 12.0, *) {

            if self.traitCollection.userInterfaceStyle == .dark {
                submitBtn.backgroundColor = AppStaticColors.darkButtonBackGroundColor
                submitBtn.setTitleColor(AppStaticColors.darkButtonTextColor, for: .normal)

             UINavigationBar.appearance().barTintColor = AppStaticColors.darkPrimaryColor
             self.navigationController?.navigationBar.barTintColor = AppStaticColors.darkPrimaryColor
             self.navigationController?.navigationBar.tintColor = AppStaticColors.darkItemTintColor
             UINavigationBar.appearance().tintColor = AppStaticColors.darkItemTintColor
             self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.darkItemTintColor]
             UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.darkItemTintColor]
                

            } else {
                submitBtn.backgroundColor = AppStaticColors.buttonBackGroundColor
                submitBtn.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
             UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
             self.navigationController?.navigationBar.barTintColor = AppStaticColors.primaryColor
             self.navigationController?.navigationBar.tintColor = AppStaticColors.itemTintColor
             UINavigationBar.appearance().tintColor = AppStaticColors.itemTintColor
             self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
             UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
             
         }
        } else {
            submitBtn.backgroundColor = AppStaticColors.buttonBackGroundColor
            submitBtn.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
           UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
            self.navigationController?.navigationBar.barTintColor = AppStaticColors.primaryColor
            self.navigationController?.navigationBar.tintColor = AppStaticColors.itemTintColor
            UINavigationBar.appearance().tintColor = AppStaticColors.itemTintColor
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]

        }
    }
    private func prepareSubViews() {
        //Prepare tableView
        FormItemCellType.registerCells(for: self.tableView)
        self.tableView.allowsSelection = false
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.doFurtherProcessingWithResult()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
         self.tableView.delegate = self
         self.tableView.dataSource = self
         self.tableView.reloadData()
         theme()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        // Trait collection will change. Use this one so you know what the state is changing to.
    }
    
    func doFurtherProcessingWithResult() {
        self.createTextField(placeholder: "Order Id".localized, isRequired: true, key: "incrementId")
        self.createTextField(placeholder: "Billing Last Name".localized, isRequired: true, key: "lastName")
        self.createDropDown(placeholder: "Find Order By".localized, key: "type", prifixData: extraArry, isRequired: false, heading: "suffix".localized, image: UIImage(named: "sharp-arrow-top")!)
        self.createTextField(placeholder: "Email Address".localized, isRequired: true, key: "email")
        self.tableView.reloadData()
        
    }
    
    @IBAction func SubmitClicked(_ sender: Any) {
        if !form.isValid().0 {
            let orderReturnsData =  (form.getFormData())

            if (form.isValid().1 == "Email Address".localized) && (orderReturnsData["email"]as? String ?? "") != "" {
                
                ShowNotificationMessages.sharedInstance.warningView(message: form.isValid().1 + " " + "input value is not valid".localized)
            } else {
                ShowNotificationMessages.sharedInstance.warningView(message: "Enter the".localized + " " + form.isValid().1)
            }
        } else {
            var dict  = form.getFormData()
            dict["type"] = dict["type"] as? String == "Email Address".localized ? "email" : "zip"
            
            if dict["zipCode"] == nil {
                dict["zipCode"] = ""
            }
            if dict["email"] == nil {
                dict["email"] = ""
            }
            requstParams = dict
            self.callingHttppApi()
        }
    }
    
    func createTextField(placeholder: String, isRequired: Bool = false, pwdType: Bool = false, key: String = "", valiidationType: String = "") {
        let fieldItem = FormItem(placeholder: placeholder)
        fieldItem.uiProperties.cellType = FormItemCellType.textField
        fieldItem.isRequired = isRequired
        fieldItem.isSecure = pwdType
        fieldItem.keyType = key
        fieldItem.valiidationType = valiidationType
        fieldItem.valueCompletion = { [weak fieldItem] value in
            fieldItem?.value = value
        }
        self.form.formItems.append(fieldItem)
    }
    
    func createDropDown(placeholder: String, key: String = "", prifixData: [String], isRequired: Bool = false, heading: String = "", image: UIImage) {
        let fieldItem = FormItem(placeholder: placeholder)
        fieldItem.uiProperties.cellType = FormItemCellType.singleDropDown
        fieldItem.prifixData = prifixData
        fieldItem.isRequired = true
        fieldItem.keyType = key
        fieldItem.rightIcon = image
        fieldItem.heading = heading
        self.form.formItems.append(fieldItem)
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
extension OrderAndReturnsDataViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.form.formItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 3  {
            if let val = form.getFormData()["type"] as? String {
                if val == "Email Address".localized {
                    if form.formItems[3].keyType != "email" {
                        form.formItems[3].keyType = "email"
                        form.formItems[3].emailType = true
                        form.formItems[3].placeholder = "Email Address".localized
                    }
                }
                
                if val == "Zip Code".localized {
                    if form.formItems[3].keyType != "Zip Code" {
                        form.formItems[3].keyType = "zipCode"
                        form.formItems[3].emailType = false
                        form.formItems[3].placeholder = "Zip Code".localized
                    }
                }
                
            }
        }
        
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
    
    
    func callingHttppApi() {
        NetworkManager.sharedInstance.showLoader()
        
        requstParams["storeId"] = Defaults.storeId
        requstParams["width"] = UrlParams.width
        requstParams["quoteId"] = Defaults.quoteId
        
        NetworkManager.sharedInstance.callingHttpRequest(params: requstParams, method: .post, apiname: .guestview, currentView: UIViewController()) { [weak self] success, responseObject  in
            NetworkManager.sharedInstance.dismissLoader()
            if success == 1 {                
                let jsonResponse =  JSON(responseObject as? NSDictionary ?? [:])
                if jsonResponse["success"].boolValue == true {
                    let viewController = OrderDetailsDataViewController.instantiate(fromAppStoryboard: .customer)
                    viewController.orderId = self?.requstParams["incrementId"] as? String
                    let nav = UINavigationController(rootViewController: viewController)
                    //nav.navigationBar.tintColor = AppStaticColors.accentColor
                    nav.modalPresentationStyle = .fullScreen
                    self?.present(nav, animated: true, completion: nil)
                    
                } else {
                    if jsonResponse["message"].stringValue.removeWhiteSpace.count > 0 {
                        ShowNotificationMessages.sharedInstance.warningView(message: jsonResponse["message"].stringValue)
                    } else {
                        ShowNotificationMessages.sharedInstance.warningView(message: "Something went wrong, Please try again!!".localized)
                    }
                }
            } else if success == 2 {   // Retry in case of error
                NetworkManager.sharedInstance.dismissLoader()
                self?.callingHttppApi()
            }
        }
    }
    
    
}
