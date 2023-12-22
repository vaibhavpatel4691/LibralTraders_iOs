//
/**
 * Webkul Software.
 * @package  Mobikul App
 * @Category Webkul
 * @author Webkul <support@webkul.com>
 * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 * @license https://store.webkul.com/license.html ASL Licence
 * @link https://store.webkul.com/license.html
 
 */


import UIKit

class WalkThroughCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var topWalkImg: NSLayoutConstraint!
    @IBOutlet weak var walkThroughImg: ImageLoader!
    @IBOutlet weak var skip: UIButton!
    @IBOutlet weak var nextStepBtn: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleDataLbl: UILabel!
    
    @IBOutlet weak var skipTop: NSLayoutConstraint!
    @IBOutlet weak var nextBottom: NSLayoutConstraint!
    @IBOutlet weak var previousBottom: NSLayoutConstraint!
    @IBOutlet weak var contentDataView: UIView!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var walkThroughHeight: NSLayoutConstraint!
    @IBOutlet weak var previous: UIButton!
    
    @IBOutlet weak var skipClickView: UIView!
    @IBOutlet weak var skipView: UIView!
    
    var callBack: ((_ type: String)->Void)?
    @IBOutlet weak var nextArrow: UIImageView!
    @IBOutlet weak var skipFirstImg: UIImageView!
    @IBOutlet weak var skipSecondImg: UIImageView!
    @IBOutlet weak var prevFirstImg: UIImageView!
    @IBOutlet weak var prevSecondImg: UIImageView!
    @IBOutlet weak var previousView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setView()
    }
    
    // Initialization code


var walkThroughDataValue: WalkthroughData? {
    didSet {
        //walkThroughImg.backgroundColor = UIColor().hexToColor(hexString: walkThroughDataValue?.imageDominantColor ?? "#E5E5E5").darker(by: 30)
        contentDataView.backgroundColor = UIColor.clear
        //self.backgroundColor = UIColor().hexToColor(hexString: walkThroughDataValue?.colorCode ?? "#E5E5E5")
        
        self.skip.backgroundColor = UIColor().hexToColor(hexString: walkThroughDataValue?.colorCode ?? "#E5E5E5")
        self.skipView.backgroundColor = UIColor().hexToColor(hexString: walkThroughDataValue?.colorCode ?? "#E5E5E5")
        
        self.nextStepBtn.backgroundColor = UIColor().hexToColor(hexString: walkThroughDataValue?.colorCode ?? "#E5E5E5")
        self.nextArrow.backgroundColor = UIColor().hexToColor(hexString: walkThroughDataValue?.colorCode ?? "#E5E5E5")
        self.previous.backgroundColor = UIColor().hexToColor(hexString: walkThroughDataValue?.colorCode ?? "#E5E5E5")
        
        self.previousView.backgroundColor = UIColor().hexToColor(hexString: walkThroughDataValue?.colorCode ?? "#E5E5E5")
        self.prevFirstImg.backgroundColor = UIColor().hexToColor(hexString: walkThroughDataValue?.colorCode ?? "#E5E5E5")
        
        self.prevSecondImg.backgroundColor = UIColor().hexToColor(hexString: walkThroughDataValue?.colorCode ?? "#E5E5E5")
        self.nextArrow.backgroundColor = UIColor().hexToColor(hexString: walkThroughDataValue?.colorCode ?? "#E5E5E5")
        self.skipView.backgroundColor = UIColor().hexToColor(hexString: walkThroughDataValue?.colorCode ?? "#E5E5E5")
        self.skipFirstImg.backgroundColor = UIColor().hexToColor(hexString: walkThroughDataValue?.colorCode ?? "#E5E5E5")
        self.skipSecondImg.backgroundColor = UIColor().hexToColor(hexString: walkThroughDataValue?.colorCode ?? "#E5E5E5")
        
        if let data = (walkThroughDataValue?.description) {
            contentLbl.text = data
        }
        if let data = (walkThroughDataValue?.title) {
            titleDataLbl.text = data
        }
        walkThroughImg.setImage(fromURL: walkThroughDataValue?.image ?? "", dominantColor: walkThroughDataValue?.imageDominantColor ?? "")
        
        if let strUrl = (walkThroughDataValue?.image ?? "").addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
            let imgUrl = URL(string: strUrl) {
            
            walkThroughImg.loadImageWithUrl(imgUrl, walkThroughDataValue?.imageDominantColor ?? "#E5E5E5", walkThroughDataValue?.colorCode ?? "#E5E5E5") // call this line for getting image to yourImageView
            
        }
    }
    
    
}
func setView() {
    if AppDimensions.screenWidth <= 375.0 {
        topWalkImg.constant = 80
    } else {
        topWalkImg.constant = 123
    }
    walkThroughHeight.constant = (AppDimensions.screenWidth - 120)
    //        walkThroughImg.roundCorners(corners: [.topLeft, .topRight], radius: 8)
    contentDataView.roundCornersWithSpecificCorners([.topRight, .topLeft], radius: 14)
    skip.setTitle("Skip".localized, for: .normal)
    if !(UIDevice().hasNotch) {
        skipTop.constant = 14
        previousBottom.constant = 14
        nextBottom.constant = 14
    }
    skipView.addTapGestureRecognizer {
        self.callBack?("skip")
    }
    previousView.addTapGestureRecognizer {
        self.callBack?("prev")
    }
    nextArrow.addTapGestureRecognizer {
        self.callBack?("next")
    }
    nextStepBtn.addTapGestureRecognizer {
        self.callBack?("next")
    }
    previous.addTapGestureRecognizer {
        self.callBack?("prev")
    }
    skip.addTapGestureRecognizer {
        self.callBack?("skip")
    }
    skipClickView.addTapGestureRecognizer {
        self.callBack?("skip")
    }
    skipFirstImg.addTapGestureRecognizer {
        self.callBack?("skip")
    }
    skipSecondImg.addTapGestureRecognizer {
        self.callBack?("skip")
    }
    
    if Defaults.language == "ar" {
        nextArrow.image = UIImage(named: "leftArrow")
        skipFirstImg.image = UIImage(named: "leftArrow")
        skipSecondImg.image = UIImage(named: "leftArrow")
        prevFirstImg.image = UIImage(named: "arrow")
        prevSecondImg.image = UIImage(named: "arrow")
        nextStepBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        previous.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        skip.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        skip.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        previous.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        nextStepBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    } else {
        nextArrow.image = UIImage(named: "arrow")
        skipFirstImg.image = UIImage(named: "arrow")
        skipSecondImg.image = UIImage(named: "arrow")
        prevFirstImg.image = UIImage(named: "leftArrow")
        prevSecondImg.image = UIImage(named: "leftArrow")
        nextStepBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        previous.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        skip.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        skip.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        previous.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        nextStepBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        
    }
}
}
