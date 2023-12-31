//
/**
 Mobikul_Magento2V3_App
 @Category Webkul
 @author    Webkul
 Created by: rakesh on 01/09/18
 FileName: ProductTableViewCellLayout2.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license   https://store.webkul.com/license.html
 */

import UIKit
import Firebase

class ProductTableViewCellLayout4: UITableViewCell {
    
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var backGroundImage: UIImageView!
    //var carouselCollectionModel: Carousel?
    weak var delegate: MoveController?
    weak var obj: HomeViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if Defaults.language == "ar" {
            self.titleNameLabel?.textAlignment = .right
        } else {
            self.titleNameLabel?.textAlignment = .left
        }
        viewAllButton.setTitle("View All".localized.uppercased(), for: .normal)
        productCollectionView.register(ProductsCollectionViewCell.nib, forCellWithReuseIdentifier: ProductsCollectionViewCell.identifier)
        productCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        productCollectionView.register(ProductLandscapeCollectionViewCell.nib, forCellWithReuseIdentifier: ProductLandscapeCollectionViewCell.identifier)
      
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        productCollectionView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    var carouselCollectionModel: Carousel? {
        didSet {
            productCollectionView.reloadData()
        }
    }
    
    @IBAction func viewAllButtonAction(_ sender: Any) {
        delegate?.moveController(id: self.carouselCollectionModel?.id ?? "", name: self.carouselCollectionModel?.label ?? "", dict: [:], jsonData: JSON.null, type: "customCarousel", controller: AllControllers.productcategory)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension ProductTableViewCellLayout4: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let productList = carouselCollectionModel?.productList else { return 0 }
        let section1DataCount = productList.count / 2
        let section2DataCount = productList.count - section1DataCount
        if section == 0 {
            return section1DataCount
        } else {
            return section2DataCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsCollectionViewCell.identifier, for: indexPath) as? ProductsCollectionViewCell,
            let productList = carouselCollectionModel?.productList else { return UICollectionViewCell() }
      

        let section1DataCount = productList.count / 2
        if indexPath.section == 0 {
            if indexPath.row < section1DataCount {
                cell.productList = productList[indexPath.row]
            }
        } else {
            cell.productList = productList[indexPath.row+section1DataCount]
        }
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.size.width/2-0.5, height: collectionView.frame.size.width/2 + 108.5)
        } else {
            return CGSize(width: collectionView.frame.size.width/2-0.5, height: collectionView.frame.size.width/3 + 71.5)
        }
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
