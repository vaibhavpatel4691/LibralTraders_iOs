//
//  ListProductCollectionViewCell.swift
//  Mobikul Single App
//
//  Created by akash on 27/01/19.
//  Copyright © 2019 kunal. All rights reserved.
//

import UIKit
import Firebase

class ListProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var newTagBtn: UIButton!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var oldPriceLbl: UILabel!
    @IBOutlet weak var addToWishlistBtn: UIButton!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var noReviewsLbl: UILabel!
    @IBOutlet weak var availabilityLbl: UILabel!
    @IBOutlet weak var ratingView: UIView!
    weak var delegate: ProductItemActions?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if NetworkManager.AddOnsEnabled.wishlistEnable {
            addToWishlistBtn.isHidden = false
        } else {
            addToWishlistBtn.isHidden = true
        }
        noReviewsLbl.text = "No Reviews yet".localized
        newTagBtn.setTitle("New".localized, for: .normal)
        self.mainView.borderColor1 = UIColor.lightGray//AppStaticColors.shadedColor
        self.mainView.borderWidth1 = 0.5
    }
    
    var item: ProductList? {
        didSet {
            guard let product = item else {
                self.productImg.setImage(fromURL: "")
                self.productNameLbl.text = ""
                self.priceLbl.text = ""
                self.oldPriceLbl.text = ""
                self.ratingLbl.text = ""
                self.noReviewsLbl.isHidden = false
                self.newTagBtn.isHidden = true
                self.addToWishlistBtn.setImage(UIImage(named: ""), for: .normal)
                return
            }
            if product.isNew ?? false {
                newTagBtn.isHidden = false
            } else {
                newTagBtn.isHidden = true
            }
            percentageLabel.text = product.percentage
            if product.isInWishlist ?? false {
                self.addToWishlistBtn.setImage(UIImage(named: "ic_wishlist_fill"), for: .normal)
            } else {
                self.addToWishlistBtn.setImage(UIImage(named: "ic_wishlist"), for: .normal)
            }
            self.productImg.setImage(fromURL: product.thumbNail, dominantColor: product.dominantColor)
            self.productNameLbl.text = product.name
            self.priceLbl.text = product.formattedFinalPrice
            self.oldPriceLbl.attributedText = product.strikePrice
//            if let rating = product.rating, rating > 0 {
//                self.noReviewsLbl.isHidden = true
//                self.ratingLbl.text = "\(rating)"
//            } else {
//                self.noReviewsLbl.isHidden = false
//            }
            
            if let rating = product.rating, rating > 0 {
                if (product.reviewCount ?? 0) > 0 {
                    self.noReviewsLbl.isHidden = false
                    if (product.reviewCount ?? 0) > 1 {
                        self.noReviewsLbl.text = "\((product.reviewCount ?? 0))" + " " + "Reviews"
                    } else {
                        self.noReviewsLbl.text = "\((product.reviewCount ?? 0))" + " " + "Review"
                    }
                    self.noReviewsLbl.textAlignment = .right
                    self.ratingLbl.text = "\(rating)"
                    self.ratingView.isHidden = false
                } else {
                    noReviewsLbl.text = "No Reviews yet".localized
                    self.noReviewsLbl.textAlignment = .right
                    self.ratingLbl.text = "\(rating)"
                    self.ratingView.isHidden = false
                }
               
            } else {
                if (product.reviewCount ?? 0) > 0 {
                    self.ratingView.isHidden = true
                    self.noReviewsLbl.isHidden = false
                    if (product.reviewCount ?? 0) > 1 {
                        self.noReviewsLbl.text = "\((product.reviewCount ?? 0))" + " " + "Reviews"
                    } else {
                        self.noReviewsLbl.text = "\((product.reviewCount ?? 0))" + " " + "Review"
                    }
                    self.noReviewsLbl.textAlignment = .left
                } else {
                    noReviewsLbl.text = "No Reviews yet".localized
                    self.ratingView.isHidden = true
                    self.noReviewsLbl.textAlignment = .left
                    self.noReviewsLbl.isHidden = false
                }
               
            }
            if product.isAvailable ?? true {
                availabilityLbl.text = ""
                availabilityLbl.isHidden = true
            } else {
                availabilityLbl.text = product.availability
                availabilityLbl.isHidden = false
            }
            self.priceLbl.halfTextWithColorChange(fullText: self.priceLbl.text!, changeText: "Starting at".localized + ": ", color: AppStaticColors.labelSecondaryColor)
        }
    }
    
    @IBAction func tapAddtowishListBtn(_ sender: UIButton) {
        self.delegate?.addToWishList(index: self.tag)
        if !(item?.isInWishlist ?? false){
            
            //MARK:- ADD_TO_WISHLIST Analytics

            Analytics.setScreenName("CategoryProducts", screenClass: "CategoryProductsViewController.class")
            Analytics.logEvent("ADD_TO_WISHLIST", parameters: ["productid":item?.entityId ?? "","name":item?.name ?? ""])
        }
    }
    
}
