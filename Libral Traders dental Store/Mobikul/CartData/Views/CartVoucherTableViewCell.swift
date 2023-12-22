//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: CartVoucherTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit
import MaterialComponents.MaterialTextFields_ColorThemer
import MaterialComponents.MaterialTypographyScheme

class CartVoucherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var applyDiscountCodeLbl: UILabel!
    @IBOutlet weak var arrowBtn: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var textField: MDCTextField!
    weak var delegate: HeaderViewDelegate?
    var discountController: MDCTextInputControllerOutlined!
    override func awakeFromNib() {
        super.awakeFromNib()
     
        applyDiscountCodeLbl.text = "Apply Discount Code".localized
        discountController = MDCTextInputControllerOutlined(textInput: textField)
        discountController.activeColor = AppStaticColors.accentColor
        discountController.floatingPlaceholderActiveColor = AppStaticColors.accentColor
        discountController.roundedCorners = UIRectCorner(rawValue: 0)
        discountController.placeholderText = "Enter Discount Code".localized
         

        topView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
        theme()
    }
    
    @objc private func didTapHeader() {
        delegate?.toggleSection(view: self, section: 1)
    }
    
    @IBAction func applyclicked(_ sender: Any) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func theme() {
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
//                applyBtn.backgroundColor = UIColor.white
//                applyBtn.setTitleColor(UIColor.black, for: .normal)
                applyBtn.backgroundColor = AppStaticColors.darkButtonBackGroundColor
                applyBtn.setTitleColor(AppStaticColors.darkButtonTextColor, for: .normal)
                textField.textColor = UIColor.white
                discountController.floatingPlaceholderNormalColor = AppStaticColors.accentColor
                discountController.inlinePlaceholderColor = AppStaticColors.accentColor

            } else {
                applyBtn.backgroundColor = AppStaticColors.buttonBackGroundColor
                applyBtn.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
                textField.textColor = AppStaticColors.accentColor
            }
        } else {
            applyBtn.backgroundColor = AppStaticColors.buttonBackGroundColor
            applyBtn.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
            textField.textColor = AppStaticColors.accentColor
        }

    }
}

protocol HeaderViewDelegate: class {
    func toggleSection(view: UITableViewCell, section: Int)
}
