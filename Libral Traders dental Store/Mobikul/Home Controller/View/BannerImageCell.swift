import UIKit

class BannerImageCell: UICollectionViewCell {
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bannerImageView?.clipsToBounds = true
    }
    
    var item: Banners! {
        didSet {
            self.bannerImageView.setImage(fromURL: item.url, dominantColor: item.dominantColor)
            if item.title != "" {
                self.nameLbl.isHidden = false
                self.nameLbl.text = item.title
            } else {
                self.nameLbl.isHidden = true
            }
        }
    }
    
    var bannerItem: BannerImages! {
        didSet {
            self.bannerImageView.setImage(fromURL: bannerItem.url, dominantColor: bannerItem.dominantColor)
            if bannerItem.title != "" {
                self.nameLbl.isHidden = false
                self.nameLbl.text = bannerItem.title
            } else {
                self.nameLbl.isHidden = true
            }
        }
    }
}
