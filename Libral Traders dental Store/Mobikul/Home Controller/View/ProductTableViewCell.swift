//
/**
 Mobikul_Magento2V3_App
 @Category Webkul
 @author    Webkul
 Created by: rakesh on 21/07/18
 FileName: ProductTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license   https://store.webkul.com/license.html
 */

import UIKit
import Firebase

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionViewheight: NSLayoutConstraint!
    @IBOutlet weak var backGroundImage: UIImageView!
    @IBOutlet weak var buttonHeight: NSLayoutConstraint!
   
    weak var obj: HomeViewModel?
    weak var delegate: MoveController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //
        if Defaults.language == "ar" {
            self.titleLabel?.textAlignment = .right
        } else {
            self.titleLabel?.textAlignment = .left
        }
        viewAllButton.setTitle("View All".localized.uppercased(), for: .normal)
        viewAllButton.layer.borderWidth = 3.0

       // viewAllButton.setTitleColor(UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 1 / 1.0), for: .normal)
        productCollectionView.register(ProductsCollectionViewCell.nib, forCellWithReuseIdentifier: ProductsCollectionViewCell.identifier)
        productCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        theme()
        collectionViewheight.constant = 10
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        productCollectionView.reloadData()
    }
    
    var carouselCollectionModel: Carousel? {
        didSet {
            productCollectionView.reloadData()
        }
    }
    func theme() {
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
              // titleLabel.textColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.86 / 1.0)
//                viewAllButton.setTitleColor(UIColor.white, for: .normal)
//                viewAllButton.backgroundColor = UIColor.black
                viewAllButton.layer.borderColor = AppStaticColors.darkButtonBackGroundColor.cgColor
                viewAllButton.setTitleColor(AppStaticColors.darkButtonBackGroundColor, for: .normal)
                viewAllButton.backgroundColor =  AppStaticColors.darkButtonTextColor

            } else {
               // titleLabel.textColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.86 / 1.0)
                viewAllButton.layer.borderColor = AppStaticColors.buttonBackGroundColor.cgColor
                viewAllButton.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
                viewAllButton.backgroundColor = AppStaticColors.buttonTextColor
            }
        } else {
           // titleLabel.textColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.86 / 1.0)
            viewAllButton.layer.borderColor = AppStaticColors.buttonBackGroundColor.cgColor
            viewAllButton.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
            viewAllButton.backgroundColor = AppStaticColors.buttonTextColor
        }
    }
    @IBAction func viewAllButtonAction(_ sender: Any) {
        delegate?.moveController(id: self.carouselCollectionModel?.id ?? "", name: self.carouselCollectionModel?.label ?? "", dict: [:], jsonData: JSON.null, type: "customCarousel", controller: AllControllers.productcategory)
    }
    
}

extension ProductTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let productList = carouselCollectionModel?.productList else { return 0 }
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsCollectionViewCell.identifier, for: indexPath) as? ProductsCollectionViewCell,
            let productList = carouselCollectionModel?.productList {
           
            cell.productList = productList[indexPath.row]
            if productList[indexPath.row].isInWishlist ?? false {
                cell.wishListButton.setImage(UIImage(named: "ic_wishlist_fill"), for: .normal)
            } else {
                cell.wishListButton.setImage(UIImage(named: "ic_wishlist"), for: .normal)
            }
            cell.wishListButton.addTapGestureRecognizer {
                if Defaults.customerToken == nil {
                    let customerLoginVC = LoginViewController.instantiate(fromAppStoryboard: .customer)
                    let nav = UINavigationController(rootViewController: customerLoginVC)
                    nav.modalPresentationStyle = .fullScreen
                    //nav.navigationBar.tintColor = AppStaticColors.accentColor
                    self.viewContainingController?.present(nav, animated: true, completion: nil)
                } else {
                    if productList[indexPath.row].isInWishlist ?? false {
                        self.wishlistAction(productId: productList[indexPath.row].wishlistItemId, added: true, apiType: "delete", productName: productList[indexPath.row].name, completion: { string in
                            productList[indexPath.row].addItemId(wishlistItemId: "")
                            productList[indexPath.row].wishlistStatus(isInWishlist: false)
                            cell.wishListButton.setImage(UIImage(named: "ic_wishlist"), for: .normal)
                        })
                    } else {
                        self.wishlistAction(productId: productList[indexPath.row].entityId, added: false, apiType: "", productName: productList[indexPath.row].name, completion: { string in
                            productList[indexPath.row].isInWishlist = true
                            productList[indexPath.row].wishlistStatus(isInWishlist: true)
                            productList[indexPath.row].addItemId(wishlistItemId: string)
                            cell.wishListButton.setImage(UIImage(named: "ic_wishlist_fill"), for: .normal)
                        })
                    }
                }
            }
            cell.layoutSubviews()
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2, height: collectionView.frame.size.width/2 + 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let productList = carouselCollectionModel?.productList {
            let viewController = ProductPageDataViewController.instantiate(fromAppStoryboard: .product)
            viewController.productId = productList[indexPath.row].entityId
            self.viewContainingController?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func wishlistAction(productId: String, added: Bool, apiType: String,productName:String, completion: @escaping ( (String) -> Void )) {
        obj?.callingHttppApi(productId: productId, apiType: apiType, productName: productName, completion: {  success, jsonResponse in
            if success {
                if apiType == ""{
                    
                    //MARK:- ADD_TO_WISHLIST Analytics

                    Analytics.setScreenName("ProductPage", screenClass: "ProductPageDataViewController.class")

                    Analytics.logEvent("ADD_TO_WISHLIST", parameters: ["productid":productId,"name":productName])
                }
                completion(jsonResponse["itemId"].stringValue)
            }
        })
    }
}
