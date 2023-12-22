//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: MoreDataViewController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class MoreDataViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var sectionCount = 0
    var cmsData = [CMSdata]()
    
    var homeViewModel: HomeViewModel {
        guard let navigationController = self.tabBarController?.viewControllers?[0] as? UINavigationController,
            let viewControllerHome = navigationController.viewControllers[0] as? ViewController else {
                return HomeViewModel()
        }
        return viewControllerHome.homeViewModel
    }
    
    var preferencesData = [[String]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "More".localized
        tableView?.register(ProductSectionHeading.nib, forHeaderFooterViewReuseIdentifier: ProductSectionHeading.identifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        preferencesData = []
        if homeViewModel.allowedCurrencies.count > 1 {
            preferencesData.append(["Currency", "Currency".localized])
        }
        if homeViewModel.storeData.count > 0 {
            if !(homeViewModel.storeData.count == 1 && (homeViewModel.storeData.first?.stores.count ?? 0) <= 1) {
                preferencesData.append(["Language", "Language".localized])
            }
        }
        preferencesData.append(["Settings", "Settings".localized])
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
    override func viewWillAppear(_ animated: Bool) {
        self.appTheme()
        self.tabBarController?.tabBar.isHidden = false
        cmsData = homeViewModel.cmsData
        sectionCount = 4
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.appTheme()
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
    @IBAction func searchBarButtonClicked(_ sender: UIBarButtonItem) {
        let viewController = SearchDataViewController.instantiate(fromAppStoryboard: .search)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension MoreDataViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            if homeViewModel.websiteData.count > 1 {
                return homeViewModel.websiteData.count
            }
        case 1:
            return preferencesData.count
        case 2:
            return cmsData.count
        case 3:
            return 1
        default:
            return 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProductSectionHeading.identifier) as? ProductSectionHeading {
            if section == 0 &&  homeViewModel.websiteData.count > 1 {
                headerView.titleLabel?.text = "Websites".localized.uppercased()
            } else  if section == 0 &&  homeViewModel.storeData.count < 2 {
                return nil
            } else if section == 1 {
                headerView.titleLabel?.text = "Preferences".localized.uppercased()
            } else if section == 2 {
                headerView.titleLabel?.text = "Others".localized.uppercased()
            } else {
                return nil
            }
            headerView.arrowLabel.isHidden = true
            headerView.setBackgroundViewColor(color: UIColor(named: "ShadedColor")!)
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 3 {
            return 0
        }
        if section == 0 && homeViewModel.websiteData.count < 2 {
            return 0
        }
        return 56
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = AppStaticColors.systemGrayColor
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = AppStaticColors.systemGrayColor
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.font = UIFont.myBoldSystemFont(ofSize: 17)
        cell.accessoryType = .disclosureIndicator
        switch indexPath.section {
        case 0:
            if homeViewModel.websiteData.count > 1 {
                cell.textLabel?.text = homeViewModel.websiteData[indexPath.row].name
                if homeViewModel.websiteData[indexPath.row].id == UrlParams.defaultWebsiteId {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            }
        case 1:
            cell.textLabel?.text = preferencesData[indexPath.row][1]
            switch preferencesData[indexPath.row][1] {
            case "Language":
                if let language = Defaults.language {
                    if let index = homeViewModel.storeData.firstIndex(where: { $0.id == UrlParams.defaultWebsiteId }) {
                        let selectedLanguage = (homeViewModel.storeData[index].stores.filter({$0.code == language})).first?.name ?? ""
                        if selectedLanguage != "" {
                            cell.textLabel?.text = preferencesData[indexPath.row][1] + " - \(selectedLanguage)"
                        }
                    }
                }
            case "Currency":
                if let currency = Defaults.currency {
                    let selectedCurrency = (homeViewModel.allowedCurrencies.filter({$0.code == currency})).first?.label ?? ""
                    if selectedCurrency != "" {
                        cell.textLabel?.text = preferencesData[indexPath.row][1] + " - \(selectedCurrency)"
                    }
                }
            default:
                break
            }
        case 2:
            cell.textLabel?.text = cmsData[indexPath.row].title
        case 3:
            cell.textLabel?.text = "Contact Us".localized
        default:
            break
        }
        if Defaults.language == "ar" {
            cell.textLabel?.textAlignment = .right
        } else {
            cell.textLabel?.textAlignment = .left
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 && homeViewModel.websiteData.count < 2 {
            return 0
        }
        return 8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tabBarController?.tabBar.isHidden = true
        if indexPath.section == 0 {
            Defaults.storeId = ""
            Defaults.websiteId = homeViewModel.websiteData[indexPath.row].id
            UrlParams.defaultWebsiteId = homeViewModel.websiteData[indexPath.row].id
            LaunchHome.shared.launchHome()
        }
        if indexPath.section == 1 {
            let viewController = LanguageCurrencyDataViewController.instantiate(fromAppStoryboard: .more)
            switch preferencesData[indexPath.row][0] {
            case "Language":
                if let index = homeViewModel.storeData.firstIndex(where: { $0.id == UrlParams.defaultWebsiteId }) {
                    //viewController.languageData = homeViewModel.storeData[index].stores
                    viewController.languageData = homeViewModel.storeData
                    viewController.navTitle = "Languages".localized
                    let nav = UINavigationController(rootViewController: viewController)
                    //nav.navigationBar.tintColor = AppStaticColors.accentColor
                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav, animated: true, completion: nil)
                }
            case "Currency":
                viewController.allowedCurrencies = homeViewModel.allowedCurrencies
                viewController.navTitle = "Currencies".localized
                let nav = UINavigationController(rootViewController: viewController)
                //nav.navigationBar.tintColor = AppStaticColors.accentColor
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            case "Settings":
                let viewController = SettingsDataViewController.instantiate(fromAppStoryboard: .more)
                let nav = UINavigationController(rootViewController: viewController)
                //nav.navigationBar.tintColor = AppStaticColors.accentColor
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            default:
                break
            }
        }
        if indexPath.section == 2 {
            let viewController = CMSPageData.instantiate(fromAppStoryboard: .more)
            viewController.cmsId = cmsData[indexPath.row].id
            viewController.cmsName = cmsData[indexPath.row].title
            let nav = UINavigationController(rootViewController: viewController)
            //nav.navigationBar.tintColor = AppStaticColors.accentColor
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
        if indexPath.section == 3 {
            let viewController = ContactUsDataViewController.instantiate(fromAppStoryboard: .customer)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
