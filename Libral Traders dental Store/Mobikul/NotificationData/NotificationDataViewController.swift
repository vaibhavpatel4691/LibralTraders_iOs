//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: NotificationDataViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class NotificationDataViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: NotificationViewModel!
    var emptyView: EmptyView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Notifications".localized
        tableView.register(cellType: NotificationDataTableViewCell.self)
        viewModel = NotificationViewModel()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        self.callRequest()
        appTheme()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if emptyView == nil {
            emptyView = EmptyView(frame: self.view.frame)
            self.view.addSubview(emptyView)
            emptyView.isHidden = true
                emptyView.emptyImages.addSubview(LottieHandler.sharedInstance.initializeLottie(bounds: emptyView.emptyImages.bounds, fileName: "CategoryFile"))
                //                emptyView.emptyImages.image = UIImage(named: "illustration-search")
               // emptyView.actionBtn.setTitle("Show All Categories".localized, for: .normal)
                emptyView.labelMessage.text = "No notification found here".localized
                emptyView.titleText.text = "Oops!".localized
            emptyView.actionBtn.isHidden = true
            
            emptyView.actionBtn.addTapGestureRecognizer {
            }
        }
    }
    
    func callRequest() {
        viewModel?.callingHttppApi { [weak self] success in
            guard let self = self else { return }
            if success {
                if self.viewModel.model.notificationList.count > 0 {
                    self.emptyView.isHidden = true

                } else {
                    self.emptyView.isHidden = false

                }
                self.tableView.delegate = self.viewModel
                self.tableView.dataSource = self.viewModel
                self.tableView.reloadData()
                //                self.priceLabel.text = self.cartViewModalObject?.cartModel.grandtotal?.value
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
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        DispatchQueue.main.async {
            self.appTheme()
        }
       }

          override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
              // Trait collection will change. Use this one so you know what the state is changing to.
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
