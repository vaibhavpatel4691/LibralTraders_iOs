//
//  EmptyNewAddressView.swift
//  WooCommerce
//
//  Created by Webkul  on 09/11/17.
//  Copyright © 2017 Webkul . All rights reserved.
//

import UIKit

class EmptyView: UIView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var emptyImages: UIImageView!
    @IBOutlet weak var titleText: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
     func commonInit() {
        Bundle.main.loadNibNamed("EmptyView", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.frame
         containerView.frame.origin.y = 0 - containerView.frame.origin.y
         actionBtn.frame.origin.y = AppDimensions.screenHeight - containerView.frame.origin.y
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        actionBtn.layer.cornerRadius = 5
        actionBtn.layer.masksToBounds = true
        if #available(iOS 12.0, *) {
                  if self.traitCollection.userInterfaceStyle == .dark {
                      actionBtn.backgroundColor = AppStaticColors.darkButtonBackGroundColor
                      actionBtn.setTitleColor(AppStaticColors.darkButtonTextColor, for: .normal)
                      
                  } else {
                      actionBtn.backgroundColor = AppStaticColors.buttonBackGroundColor
                      actionBtn.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
                  }
              } else {
                  actionBtn.backgroundColor = AppStaticColors.buttonBackGroundColor
                  actionBtn.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
              }
    }
    func theme() {
        if #available(iOS 12.0, *) {
                  if self.traitCollection.userInterfaceStyle == .dark {
                      actionBtn.backgroundColor = AppStaticColors.darkButtonBackGroundColor
                      actionBtn.setTitleColor(AppStaticColors.darkButtonTextColor, for: .normal)
                      
                  } else {
                      actionBtn.backgroundColor = AppStaticColors.buttonBackGroundColor
                      actionBtn.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
                  }
              } else {
                  actionBtn.backgroundColor = AppStaticColors.buttonBackGroundColor
                  actionBtn.setTitleColor(AppStaticColors.buttonTextColor, for: .normal)
              }
    }
}
