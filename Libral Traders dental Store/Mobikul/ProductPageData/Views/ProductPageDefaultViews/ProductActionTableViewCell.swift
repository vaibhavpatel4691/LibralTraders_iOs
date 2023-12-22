//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: ProductActionTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class ProductActionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var compareBtn: UIButton!
    @IBOutlet weak var wishlishtBtn: UIButton!
    var callShare: (()->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        if NetworkManager.AddOnsEnabled.wishlistEnable {
            wishlishtBtn.isHidden = false
        } else {
            wishlishtBtn.isHidden = true
        }
        wishlishtBtn.setTitle("Wishlist".localized.uppercased(), for: .normal)
        compareBtn.setTitle("Compare".localized.uppercased(), for: .normal)
        shareBtn.setTitle("Share".localized.uppercased(), for: .normal)
        if Defaults.language == "ar" {
            shareBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            compareBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            wishlishtBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        }
        theme()
        // Initialization code
    }
    
    func theme() {
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                //               wishlishtBtn.setTitleColor(UIColor
                //                    .black, for: .normal)
                //                compareBtn.setTitleColor(UIColor
                //                .black, for: .normal)
                //                shareBtn.setTitleColor(UIColor
                //                .black, for: .normal)
                wishlishtBtn.backgroundColor = AppStaticColors.darkButtonTextColor
                
                compareBtn.backgroundColor = AppStaticColors.darkButtonTextColor
                
                shareBtn.backgroundColor = AppStaticColors.darkButtonTextColor
                
                wishlishtBtn.setTitleColor(AppStaticColors
                    .darkButtonBackGroundColor, for: .normal)
                compareBtn.setTitleColor(AppStaticColors
                    .darkButtonBackGroundColor, for: .normal)
                shareBtn.setTitleColor(AppStaticColors
                    .darkButtonBackGroundColor, for: .normal)
                let image = UIImage(named: "sharp-favorite_border-24px")?.withRenderingMode(.alwaysTemplate)
                wishlishtBtn.setImage(image, for: .normal)
                wishlishtBtn.tintColor = AppStaticColors.darkButtonBackGroundColor
                
                let compare = UIImage(named: "sharp-compare-stroke")?.withRenderingMode(.alwaysTemplate)
                compareBtn.setImage(compare, for: .normal)
                compareBtn.tintColor = AppStaticColors.darkButtonBackGroundColor
                let share = UIImage(named: "_Filled")?.withRenderingMode(.alwaysTemplate)
                shareBtn.setImage(share, for: .normal)
                shareBtn.tintColor = AppStaticColors.darkButtonBackGroundColor

                
            } else {
                 wishlishtBtn.setTitleColor(AppStaticColors
                                   .buttonBackGroundColor, for: .normal)
                               compareBtn.setTitleColor(AppStaticColors
                               .buttonBackGroundColor, for: .normal)
                               shareBtn.setTitleColor(AppStaticColors
                               .buttonBackGroundColor, for: .normal)
                wishlishtBtn.backgroundColor = AppStaticColors.buttonTextColor

                compareBtn.backgroundColor = AppStaticColors.buttonTextColor

                shareBtn.backgroundColor = AppStaticColors.buttonTextColor
                
                let image = UIImage(named: "sharp-favorite_border-24px")?.withRenderingMode(.alwaysTemplate)
                wishlishtBtn.setImage(image, for: .normal)
                wishlishtBtn.tintColor = AppStaticColors.buttonBackGroundColor
                
                let compare = UIImage(named: "sharp-compare-stroke")?.withRenderingMode(.alwaysTemplate)
                compareBtn.setImage(compare, for: .normal)
                compareBtn.tintColor = AppStaticColors.buttonBackGroundColor
                let share = UIImage(named: "_Filled")?.withRenderingMode(.alwaysTemplate)
                shareBtn.setImage(share, for: .normal)
                shareBtn.tintColor = AppStaticColors.buttonBackGroundColor

            }
        } else {
             wishlishtBtn.setTitleColor(AppStaticColors
                               .buttonBackGroundColor, for: .normal)
                           compareBtn.setTitleColor(AppStaticColors
                           .buttonBackGroundColor, for: .normal)
                           shareBtn.setTitleColor(AppStaticColors
                           .buttonBackGroundColor, for: .normal)
            wishlishtBtn.backgroundColor = AppStaticColors.buttonTextColor

            compareBtn.backgroundColor = AppStaticColors.buttonTextColor

            shareBtn.backgroundColor = AppStaticColors.buttonTextColor
            
            let image = UIImage(named: "sharp-favorite_border-24px")?.withRenderingMode(.alwaysTemplate)
            wishlishtBtn.setImage(image, for: .normal)
            wishlishtBtn.tintColor = AppStaticColors.buttonBackGroundColor
            
            let compare = UIImage(named: "sharp-compare-stroke")?.withRenderingMode(.alwaysTemplate)
            compareBtn.setImage(compare, for: .normal)
            compareBtn.tintColor = AppStaticColors.buttonBackGroundColor
            let share = UIImage(named: "_Filled")?.withRenderingMode(.alwaysTemplate)
            shareBtn.setImage(share, for: .normal)
            shareBtn.tintColor = AppStaticColors.buttonBackGroundColor

        }

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func wishlistClicked(_ sender: Any) {
    }
    
    
    @IBAction func shareButtonAction(_ sender: Any) {
        callShare?()
    }
    
    @IBAction func compareClicked(_ sender: Any) {
    }
}
