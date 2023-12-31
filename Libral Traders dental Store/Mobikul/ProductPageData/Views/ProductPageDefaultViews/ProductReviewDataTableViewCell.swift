//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: ProductReviewDataTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class ProductReviewDataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var reviewBy: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var item: ReviewList! {
        didSet {
            ratingLabel.text = item.avgRatings
            datelabel.text = item.reviewOn
            descriptionLabel.text = item.details?.decode()
            heading.text = item.title?.decode()
            reviewBy.text = item.reviewBy
            
            if item.floatRatingValue < 2 {
                ratingView.backgroundColor = AppStaticColors.oneStar
            } else if item.floatRatingValue < 3 {
                ratingView.backgroundColor = AppStaticColors.twoStar
            } else if item.floatRatingValue < 4 {
                ratingView.backgroundColor = AppStaticColors.threeStar
            } else if item.floatRatingValue < 5 {
                ratingView.backgroundColor = AppStaticColors.fourStar
            } else if item.floatRatingValue == 5 {
                ratingView.backgroundColor = AppStaticColors.fiveStar
            }
        }
    }
    
    #if MARKETPLACE || BTOB || HYPERLOCAL
    var sellerItem: SellerReviewList? {
        didSet {
            guard let item = sellerItem else {
                ratingLabel.text = ""
                datelabel.text = ""
                descriptionLabel.text = ""
                heading.text = ""
                reviewBy.text = ""
                return
            }
            ratingLabel.text = item.avgRating
            datelabel.text = item.date
            descriptionLabel.text = item.descriptionValue?.decode()
            heading.text = item.summary?.decode()
            reviewBy.text = item.userName
            
            ratingView.backgroundColor = AppStaticColors.fiveStar
//            if item.floatRatingValue < 2 {
//                ratingView.backgroundColor = AppStaticColors.oneStar
//            } else if item.floatRatingValue < 3 {
//                ratingView.backgroundColor = AppStaticColors.twoStar
//            } else if item.floatRatingValue < 4 {
//                ratingView.backgroundColor = AppStaticColors.threeStar
//            } else if item.floatRatingValue < 5 {
//                ratingView.backgroundColor = AppStaticColors.fourStar
//            } else if item.floatRatingValue == 5 {
//                ratingView.backgroundColor = AppStaticColors.fiveStar
//            }
        }
    }
    
    var dashboardItem: SellerDashBoardReviewList? {
        didSet {
            guard let item = dashboardItem else {
                ratingLabel.text = ""
                datelabel.text = ""
                descriptionLabel.text = ""
                heading.text = ""
                reviewBy.text = ""
                return
            }
            ratingLabel.text = item.avgRating
            datelabel.text = item.date
            descriptionLabel.text = item.comment?.decode()
            heading.text = item.name
            reviewBy.text = item.name
            
            ratingView.backgroundColor = AppStaticColors.fiveStar
        }
    }
    #endif
    
    override func layoutSubviews() {
        if let item = item {
            if item.floatRatingValue < 2 {
                ratingView.backgroundColor = AppStaticColors.oneStar
            } else if item.floatRatingValue < 3 {
                ratingView.backgroundColor = AppStaticColors.twoStar
            } else if item.floatRatingValue < 4 {
                ratingView.backgroundColor = AppStaticColors.threeStar
            } else if item.floatRatingValue < 5 {
                ratingView.backgroundColor = AppStaticColors.fourStar
            } else if item.floatRatingValue == 5 {
                ratingView.backgroundColor = AppStaticColors.fiveStar
            }
        }
    }
}
