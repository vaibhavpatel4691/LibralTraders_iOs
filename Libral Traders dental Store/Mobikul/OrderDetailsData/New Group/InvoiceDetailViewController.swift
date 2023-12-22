//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: InvoiceDetailViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class InvoiceDetailViewController: UIViewController {
    var viewModel: InvoiceViewModel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var printBarBtnItem: UIBarButtonItem!
    var invoiceId: String!
    var id = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appTheme()
        self.navigationItem.title = "Invoice".localized + " - #" + invoiceId
        tableView.register(cellType: InvoiceProductListTableViewCell.self)
        tableView.register(cellType: CartPriceTableViewCell.self)
        tableView.register(ProductSectionHeading.nib, forHeaderFooterViewReuseIdentifier: ProductSectionHeading.identifier)
        viewModel = InvoiceViewModel(invoiceId: invoiceId)
        viewModel.id = id
        tableView.tableFooterView = UIView()
        //        tableView.separatorStyle = .none
        self.callRequest()
        // Do any additional setup after loading the view.
    }
    func appTheme() {
        if #available(iOS 12.0, *) {

            if self.traitCollection.userInterfaceStyle == .dark {
                printBarBtnItem.tintColor = AppStaticColors.darkItemTintColor
             UINavigationBar.appearance().barTintColor = AppStaticColors.darkPrimaryColor
             self.navigationController?.navigationBar.barTintColor = AppStaticColors.darkPrimaryColor
             self.navigationController?.navigationBar.tintColor = AppStaticColors.darkItemTintColor
             UINavigationBar.appearance().tintColor = AppStaticColors.darkItemTintColor
             self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.darkItemTintColor]
             UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.darkItemTintColor]
                

            } else {
                printBarBtnItem.tintColor = AppStaticColors.itemTintColor
             UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
             self.navigationController?.navigationBar.barTintColor = AppStaticColors.primaryColor
             self.navigationController?.navigationBar.tintColor = AppStaticColors.itemTintColor
             UINavigationBar.appearance().tintColor = AppStaticColors.itemTintColor
             self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
             UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
             
         }
        } else {
            printBarBtnItem.tintColor = AppStaticColors.itemTintColor
           UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
            self.navigationController?.navigationBar.barTintColor = AppStaticColors.primaryColor
            self.navigationController?.navigationBar.tintColor = AppStaticColors.itemTintColor
            UINavigationBar.appearance().tintColor = AppStaticColors.itemTintColor
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]

        }
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            self.appTheme()
       }

          override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
              // Trait collection will change. Use this one so you know what the state is changing to.
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
    
    @IBAction func crossClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func printerClick(_ sender: UIBarButtonItem) {
        let pdffile = self.tableView.exportAsPdfFromTable()
        print(pdffile)
        let printController = UIPrintInteractionController.shared
        
        if let documrntURL =  pdffile{
            if UIPrintInteractionController.canPrint(documrntURL) {
                let printInfo = UIPrintInfo(dictionary: nil)
                printInfo.jobName = "PDF File"
                printInfo.outputType = .photo
                printController.printInfo = printInfo
                printController.showsNumberOfCopies = true
                printController.showsPageRange = true
                printController.printingItem = documrntURL
                printController.present(animated: true, completionHandler: nil)
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
}
