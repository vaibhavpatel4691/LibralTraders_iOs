//
/**
 Mobikul_Magento2V3_App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: BottomMoveToTopTableView.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class BottomMoveToTopTableView: UIView {
    @IBOutlet weak var bottomLabelMessage: UILabel!
    var tableView: UITableView!
    @IBOutlet weak var backToTopButton: UIButton!
    
    override func layoutSubviews() {
        //        bottomLabelMessage.font = UIFont(name: REGULARFONT, size: 12)
        bottomLabelMessage.textColor = UIColor(red: 117 / 255.0, green: 117 / 255.0, blue: 117 / 255.0, alpha: 1 / 1.0)
        bottomLabelMessage.text = "You have just reached to the bottom of page.".localized
        backToTopButton.setTitle("Back to Top".localized.uppercased(), for: .normal)
        backToTopButton.backgroundColor = AppStaticColors.buttonBackGroundColor
        backToTopButton.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                backToTopButton.setTitleColor(AppStaticColors.darkButtonBackGroundColor, for: .normal)
                backToTopButton.backgroundColor = AppStaticColors.darkButtonTextColor
                
            } else {
                backToTopButton.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
                backToTopButton.backgroundColor = AppStaticColors.buttonTextColor
            }
        } else {
            backToTopButton.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
            backToTopButton.backgroundColor = AppStaticColors.buttonTextColor
        }
    }
    
    @IBAction func backToTopButtonAction(_ sender: Any) {
        scrollToFirstRow() 
    }
    
    func scrollToFirstRow() {
        let indexPath = NSIndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
    }
}
