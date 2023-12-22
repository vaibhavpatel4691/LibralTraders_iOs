//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: CategoryListTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class CategoryListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var categoryNameLbl: UILabel!
    @IBOutlet weak var categoryImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        theme()
        arrow.image = arrow.image?.flipImage()
        // Initialization code
    }
    func theme() {
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                let image = UIImage(named: "rightArrow")?.withRenderingMode(.alwaysTemplate)
                
                arrow.tintColor = .white
                arrow.image = image?.flipImage()
                } else {
                    let image = UIImage(named: "rightArrow")?.withRenderingMode(.alwaysTemplate)
                    
                    arrow.tintColor = .black
                    arrow.image = image?.flipImage()
                }
        } else {
            let image = UIImage(named: "rightArrow")?.withRenderingMode(.alwaysTemplate)
            
            arrow.tintColor = .black
            arrow.image = image?.flipImage()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //    static var nib: UINib {
    //        return UINib(nibName: identifier, bundle: nil)
    //    }
    //
    //    static var identifier: String {
    //        return String(describing: self)
    //    }
    
}
