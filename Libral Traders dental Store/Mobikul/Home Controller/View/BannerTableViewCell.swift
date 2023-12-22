@objc protocol bannerViewControllerHandlerDelegate: class {
    func bannerProductClick(type: String, image: String, id: String, title: String)
}

import UIKit

class BannerTableViewCell: UITableViewCell {
    weak var delegate: bannerViewControllerHandlerDelegate?
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    var bannerCollectionModel = [BannerImages]()
    @IBOutlet weak var bannerCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var textTitleLabel: UILabel!
    
    var index: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if Defaults.language == "ar" {
            self.textTitleLabel?.textAlignment = .right
        } else {
            self.textTitleLabel?.textAlignment = .left
        }
        bannerCollectionViewHeight.constant = AppDimensions.screenWidth/2
        bannerCollectionView.register(UINib(nibName: "BannerImageCell", bundle: nil), forCellWithReuseIdentifier: "bannerImageCell")
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension BannerTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return bannerCollectionModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: BannerImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerImageCell", for: indexPath) as? BannerImageCell {
            cell.bannerItem = bannerCollectionModel[indexPath.row]
            cell.layoutIfNeeded()
            return cell
        } else {
            return UICollectionViewCell()
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: collectionView.frame.size.width, height: 2*AppDimensions.screenWidth/3 - 16)
        return CGSize(width: collectionView.frame.size.width, height: 2*AppDimensions.screenWidth/3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
        return UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0) // top, left, bottom, right
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if bannerCollectionModel[indexPath.row].bannerType == "category"{
            let nextController = CategoryProductsViewController.instantiate(fromAppStoryboard: .product)
            nextController.categoryId = bannerCollectionModel[indexPath.row].id
            nextController.titleName = bannerCollectionModel[indexPath.row].categoryName
            nextController.categoryType = ""
            nextController.titleName = bannerCollectionModel[indexPath.row].categoryName
            self.viewContainingController?.navigationController?.pushViewController(nextController, animated: true)
        } else {
            let nextController = ProductPageDataViewController.instantiate(fromAppStoryboard: .product)
            nextController.productId = bannerCollectionModel[indexPath.row].id
            nextController.productName = bannerCollectionModel[indexPath.row].productName
            self.viewContainingController?.navigationController?.pushViewController(nextController, animated: true)
            //            delegate?.bannerProductClick(type: bannerCollectionModel[indexPath.row].bannerType!, image: bannerCollectionModel[indexPath.row].url!, id: id, title: bannerCollectionModel[indexPath.row].productName!)
        }
        
    }
    
}
