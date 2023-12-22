import UIKit

class AdvanceSearchDataViewController: UIViewController {
    
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var advanceSearchModel: AdvanceSearchViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationItem.title = "Advance Search".localized
        self.prepareSubViews()

        advanceSearchModel = AdvanceSearchViewModel()
        advanceSearchModel?.tableView = tableView
        tableView.delegate = advanceSearchModel
        tableView.dataSource = advanceSearchModel
        searchBtn.setTitle("Search".localized, for: .normal)
        appTheme()
        advanceSearchModel?.callingHttppApi()
        //        self.callingHttppApi()
        // Do any additional setup after loading the view.
    }
    
    private func prepareSubViews() {
        //Prepare tableView
        FormItemCellType.registerCells(for: self.tableView)
        self.tableView.allowsSelection = false
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
    
    @IBAction func searchClicked(_ sender: Any) {
        advanceSearchModel?.advanceSearchClicked { getData in
            let nextController = CategoryProductsViewController.instantiate(fromAppStoryboard: .product)
            nextController.categoryId = getData
            nextController.titleName = "Products".localized
            nextController.categoryType = "advSearch"
            self.navigationController?.pushViewController(nextController, animated: true)
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
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                searchBtn.backgroundColor = AppStaticColors.darkButtonBackGroundColor
                searchBtn.setTitleColor(AppStaticColors.darkButtonTextColor, for: .normal)
            } else {
                searchBtn.backgroundColor = AppStaticColors.buttonBackGroundColor
                searchBtn.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
            }
        } else {
            searchBtn.backgroundColor = AppStaticColors.buttonBackGroundColor
            searchBtn.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
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

}
