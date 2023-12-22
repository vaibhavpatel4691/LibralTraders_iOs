//
/**
* Webkul Software.
* @package  Mobikul Single App
* @Category Webkul
* @author Webkul <support@webkul.com>
* FileName: ReportSectionTableViewCell.swift
* @Copyright (c) 2010-2019 Webkul Software Private Limited (https://webkul.com)
* @license https://store.webkul.com/license.html ASL Licence
* @link https://store.webkul.com/license.html

*/


import UIKit

class ReportSectionTableViewCell: UITableViewCell {
    @IBOutlet weak var reportLbl: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        theme()
        reportLbl.text = "Report Product".localized
        // Initialization code
    }
    func theme() {
        if #available(iOS 12.0, *) {

            if self.traitCollection.userInterfaceStyle == .dark {
             
                mainView.backgroundColor = AppStaticColors.darkButtonBackGroundColor
                reportLbl.backgroundColor = AppStaticColors.darkButtonBackGroundColor
                reportLbl.textColor = AppStaticColors.darkButtonTextColor

            } else {
                mainView.backgroundColor = AppStaticColors.buttonBackGroundColor
                reportLbl.backgroundColor = AppStaticColors.buttonBackGroundColor
                reportLbl.textColor = AppStaticColors.buttonTextColor
         }
        } else {
            mainView.backgroundColor = AppStaticColors.buttonBackGroundColor
            reportLbl.backgroundColor = AppStaticColors.buttonBackGroundColor
            reportLbl.textColor = AppStaticColors.buttonTextColor

        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
