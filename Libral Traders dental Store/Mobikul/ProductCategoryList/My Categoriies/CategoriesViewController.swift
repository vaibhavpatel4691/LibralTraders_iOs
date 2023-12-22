
import UIKit

class CategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Noon App category Section
    @IBOutlet weak var noonCategoryView: UIView!
    @IBOutlet weak var mainCategoryTable: UITableView!
    @IBOutlet weak var noonSubCategoryTableView: UITableView!
    var selectedMAinCategory = ""
    var model: SubCategoryModel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categoryTableView: UITableView!
    var tempCategoryData: NSMutableArray = []
    var tempCategoryId: NSMutableArray = []
    var categoryMenuData: NSMutableArray = []
    var headingTitleData: NSMutableArray = []
    var categoryDict: NSDictionary = [:]
    var categoryName: String!
    var categoryId: String!
    var categoryChildData: NSArray!
    var loaderCheckForFisrtTime = 0
    var items = [CategoryViewModelItem]()
    var homeViewModel: HomeViewModel? {
        get {
            guard let navigationController = self.tabBarController?.viewControllers?[0] as? UINavigationController else { return nil }
            guard let viewControllerHome = navigationController.viewControllers[0] as? ViewController else { return nil }
            return viewControllerHome.homeViewModel
        }
        set {
            guard let navigationController = self.tabBarController?.viewControllers?[0] as? UINavigationController else { return }
            guard let viewControllerHome = navigationController.viewControllers[0] as? ViewController else { return }
            viewControllerHome.homeViewModel = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loaderCheckForFisrtTime += 1
        self.navigationItem.title = "Categories".localized
        categoryTableView.register(UINib(nibName: "CategoryListTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryListTableViewCell")
        mainCategoryTable.register(cellType: NoonMainCategoryListTableViewCell.self)
        noonSubCategoryTableView.register(cellType: HomeBannerTableViewCell.self)
        noonSubCategoryTableView.register(cellType: RelatedProductTableViewCell.self)
        noonSubCategoryTableView.register(cellType: CategoryPageSubCategoryNoonTableViewCell.self)
        categoryMenuData = tempCategoryData
        mainCategoryTable.backgroundColor = UIColor.groupTableViewBackground

        if #available(iOS 12.0, *) {
                   if self.traitCollection.userInterfaceStyle == .dark {
                       // User Interface is Dark
                   } else {
                        categoryTableView!.backgroundColor = UIColor.clear
                   }
               } else {
                      categoryTableView!.backgroundColor = UIColor.clear
               }
              
        
        let refreshControl = UIRefreshControl()
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let attributedTitle = NSAttributedString(string: "refreshing".localized, attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        
        self.showOfflineBar()
    }
    func appTheme() {
        if #available(iOS 12.0, *) {

            if self.traitCollection.userInterfaceStyle == .dark {
                self.navigationItem.leftBarButtonItem?.tintColor = AppStaticColors.darkItemTintColor
                self.navigationItem.rightBarButtonItem?.tintColor = AppStaticColors.darkItemTintColor
             UINavigationBar.appearance().barTintColor = AppStaticColors.darkPrimaryColor
             self.navigationController?.navigationBar.barTintColor = AppStaticColors.darkPrimaryColor
             self.navigationController?.navigationBar.tintColor = AppStaticColors.darkItemTintColor
             UINavigationBar.appearance().tintColor = AppStaticColors.darkItemTintColor
             self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.darkItemTintColor]
             UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.darkItemTintColor]
                

            } else {
                self.navigationItem.leftBarButtonItem?.tintColor = AppStaticColors.itemTintColor
                self.navigationItem.rightBarButtonItem?.tintColor = AppStaticColors.itemTintColor
             UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
             self.navigationController?.navigationBar.barTintColor = AppStaticColors.primaryColor
             self.navigationController?.navigationBar.tintColor = AppStaticColors.itemTintColor
             UINavigationBar.appearance().tintColor = AppStaticColors.itemTintColor
             self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
             UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
             
         }
        } else {
            self.navigationItem.leftBarButtonItem?.tintColor = AppStaticColors.itemTintColor
            self.navigationItem.rightBarButtonItem?.tintColor = AppStaticColors.itemTintColor
           UINavigationBar.appearance().barTintColor = AppStaticColors.primaryColor
            self.navigationController?.navigationBar.barTintColor = AppStaticColors.primaryColor
            self.navigationController?.navigationBar.tintColor = AppStaticColors.itemTintColor
            UINavigationBar.appearance().tintColor = AppStaticColors.itemTintColor
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppStaticColors.itemTintColor]

        }
        if categoryLayoutMode == 1 {
            
            noonCategoryView.isHidden = false
            mainCategoryTable.isHidden = false
            noonCategoryView.isHidden = false
            categoryTableView.isHidden = true
            guard let categories = self.homeViewModel?.categories, categories.count != 0 else { return }
            if categories.count > 0 {
                if selectedMAinCategory.isEmpty {
                   selectedMAinCategory = categories[0].id
                   categoryName = categories[0].name

                }
                
                mainCategoryTable.delegate = self
                mainCategoryTable.dataSource = self
                mainCategoryTable.reloadData()
                callingHttppApi { (success) in
                    if success {
                        self.loaderCheckForFisrtTime = 2
                        self.noonSubCategoryTableView.delegate = self
                        self.noonSubCategoryTableView.dataSource = self
                        self.noonSubCategoryTableView.reloadData()
                        NetworkManager.sharedInstance.dismissLoader()

                        
                    } else {
                        self.loaderCheckForFisrtTime = 2
                        NetworkManager.sharedInstance.dismissLoader()
                    }
                }
                 
            }
        } else {
            noonCategoryView.isHidden = true
            mainCategoryTable.isHidden = true
            noonCategoryView.isHidden = true
            categoryTableView.isHidden = false
            categoryTableView.delegate = self
            categoryTableView.dataSource = self
            categoryTableView.reloadData()
        }
        self.tabBarController?.tabBar.isHidden = false
        if loaderCheckForFisrtTime > 1 {
            NetworkManager.sharedInstance.dismissLoader()
        }
        NetworkManager.sharedInstance.removePreviousNetworkCall()

    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            self.appTheme()
       }

          override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
              // Trait collection will change. Use this one so you know what the state is changing to.
          }

    override func viewWillAppear(_ animated: Bool) {
        self.appTheme()
    }
    @IBAction func searchClicked(_ sender: Any) {
        let viewController = SearchDataViewController.instantiate(fromAppStoryboard: .search)
        viewController.categories = homeViewModel?.categories ?? []
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if categoryLayoutMode == 1 {
            if tableView == mainCategoryTable {
                return 1
            } else if tableView == noonSubCategoryTableView {
                return items.count
            }
           
        } else {
            return 1
        }
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if categoryLayoutMode == 1 {
            if tableView == mainCategoryTable {
                guard let categories = self.homeViewModel?.categories, categories.count != 0 else { return 0 }
                return categories.count
            } else if tableView == noonSubCategoryTableView {
                let item = items[section]
                
                switch item.type {
                case .banner:
                    return 1
                default:
                    return items[section].rowCount
                }
            }
        } else {
            guard let categories = self.homeViewModel?.categories, categories.count != 0 else { return 0 }
            return categories.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if categoryLayoutMode == 1 {
            if tableView == mainCategoryTable {
            if let cell = tableView.dequeueReusableCell(withIdentifier: NoonMainCategoryListTableViewCell.identifier, for: indexPath)as? NoonMainCategoryListTableViewCell {
                guard let categories = self.homeViewModel?.categories, categories.count != 0 else { return UITableViewCell() }
                cell.categoryLbl.text = categories[indexPath.row].name ?? ""
                

                if selectedMAinCategory == categories[indexPath.row].id ?? "" {
                    //UIColor.white
                    cell.sideViewWidth.constant = 3
                    cell.categoryLbl.font = UIFont.boldSystemFont(ofSize: 12.0)
                    if #available(iOS 13.0, *) {
                        
                        if self.traitCollection.userInterfaceStyle == .dark {
                            cell.categoryLbl.textColor = AppStaticColors.darkButtonBackGroundColor
                            cell.categoryNameBackView.backgroundColor = AppStaticColors.darkButtonTextColor
                            cell.categoryLbl.backgroundColor = AppStaticColors.darkButtonTextColor
                            cell.sideView.backgroundColor = AppStaticColors.darkButtonBackGroundColor
                        } else {
                            cell.categoryNameBackView.backgroundColor = AppStaticColors.buttonTextColor
                            cell.categoryLbl.backgroundColor = AppStaticColors.buttonTextColor

                            cell.categoryLbl.textColor = AppStaticColors.buttonBackGroundColor
                            cell.sideView.backgroundColor = AppStaticColors.buttonBackGroundColor

                        }
                    } else {
                        cell.categoryNameBackView.backgroundColor = AppStaticColors.buttonTextColor
                        cell.categoryLbl.backgroundColor = AppStaticColors.buttonTextColor

                        cell.categoryLbl.textColor = AppStaticColors.buttonBackGroundColor
                        cell.sideView.backgroundColor = AppStaticColors.buttonBackGroundColor

                    }
                } else {
                    cell.categoryNameBackView.backgroundColor = UIColor.groupTableViewBackground
                    cell.categoryLbl.backgroundColor = UIColor.groupTableViewBackground
                    cell.categoryLbl.font = UIFont.systemFont(ofSize: 12.0)
                    cell.sideViewWidth.constant = 0
                    if #available(iOS 13.0, *) {
                        if self.traitCollection.userInterfaceStyle == .dark {
                            
                            cell.categoryLbl.textColor = UIColor.white

                        } else {
                            cell.categoryLbl.textColor = UIColor.black

                        }
                    } else {
                        cell.categoryLbl.textColor = UIColor.black

                    }
                }
                //cell.categoryImg.setImage(fromURL: categories[indexPath.row].thumbnail ?? "", placeholder:  UIImage(named: "placeholder"))
                //cell.categoryImg.backgroundColor = UIColor.clear
                cell.selectionStyle = .none
                return cell
            }
            } else if tableView == noonSubCategoryTableView {
                let item = items[indexPath.section]
                switch item.type {
                case .banner:
                    if let cell: HomeBannerTableViewCell = tableView.dequeueReusableCell(with: HomeBannerTableViewCell.self, for: indexPath),
                        let item = item as? CatgeoryViewModelBannerItem {
                        cell.bannerCollection.tag = indexPath.section
                        cell.banner = item.banner
                        #if  B2B || HYPERLOCAL || GROCERY || MARKETPLACE
                        cell.type = "subCategory"
                        #else
                        cell.type = "tabCategory"
                        #endif
                        
                        cell.bannerCollection.reloadData()
                        cell.layoutIfNeeded()
                        cell.selectionStyle = .none
                        return cell
                    }
                    case .product:
                        if let cell: RelatedProductTableViewCell = tableView.dequeueReusableCell(with: RelatedProductTableViewCell.self, for: indexPath),
                            let items = item as? CategoryViewModalProductItem {
                            cell.selectionStyle = .none
                            cell.headingLabelClicked.text = items.productHeading.uppercased()
                            cell.relatedList = items.productList
                            cell.viewAllBtn.isHidden = false
                            cell.viewAllBtn.addTapGestureRecognizer {
                                let nextController = CategoryProductsViewController.instantiate(fromAppStoryboard: .product)
                                nextController.categoryId = self.selectedMAinCategory
                                
                                nextController.titleName = self.categoryName
                                nextController.categoryType = "category"
                                //            nextController.categories = self.homeViewModel.categories
                                self.navigationController?.pushViewController(nextController, animated: true)
                            }
                            cell.collectionView.reloadData()
                            //tableView.separatorStyle = .singleLine
                            return cell
                        }
                    case .hotSeller:
                        if let cell: RelatedProductTableViewCell = tableView.dequeueReusableCell(with: RelatedProductTableViewCell.self, for: indexPath),
                            let items = item as? CategoryViewModalHotSellerItem {
                            cell.selectionStyle = .none
                            cell.viewAllBtn.isHidden = true
                            cell.headingLabelClicked.text = items.productHeading.uppercased()
                            cell.relatedList = items.productList
                            cell.collectionView.reloadData()
                            tableView.separatorStyle = .singleLine
                            return cell
                        }
                        
                case .categories:
                    if let cell: CategoryPageSubCategoryNoonTableViewCell = tableView.dequeueReusableCell(with: CategoryPageSubCategoryNoonTableViewCell.self, for: indexPath), let items = item as? CategoryViewModalCategoriewsItem {
                         let list = items.categoryList[indexPath.row].childCategoriesData
                            if (items.categoryList[indexPath.row].collapse ?? false) {
                               cell.categoriesList = nil
                            } else {
                               cell.categoriesList = list
                            }
                            if list.count > 0 {
                               cell.collapseImg.isHidden = false
                            } else {
                               cell.collapseImg.isHidden = true
                            }
                        
                        if items.categoryList[indexPath.row].banner.isEmpty {
                            
                            cell.bannerHeight.constant = 0
                        } else {
                            cell.bannerImage.contentMode = .scaleAspectFit
                           // cell.bannerImage.setImage(fromURL: items.categoryList[indexPath.row].banner, dominantColor: items.categoryList[indexPath.row].bannerDominantColor)
                            cell.bannerHeight.constant = 0//3*(AppDimensions.screenWidth - 116 ) / 8
                        }
                        cell.heading.text =  items.categoryList[indexPath.row].name.uppercased()
                        cell.collapseImg.image = UIImage(named: "sharp-arrow-bottom")
                        cell.headingView.addTapGestureRecognizer {
                            items.categoryList[indexPath.row].collapse = !(items.categoryList[indexPath.row].collapse ?? false)
                            print((items.categoryList[indexPath.row].collapse ?? false))
                            self.noonSubCategoryTableView.reloadData()
                        }
                       
                        //tableView.separatorStyle = .none
                        
                        if Defaults.language == "ar" {
                            cell.textLabel?.textAlignment = .right
                        } else {
                            cell.textLabel?.textAlignment = .left
                        }
                        //cell.subCategoryCollectionView.reloadData()
                        cell.subCategoryCollectionView.reloadData()
                        //cell.collectionHeight.constant = cell.subCategoryCollectionView.collectionViewLayout.collectionViewContentSize.height
                        cell.layoutIfNeeded()
                        cell.selectionStyle = .none
                        //cell.subCategoryCollectionView.reloadData()
                        return cell
                    }

            }
        }
        } else {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryListTableViewCell", for: indexPath)as? CategoryListTableViewCell {
            guard let categories = self.homeViewModel?.categories, categories.count != 0 else { return UITableViewCell() }
            cell.categoryNameLbl.text = categories[indexPath.row].name ?? ""
            cell.categoryImg.setImage(fromURL: categories[indexPath.row].thumbnail ?? "", placeholder:  UIImage(named: "placeholder"))
            cell.categoryImg.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
             
            cell.theme()
            return cell
        }
    }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if categoryLayoutMode == 1 {
            if tableView == mainCategoryTable {
            guard let categories = self.homeViewModel?.categories, categories.count != 0 else { return }
            selectedMAinCategory = categories[indexPath.row].id
            categoryName = categories[indexPath.row].name
            callingHttppApi { (success) in
                if success {
                    self.noonSubCategoryTableView.delegate = self
                    self.noonSubCategoryTableView.dataSource = self
                    self.noonSubCategoryTableView.reloadData()
                }
            }
            mainCategoryTable.reloadData()
            }  
        } else {
        guard let categories = self.homeViewModel?.categories, categories.count != 0 else { return }
        
        if categories[indexPath.row].hasChildren {
            let viewController = SubCategoriesViewController.instantiate(fromAppStoryboard: .product)
            viewController.categoryId = categories[indexPath.row].id
            viewController.categoryName = categories[indexPath.row].name
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            let nextController = CategoryProductsViewController.instantiate(fromAppStoryboard: .product)
            nextController.categoryId = categories[indexPath.row].id
            nextController.titleName = categories[indexPath.row].name
            nextController.categoryType = "category"
            //            nextController.categories = self.homeViewModel.categories
            self.navigationController?.pushViewController(nextController, animated: true)
        }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if categoryLayoutMode == 1 {
            if tableView == mainCategoryTable {
                return UITableView.automaticDimension
                
            } else if tableView == noonSubCategoryTableView {
                let item = items[indexPath.section]
                
                switch item.type {
                case .banner:
                    #if  B2B || HYPERLOCAL || GROCERY || MARKETPLACE
                    return 2*(AppDimensions.screenWidth - 116 ) / 3
                    #else
                    return 3*(AppDimensions.screenWidth - 116 ) / 8
                    #endif
                    
                case .categories:

                    if let items = item as? CategoryViewModalCategoriewsItem {
                        let list = items.categoryList[indexPath.row].childCategoriesData
                            if (items.categoryList[indexPath.row].collapse ?? false) {
                               return 50
                            } else {
                           
                        if list.count > 0 {
                            var categoryCount = (list.count/3)
                            if (list.count % 3 != 0 ) {
                                categoryCount = (categoryCount + 1)
                                let height = (4*((AppDimensions.screenWidth - 116 ) / 3)/5) + 50
                                categoryCount = (categoryCount * Int(height))
                                if items.categoryList[indexPath.row].banner.isEmpty {
                                    return CGFloat(categoryCount) + 66
                                } else {
                                    let bannerHeight = 3*(AppDimensions.screenWidth - 116 ) / 8
                                    return CGFloat(categoryCount) + 66 + 0//bannerHeight

                                }
                            } else {
                                let height = (4*((AppDimensions.screenWidth - 116 ) / 3)/5) + 50
                                categoryCount = (categoryCount * Int(height))
                                if items.categoryList[indexPath.row].banner.isEmpty {
                                    return CGFloat(categoryCount) + 66

                                } else {
                                    let bannerHeight = 3*(AppDimensions.screenWidth - 116 ) / 8
                                    return CGFloat(categoryCount) + 66 + 0//bannerHeight

                                }

                            }
                        }
                    }
                        
                    }
                    return UITableView.automaticDimension//((AppDimensions.screenWidth - 116 ) / 3) + 50
                default:
                    return UITableView.automaticDimension
                }
            }
            
        } else {
            return 57
        }
        return UITableView.automaticDimension
    }
    
}

extension CategoriesViewController: MoveController {
    func moveController(id: String, name: String, dict: DictType, jsonData: JSON, type: String, controller: AllControllers) {
        self.navigationController?.navigationBar.isHidden = false
        
        switch controller {
        case .productcategory:
            print()
            //            let nextController = Productcategory.instantiate(fromAppStoryboard: .main)
            //            nextController.categoryId = id
            //            nextController.categoryName = name
            //            nextController.categoryType = type
            //            self.navigationController?.pushViewController(nextController, animated: true)
            
        default:
            break
        }
    }
}

