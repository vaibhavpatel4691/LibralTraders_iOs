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

class ProductTableViewCellLayout2: UITableViewCell {
    
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionVwHeight: NSLayoutConstraint!
    @IBOutlet weak var backGroundImage: UIImageView!
    weak var obj: HomeViewModel?
//    var carouselCollectionModel: Carousel?
    weak var delegate: MoveController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if Defaults.language == "ar" {
            self.titleNameLabel?.textAlignment = .right
        } else {
            self.titleNameLabel?.textAlignment = .left
        }
        productCollectionVwHeight.constant = 20
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var carouselCollectionModel: Carousel? {
        didSet {
            productCollectionView.reloadData()
        }
    }
    
    @IBAction func viewAllButtonAction(_ sender: Any) {
        delegate?.moveController(id: self.carouselCollectionModel?.id ?? "", name: self.carouselCollectionModel?.label ?? "", dict: [:], jsonData: JSON.null, type: "customCarousel", controller: AllControllers.productcategory)
    }
}

extension ProductTableViewCellLayout2: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let productList = carouselCollectionModel?.productList else { return 0 }
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 2 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductLandscapeCollectionViewCell.identifier, for: indexPath) as? ProductLandscapeCollectionViewCell,
                let productList = carouselCollectionModel?.productList else { return UICollectionViewCell() }
             
     
            if NetworkManager.AddOnsEnabled.wishlistEnable {
                cell.wishListButton.isHidden = false
                   } else {
                cell.wishListButton.isHidden = true
                   }
            cell.productImageView.setImage(fromURL: productList[indexPath.row].thumbNail, dominantColor: productList[indexPath.row].dominantColor)
            cell.productName.text = productList[indexPath.row].name
            cell.priceLabel.text = productList[indexPath.row].formattedPrice
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
                            productList[indexPath.row].isInWishlist = false
                            productList[indexPath.row].wishlistStatus(isInWishlist: false)
                            productList[indexPath.row].addItemId(wishlistItemId: "")
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
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsCollectionViewCell.identifier, for: indexPath) as? ProductsCollectionViewCell,
                let productList = carouselCollectionModel?.productList else { return UICollectionViewCell() }
             
            cell.productList = productList[indexPath.row]
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 2 {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.width/2 + 50)
        }
        return CGSize(width: collectionView.frame.size.width/2-0.5, height: collectionView.frame.size.width/2 + 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let productList = carouselCollectionModel?.productList {
            let viewController = ProductPageDataViewController.instantiate(fromAppStoryboard: .product)
            viewController.productId = productList[indexPath.row].entityId
            self.viewContainingController?.navigationController?.pushViewController(viewController, animated: true)
        }        
    }
}
