//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: ProductCartViewTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class ProductCartViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var buyNowBtn: UIButton!
    weak var delegate: AddToCartProduct?
    var cartClick:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topView.shadowBorder()
        theme()
        addToCartBtn.setTitle("Add To Cart".localized.uppercased(), for: .normal)
        buyNowBtn.setTitle("Buy Now".localized.uppercased(), for: .normal)
    }
    func theme() {
        if #available(iOS 12.0, *) {
                   if self.traitCollection.userInterfaceStyle == .dark {
                      buyNowBtn.backgroundColor = AppStaticColors.darkButtonBackGroundColor
                      addToCartBtn.backgroundColor = AppStaticColors.darkButtonTextColor
                      buyNowBtn.setTitleColor(AppStaticColors.darkButtonTextColor, for: .normal)
                      addToCartBtn.setTitleColor(AppStaticColors.darkButtonBackGroundColor, for: .normal)
                   } else {
                       buyNowBtn.backgroundColor = AppStaticColors.buttonBackGroundColor
                       addToCartBtn.backgroundColor = AppStaticColors.buttonTextColor
                       buyNowBtn.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
                       addToCartBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
                   }
               } else {
                   buyNowBtn.backgroundColor = AppStaticColors.buttonBackGroundColor
                   addToCartBtn.backgroundColor = AppStaticColors.buttonTextColor
                   buyNowBtn.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
                   addToCartBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
               }

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func addTocartClicked(_ sender: Any) {
        delegate?.addToCartProduct(cart: false)
        cartClick?()
    }
    
    @IBAction func buyNowClicked(_ sender: Any) {
        delegate?.addToCartProduct(cart: true)
    }
}
