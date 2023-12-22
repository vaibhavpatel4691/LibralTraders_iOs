//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: ProductReviewListViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class ProductReviewListViewController: UIViewController {
    
    var viewModel: ProductReviewListViewModel!
    var emptyView: EmptyView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "My Reviews List".localized
        viewModel = ProductReviewListViewModel()
        viewModel.obj = self
        tableView.register(cellType: DashboardReviewTableViewCell.self)
        tableView.tableFooterView = UIView()
        //        tableView.separatorStyle = .none
        
        self.callRequest()
        viewModel.callBackPagination = { [weak self] in
            self?.callRequest()
        }
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
            self.appTheme()
       }

          override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
              // Trait collection will change. Use this one so you know what the state is changing to.
          }
    override func viewWillAppear(_ animated: Bool) {
        
        if emptyView == nil {
            emptyView = EmptyView(frame: self.view.frame)
            self.view.addSubview(emptyView)
            emptyView.isHidden = true
            emptyView.emptyImages.addSubview(LottieHandler.sharedInstance.initializeLottie(bounds: emptyView.emptyImages.bounds, fileName: "ReviewFile"))
            //            emptyView.emptyImages.image = UIImage(named: "illustration-review")
            emptyView.actionBtn.setTitle("View Orders and review".localized, for: .normal)
            emptyView.labelMessage.text = "You didn’t review any of the items yet.".localized
            emptyView.titleText.text = "No Reviews".localized
            emptyView.actionBtn.addTapGestureRecognizer {
                self.emptyClicked()
            }
        }
    }
    
    func emptyClicked() {
        let orderDetails = OrderListViewController.instantiate(fromAppStoryboard: .customer)
        self.navigationController?.pushViewController(orderDetails, animated: true)
    }
    
    
    func callRequest() {
        viewModel?.callingHttppApi { [weak self] success in
            guard let self = self else { return }
            if success {
                
                if self.viewModel.model.reviewList.count > 0 {
                    self.emptyView.isHidden = true
                    self.tableView.isHidden = false
                    self.tableView.delegate = self.viewModel
                    self.tableView.dataSource = self.viewModel
                    self.tableView.reloadData()
                } else {
                    LottieHandler.sharedInstance.playLoattieAnimation()
                    self.emptyView.isHidden = false
                    self.tableView.isHidden = true
                    
                }
                
                
                //                self.priceLabel.text = self.cartViewModalObject?.cartModel.grandtotal?.value
            } else {
                
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
