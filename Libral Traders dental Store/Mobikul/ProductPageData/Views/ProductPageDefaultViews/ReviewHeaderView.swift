//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: ReviewHeaderView.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class ReviewHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var totalRating: UILabel!
    @IBOutlet weak var addReviewBtn: UIButton!
    @IBOutlet weak var totalReviews: UILabel!
    @IBOutlet weak var basedOnLabel: UILabel!
    @IBOutlet weak var chart: PieChartView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowLabel: UIImageView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var ratingView: UIView!
    
    var section: Int = 0
    weak var delegate: HeaderViewDelegate?
    var id = ""
    var name = ""
    var image  = ""
    var ratingArray: RatingArray?
    var isSellerReview = false

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    @IBAction func addClicked(_ sender: Any) {
        #if MARKETPLACE || BTOB || HYPERLOCAL
        if Defaults.customerToken != nil {
        if isSellerReview {            
            let viewController = AddSellerReviewViewController.instantiate(fromAppStoryboard: .seller)
            viewController.sellerId = id
            viewController.shopUrl = name
            let nav = UINavigationController(rootViewController: viewController)
            nav.modalPresentationStyle = .fullScreen
            self.viewContainingController?.present(nav, animated: true, completion: nil)
        } else {
            let viewController = AddReviewDataViewController.instantiate(fromAppStoryboard: .customer)
            viewController.id = id
            viewController.name = name
            viewController.imageUrl = image
            let nav = UINavigationController(rootViewController: viewController)
            //nav.navigationBar.tintColor = AppStaticColors.accentColor
            nav.modalPresentationStyle = .fullScreen
            self.viewContainingController?.present(nav, animated: true, completion: nil)
        }
        } else {
            if isSellerReview {
                let customerLoginVC = LoginViewController.instantiate(fromAppStoryboard: .customer)
                let nav = UINavigationController(rootViewController: customerLoginVC)
               nav.modalPresentationStyle = .fullScreen
                customerLoginVC.signInHandler = {
                    if Defaults.customerToken == nil {
                        self.addReviewBtn.titleLabel?.numberOfLines = 2
                        self.addReviewBtn.setTitle("Please login to write review", for: .normal)
                    } else {
                        self.addReviewBtn.setTitle("Add your review", for: .normal)
                    }
                }
                self.viewContainingController?.present(nav, animated: true, completion: nil)
            } else {
                let viewController = AddReviewDataViewController.instantiate(fromAppStoryboard: .customer)
                viewController.id = id
                viewController.name = name
                viewController.imageUrl = image
                let nav = UINavigationController(rootViewController: viewController)
                //nav.navigationBar.tintColor = AppStaticColors.accentColor
                nav.modalPresentationStyle = .fullScreen
                self.viewContainingController?.present(nav, animated: true, completion: nil)
            }
           
        }
        #else
        let viewController = AddReviewDataViewController.instantiate(fromAppStoryboard: .customer)
        viewController.id = id
        viewController.name = name
        viewController.imageUrl = image
        let nav = UINavigationController(rootViewController: viewController)
        //nav.navigationBar.tintColor = AppStaticColors.accentColor
        nav.modalPresentationStyle = .fullScreen
        self.viewContainingController?.present(nav, animated: true, completion: nil)
        #endif
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if Defaults.language == "ar" {
            self.semanticContentAttribute = .forceRightToLeft
        } else {
            self.semanticContentAttribute = .forceLeftToRight
        }
        self.basedOnLabel.text = "Based On".localized
        self.addReviewBtn.setTitle("Add your review".localized.uppercased(), for: .normal)
        /*
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                addReviewBtn.setTitleColor(AppStaticColors.darkButtonTextColor, for: .normal)
                addReviewBtn.backgroundColor = AppStaticColors.darkButtonBackGroundColor
            } else {
                addReviewBtn.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
                addReviewBtn.backgroundColor = AppStaticColors.buttonBackGroundColor
            }
        } else {
            addReviewBtn.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
            addReviewBtn.backgroundColor = AppStaticColors.buttonBackGroundColor
        }
*/
        //        CategoryHeadeViewCell.backgroundColor = UIColor().HexToColor(hexString: .Credentials.defaultBackgroundColor)
        //        self.backgroundColor = UIColor(named: "BackColor")
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
    }
    
    override func layoutSubviews() {
        if let ratingArray = ratingArray {
            chart.segments = [
                Segment(color: AppStaticColors.oneStar, value: ratingArray.one),
                Segment(color: AppStaticColors.twoStar, value: ratingArray.two),
                Segment(color: AppStaticColors.threeStar, value: ratingArray.three),
                Segment(color: AppStaticColors.fourStar, value: ratingArray.four),
                Segment(color: AppStaticColors.fiveStar, value: ratingArray.five)
            ]
        }
    }
    
    @objc private func didTapHeader() {
        //        delegate?.toggleSection(header: self, section: section)
    }
    func setCollapsed(collapsed: Bool) {
//        arrowLabel?.image = UIImage(named: "icon-up")
//        arrowLabel?.rotate(collapsed ? 0.0 : .pi)
        arrowLabel?.rotateView(collapsed ? 0.0 : .pi)
    }
}
