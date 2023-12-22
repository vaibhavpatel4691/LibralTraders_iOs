//
//  CategoryTheme1CollectionViewCell.swift
//  Mobikul Single App
//
//  Created by akash on 06/01/20.
//  Copyright © 2020 Webkul. All rights reserved.
//

import UIKit

class CategoryTheme1CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var heightOFImg: NSLayoutConstraint!
    @IBOutlet weak var widthOFImg: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()        
        self.labelName.font = UIFont(name: "Montserrat-SemiBold", size: 12)
        viewUpdate()
        //self.labelName.textColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.56 / 1.0)
    }
    
    override func layoutSubviews() {
        viewUpdate()
    }
    func viewUpdate() {
        heightOFImg.constant = 64
        widthOFImg.constant = 64
        self.imageView.layer.cornerRadius = 32
        self.imageView.layer.masksToBounds = true

    }
}
