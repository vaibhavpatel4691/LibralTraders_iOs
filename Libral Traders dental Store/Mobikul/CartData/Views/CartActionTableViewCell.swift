//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: CartActionTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class CartActionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var continueShoppingBtn: UIButton!
    @IBOutlet weak var emptyCartBtn: UIButton!
    @IBOutlet weak var updateCartBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        continueShoppingBtn.layer.borderWidth = 3.0
        updateCartBtn.setTitle("Update Cart".localized, for: .normal)
        emptyCartBtn.setTitle("Empty Cart".localized, for: .normal)
        continueShoppingBtn.setTitle("Continue Shopping".localized, for: .normal)
        if Defaults.language == "ar" {
            updateCartBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
            emptyCartBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        }
        //continueShoppingBtn.applyBorder(colours: AppStaticColors.accentColor)

        // Initialization code
    }
    func theme() {
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
//                continueShoppingBtn.backgroundColor = UIColor.white
//                continueShoppingBtn.setTitleColor(UIColor.black, for: .normal)
                continueShoppingBtn.layer.borderColor = AppStaticColors.darkButtonBackGroundColor.cgColor

                continueShoppingBtn.backgroundColor = AppStaticColors.defaultColor
                continueShoppingBtn.setTitleColor(AppStaticColors.darkButtonBackGroundColor, for: .normal)
                updateCartBtn.backgroundColor = AppStaticColors.darkButtonTextColor
                updateCartBtn.setTitleColor(AppStaticColors.darkButtonBackGroundColor, for: .normal)
                emptyCartBtn.backgroundColor = AppStaticColors.darkButtonTextColor
                emptyCartBtn.setTitleColor(AppStaticColors.darkButtonBackGroundColor, for: .normal)
                let image = UIImage(named: "update")?.withRenderingMode(.alwaysTemplate)
                updateCartBtn.setImage(image, for: .normal)
                updateCartBtn.tintColor = AppStaticColors.darkButtonBackGroundColor
                let remove = UIImage(named: "cart-remove")?.withRenderingMode(.alwaysTemplate)
                emptyCartBtn.setImage(remove, for: .normal)
                emptyCartBtn.tintColor = AppStaticColors.darkButtonBackGroundColor

            } else {
                continueShoppingBtn.layer.borderColor = AppStaticColors.buttonBackGroundColor.cgColor
                continueShoppingBtn.backgroundColor = AppStaticColors.defaultColor
                continueShoppingBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
                updateCartBtn.backgroundColor = AppStaticColors.buttonTextColor
                updateCartBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
                emptyCartBtn.backgroundColor = AppStaticColors.buttonTextColor
                emptyCartBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
                let image = UIImage(named: "update")?.withRenderingMode(.alwaysTemplate)
                updateCartBtn.setImage(image, for: .normal)
                updateCartBtn.tintColor = AppStaticColors.buttonBackGroundColor
                let remove = UIImage(named: "cart-remove")?.withRenderingMode(.alwaysTemplate)
                emptyCartBtn.setImage(remove, for: .normal)
                emptyCartBtn.tintColor = AppStaticColors.buttonBackGroundColor

            }
        } else {
            continueShoppingBtn.layer.borderColor = AppStaticColors.buttonBackGroundColor.cgColor
            continueShoppingBtn.backgroundColor = AppStaticColors.defaultColor
            continueShoppingBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
            updateCartBtn.backgroundColor = AppStaticColors.buttonTextColor
            updateCartBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
            emptyCartBtn.backgroundColor = AppStaticColors.buttonTextColor
            emptyCartBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
            let image = UIImage(named: "update")?.withRenderingMode(.alwaysTemplate)
            updateCartBtn.setImage(image, for: .normal)
            updateCartBtn.tintColor = AppStaticColors.buttonBackGroundColor
            let remove = UIImage(named: "cart-remove")?.withRenderingMode(.alwaysTemplate)
            emptyCartBtn.setImage(remove, for: .normal)
            emptyCartBtn.tintColor = AppStaticColors.buttonBackGroundColor

        }

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
