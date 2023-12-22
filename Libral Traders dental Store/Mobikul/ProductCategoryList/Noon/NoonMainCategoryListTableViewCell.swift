//
/**
* Webkul Software.
* @package  Mobikul Single App
* @Category Webkul
* @author Webkul <support@webkul.com>
* FileName: NoonMainCategoryListTableViewCell.swift
* @Copyright (c) 2010-2019 Webkul Software Private Limited (https://webkul.com)
* @license https://store.webkul.com/license.html ASL Licence
* @link https://store.webkul.com/license.html

*/


import UIKit

class NoonMainCategoryListTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryNameBackView: UIView!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var sideViewWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
