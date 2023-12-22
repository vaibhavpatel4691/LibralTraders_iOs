import UIKit
import Firebase

class CartProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var wishlistBtn: UIButton!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var discountPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var productOptions: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var drouDownImg: UIImageView!
    var wishListClickedclousre:(()->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        let origImage = UIImage(named: "down")
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        drouDownImg.image = tintedImage
        if Defaults.language == "ar" {
            wishlistBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
            removeBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        }
        theme()
        // Initialization code
    }
    
    func theme() {
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                removeBtn.backgroundColor = AppStaticColors.darkButtonTextColor
                removeBtn.setTitleColor(AppStaticColors.darkButtonBackGroundColor, for: .normal)
                wishlistBtn.backgroundColor = AppStaticColors.darkButtonTextColor
                wishlistBtn.setTitleColor(AppStaticColors.darkButtonBackGroundColor, for: .normal)
                let image = UIImage(named: "sharp-favorite_border-24px")?.withRenderingMode(.alwaysTemplate)
                wishlistBtn.setImage(image, for: .normal)
                wishlistBtn.tintColor = AppStaticColors.darkButtonBackGroundColor
                let remove = UIImage(named: "Icon-Trash")?.withRenderingMode(.alwaysTemplate)
                removeBtn.setImage(remove, for: .normal)
                removeBtn.tintColor = AppStaticColors.darkButtonBackGroundColor
                
                drouDownImg.tintColor = UIColor.gray

            } else {
                removeBtn.backgroundColor = AppStaticColors.buttonTextColor
                removeBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
                wishlistBtn.backgroundColor = AppStaticColors.buttonTextColor
                wishlistBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
                let image = UIImage(named: "sharp-favorite_border-24px")?.withRenderingMode(.alwaysTemplate)
                wishlistBtn.setImage(image, for: .normal)
                wishlistBtn.tintColor = AppStaticColors.buttonBackGroundColor
                let remove = UIImage(named: "Icon-Trash")?.withRenderingMode(.alwaysTemplate)
                removeBtn.setImage(remove, for: .normal)
                removeBtn.tintColor = AppStaticColors.buttonBackGroundColor
                drouDownImg.tintColor = UIColor.black
            }
        } else {
            removeBtn.backgroundColor = AppStaticColors.buttonTextColor
            removeBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
            wishlistBtn.backgroundColor = AppStaticColors.buttonTextColor
            wishlistBtn.setTitleColor(AppStaticColors.buttonBackGroundColor, for: .normal)
            let image = UIImage(named: "sharp-favorite_border-24px")?.withRenderingMode(.alwaysTemplate)
            wishlistBtn.setImage(image, for: .normal)
            wishlistBtn.tintColor = AppStaticColors.buttonBackGroundColor
            let remove = UIImage(named: "Icon-Trash")?.withRenderingMode(.alwaysTemplate)
            removeBtn.setImage(remove, for: .normal)
            removeBtn.tintColor = AppStaticColors.buttonBackGroundColor
            drouDownImg.tintColor = UIColor.black

        }

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        removeBtn.setTitle("Remove Item".localized, for: .normal)
        wishlistBtn.setTitle("Move to Wishlist".localized, for: .normal)
        
        productImage.addTapGestureRecognizer {
            let nextController = ProductPageDataViewController.instantiate(fromAppStoryboard: .product)
            nextController.productId = self.item.productId
            nextController.productName = self.item.name
            self.viewContainingController?.navigationController?.pushViewController(nextController, animated: true)
        }
        
        productName.addTapGestureRecognizer {
            let nextController = ProductPageDataViewController.instantiate(fromAppStoryboard: .product)
            nextController.productId = self.item.productId
            nextController.productName = self.item.name
            self.viewContainingController?.navigationController?.pushViewController(nextController, animated: true)
        }
        
        // Configure the view for the selected state
    }
    @IBAction func wishlistClicked(_ sender: Any) {
        wishListClickedclousre?()
        
        //MARK:- ADD_TO_WISHLIST Analytics

        Analytics.setScreenName("Cart", screenClass: "CartDataViewController.class")
         Analytics.logEvent("ADD_TO_WISHLIST", parameters: ["productid":self.item.productId ,"name": self.item.name])
    }
    @IBAction func removeClicked(_ sender: Any) {
    }
    @IBAction func editClicked(_ sender: Any) {
        let nextController = ProductPageDataViewController.instantiate(fromAppStoryboard: .product)
        nextController.productId = self.item.productId
        nextController.itemId = self.item.id
        nextController.quantity = self.item.qty
        nextController.parentController = "cart"
        nextController.productName = self.item.name
        self.viewContainingController?.navigationController?.pushViewController(nextController, animated: true)
    }
    
    var item: CartProducts! {
        didSet {
            self.productImage.setImage(fromURL: item.image, dominantColor: item.dominantColor)
            self.productName.text = item.name
            self.productOptions.text = item.optionString
            self.qtyLabel.text = "Qty".localized + ": " + item.qty
            self.priceLabel.text = item.formattedFinalPrice1
            self.messageLabel.text = item.messages
            discountPriceLabel.attributedText = item.strikePrice
            self.subTotalLabel.text = "Subtotal".localized + ": " + item.subTotal
            self.subTotalLabel.halfTextWithColorChange(fullText: self.subTotalLabel.text!, changeText: "Subtotal".localized + ": ", color: AppStaticColors.labelSecondaryColor)
            self.qtyLabel.halfTextWithColorChange(fullText: self.qtyLabel.text!, changeText: "Qty".localized + ": ", color: AppStaticColors.labelSecondaryColor)
            self.theme()
        }
    }
    
}
