//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: OrderListTableViewCell.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import UIKit

class OrderListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var statusWidth: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var orderProductImage: UIImageView!
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var statusData: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var detailBtn: UIButton!
    @IBOutlet weak var reOrderBtn: UIButton!
    @IBOutlet weak var reviewBtn: UIButton!
    
    @IBOutlet weak var trackView: UIView!
    
    weak  var delegate: moveToControlller?
    @IBOutlet weak var trackImageView1: UIImageView!
    @IBOutlet weak var trackView1: CustomProgressBarView!
    
    @IBOutlet weak var trackImageView2: UIImageView!
    @IBOutlet weak var trackView2: CustomProgressBarView!
    
    @IBOutlet weak var trackImageView3: UIImageView!
    @IBOutlet weak var trackView3: CustomProgressBarView!
    
    @IBOutlet weak var trackImageView4: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        statusData.textAlignment = .center
        detailBtn.setTitle("DETAILS".localized, for: .normal)
        reOrderBtn.setTitle("REORDER".localized, for: .normal)
        reviewBtn.setTitle("REVIEW".localized, for: .normal)
        if Defaults.language == "ar" {
            detailBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            reOrderBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
            reviewBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        } else {
            
        }
        if #available(iOS 12.0, *) {
                 if self.traitCollection.userInterfaceStyle == .dark {
                    if #available(iOS 12.0, *) {
                        detailBtn.backgroundColor = AppStaticColors.darkButtonTextColor
                        reOrderBtn.backgroundColor = AppStaticColors.darkButtonTextColor
                        reviewBtn.backgroundColor = AppStaticColors.darkButtonTextColor
                        

                      detailBtn.setTitleColor(AppStaticColors.darkButtonBackGroundColor, for: .normal)
                      reOrderBtn.setTitleColor(AppStaticColors.darkButtonBackGroundColor, for: .normal)
                      reviewBtn.setTitleColor(AppStaticColors.darkButtonBackGroundColor, for: .normal)
                        let image = UIImage(named: "sharp-post-review")?.withRenderingMode(.alwaysTemplate)
                        reviewBtn.setImage(image, for: .normal)
                        reviewBtn.tintColor = AppStaticColors.darkButtonBackGroundColor
                        
                        let details = UIImage(named: "sharp-arrow-line")?.withRenderingMode(.alwaysTemplate)
                        detailBtn.setImage(details, for: .normal)
                        detailBtn.tintColor = AppStaticColors.darkButtonBackGroundColor
                        let reorder = UIImage(named: "sharp-repeat")?.withRenderingMode(.alwaysTemplate)
                        reOrderBtn.setImage(reorder, for: .normal)
                        reOrderBtn.tintColor = AppStaticColors.darkButtonBackGroundColor

                    } else {
                            detailBtn.backgroundColor = AppStaticColors.buttonTextColor
                            reOrderBtn.backgroundColor = AppStaticColors.buttonTextColor
                            reviewBtn.backgroundColor = AppStaticColors.buttonTextColor
                            
                            detailBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
                            reOrderBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
                            reviewBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
                            let image = UIImage(named: "sharp-post-review")?.withRenderingMode(.alwaysTemplate)
                            reviewBtn.setImage(image, for: .normal)
                            reviewBtn.tintColor = AppStaticColors.buttonBackGroundColor
                            
                            let details = UIImage(named: "sharp-arrow-line")?.withRenderingMode(.alwaysTemplate)
                            detailBtn.setImage(details, for: .normal)
                            detailBtn.tintColor = AppStaticColors.buttonBackGroundColor
                            let reorder = UIImage(named: "sharp-repeat")?.withRenderingMode(.alwaysTemplate)
                            reOrderBtn.setImage(reorder, for: .normal)
                            reOrderBtn.tintColor = AppStaticColors.buttonBackGroundColor

                            
                    }
                 } else {
                         detailBtn.backgroundColor = AppStaticColors.buttonTextColor
                         reOrderBtn.backgroundColor = AppStaticColors.buttonTextColor
                         reviewBtn.backgroundColor = AppStaticColors.buttonTextColor
                         
                         detailBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
                         reOrderBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
                         reviewBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
                         let image = UIImage(named: "sharp-post-review")?.withRenderingMode(.alwaysTemplate)
                         reviewBtn.setImage(image, for: .normal)
                         reviewBtn.tintColor = AppStaticColors.buttonBackGroundColor
                         
                         let details = UIImage(named: "sharp-arrow-line")?.withRenderingMode(.alwaysTemplate)
                         detailBtn.setImage(details, for: .normal)
                         detailBtn.tintColor = AppStaticColors.buttonBackGroundColor
                         let reorder = UIImage(named: "sharp-repeat")?.withRenderingMode(.alwaysTemplate)
                         reOrderBtn.setImage(reorder, for: .normal)
                         reOrderBtn.tintColor = AppStaticColors.buttonBackGroundColor

                         
                 }
        } else {
                detailBtn.backgroundColor = AppStaticColors.buttonTextColor
                reOrderBtn.backgroundColor = AppStaticColors.buttonTextColor
                reviewBtn.backgroundColor = AppStaticColors.buttonTextColor
                
                detailBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
                reOrderBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
                reviewBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
                let image = UIImage(named: "sharp-post-review")?.withRenderingMode(.alwaysTemplate)
                reviewBtn.setImage(image, for: .normal)
                reviewBtn.tintColor = AppStaticColors.buttonBackGroundColor
                
                let details = UIImage(named: "sharp-arrow-line")?.withRenderingMode(.alwaysTemplate)
                detailBtn.setImage(details, for: .normal)
                detailBtn.tintColor = AppStaticColors.buttonBackGroundColor
                let reorder = UIImage(named: "sharp-repeat")?.withRenderingMode(.alwaysTemplate)
                reOrderBtn.setImage(reorder, for: .normal)
                reOrderBtn.tintColor = AppStaticColors.buttonBackGroundColor

                
        }
            
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func detailTapAct(_ sender: UIButton) {
        delegate?.moveController(id: "", name: "", dict: [:], jsonData: JSON.null, index: sender.tag, controller: .orderDetailsDataViewController)
    }
    
    @IBAction func reOrderAct(_ sender: UIButton) {
        delegate?.moveController(id: "", name: sender.titleLabel?.text ?? "", dict: [:], jsonData: JSON.null, index: sender.tag, controller: .reOrder)
    }
    
    @IBAction func reviewAct(_ sender: UIButton) {
        delegate?.moveController(id: "", name: "", dict: [:], jsonData: JSON.null, index: sender.tag, controller: .orderReview)
    }
    
    func setTrackProgress(progress: Float = 0.0) {
            self.trackImageView1.backgroundColor = .green
            self.trackImageView2.backgroundColor = AppStaticColors.startEmptyColor
            self.trackImageView3.backgroundColor = AppStaticColors.startEmptyColor
            self.trackImageView4.backgroundColor = AppStaticColors.startEmptyColor
            //self.trackView1.progress = 0.10
            self.trackView1.progress = progress
        
    }
    
    var item: OrderListDataStruct! {
        didSet {
            self.trackView.isHidden = true
//            DispatchQueue.main.async {
//                self.trackImageView1.layer.cornerRadius = self.trackImageView1.frame.size.height/2
//                self.trackImageView2.layer.cornerRadius = self.trackImageView2.frame.size.height/2
//                self.trackImageView3.layer.cornerRadius = self.trackImageView3.frame.size.height/2
//                self.trackImageView4.layer.cornerRadius = self.trackImageView4.frame.size.height/2
//            }
           
            self.orderProductImage.setImage(fromURL: item.itemImageUrl)
            if item.canReorder ?? false {
                reOrderBtn.isHidden = false
            } else {
                reOrderBtn.isHidden = true
            }
            statusData.textColor = UIColor.white
            //
            orderId.text = "#" + (item.orderId ?? "")
            statusData.text = item.orderStatus
            self.reOrderBtn.setTitle(item.orderStatus == "processing" ? "CANCEL" : "REORDER", for: .normal)
            statusWidth.constant = (statusData.text?.widthOfString(usingFont: UIFont.boldSystemFont(ofSize: 14)))! + 20
            statusData.backgroundColor = UIColor().hexToColor(hexString: item.statusColorCode)
            
            orderDate.text = item.orderDate ?? ""
            orderPrice.text = item.orderPrice ?? ""
            if #available(iOS 12.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark {
                    if #available(iOS 12.0, *) {
                        detailBtn.backgroundColor = AppStaticColors.darkButtonTextColor
                        reOrderBtn.backgroundColor = AppStaticColors.darkButtonTextColor
                        reviewBtn.backgroundColor = AppStaticColors.darkButtonTextColor
                        
                        
                        detailBtn.setTitleColor(AppStaticColors.darkButtonBackGroundColor, for: .normal)
                        reOrderBtn.setTitleColor(AppStaticColors.darkButtonBackGroundColor, for: .normal)
                        reviewBtn.setTitleColor(AppStaticColors.darkButtonBackGroundColor, for: .normal)
                        let image = UIImage(named: "sharp-post-review")?.withRenderingMode(.alwaysTemplate)
                        reviewBtn.setImage(image, for: .normal)
                        reviewBtn.tintColor = AppStaticColors.darkButtonBackGroundColor
                        
                        let details = UIImage(named: "sharp-arrow-line")?.withRenderingMode(.alwaysTemplate)
                        detailBtn.setImage(details, for: .normal)
                        detailBtn.tintColor = AppStaticColors.darkButtonBackGroundColor
                        let reorder = UIImage(named: "sharp-repeat")?.withRenderingMode(.alwaysTemplate)
                        reOrderBtn.setImage(reorder, for: .normal)
                        reOrderBtn.tintColor = AppStaticColors.darkButtonBackGroundColor
                        
                    } else {
                        detailBtn.backgroundColor = AppStaticColors.buttonTextColor
                        reOrderBtn.backgroundColor = AppStaticColors.buttonTextColor
                        reviewBtn.backgroundColor = AppStaticColors.buttonTextColor
                        
                        detailBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
                        reOrderBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
                        reviewBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
                        let image = UIImage(named: "sharp-post-review")?.withRenderingMode(.alwaysTemplate)
                        reviewBtn.setImage(image, for: .normal)
                        reviewBtn.tintColor = AppStaticColors.buttonBackGroundColor
                        
                        let details = UIImage(named: "sharp-arrow-line")?.withRenderingMode(.alwaysTemplate)
                        detailBtn.setImage(details, for: .normal)
                        detailBtn.tintColor = AppStaticColors.buttonBackGroundColor
                        let reorder = UIImage(named: "sharp-repeat")?.withRenderingMode(.alwaysTemplate)
                        reOrderBtn.setImage(reorder, for: .normal)
                        reOrderBtn.tintColor = AppStaticColors.buttonBackGroundColor
                        
                        
                    }
                } else {
                    detailBtn.backgroundColor = AppStaticColors.buttonTextColor
                    reOrderBtn.backgroundColor = AppStaticColors.buttonTextColor
                    reviewBtn.backgroundColor = AppStaticColors.buttonTextColor
                    
                    detailBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
                    reOrderBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
                    reviewBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
                    let image = UIImage(named: "sharp-post-review")?.withRenderingMode(.alwaysTemplate)
                    reviewBtn.setImage(image, for: .normal)
                    reviewBtn.tintColor = AppStaticColors.buttonBackGroundColor
                    
                    let details = UIImage(named: "sharp-arrow-line")?.withRenderingMode(.alwaysTemplate)
                    detailBtn.setImage(details, for: .normal)
                    detailBtn.tintColor = AppStaticColors.buttonBackGroundColor
                    let reorder = UIImage(named: "sharp-repeat")?.withRenderingMode(.alwaysTemplate)
                    reOrderBtn.setImage(reorder, for: .normal)
                    reOrderBtn.tintColor = AppStaticColors.buttonBackGroundColor
                    
                    
                }
            } else {
                detailBtn.backgroundColor = AppStaticColors.buttonTextColor
                reOrderBtn.backgroundColor = AppStaticColors.buttonTextColor
                reviewBtn.backgroundColor = AppStaticColors.buttonTextColor
                
                detailBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
                reOrderBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
                reviewBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
                let image = UIImage(named: "sharp-post-review")?.withRenderingMode(.alwaysTemplate)
                reviewBtn.setImage(image, for: .normal)
                reviewBtn.tintColor = AppStaticColors.buttonBackGroundColor
                
                let details = UIImage(named: "sharp-arrow-line")?.withRenderingMode(.alwaysTemplate)
                detailBtn.setImage(details, for: .normal)
                detailBtn.tintColor = AppStaticColors.buttonBackGroundColor
                let reorder = UIImage(named: "sharp-repeat")?.withRenderingMode(.alwaysTemplate)
                reOrderBtn.setImage(reorder, for: .normal)
                reOrderBtn.tintColor = AppStaticColors.buttonBackGroundColor
            }
            
        }
    }
}
