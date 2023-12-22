//
/**
* Webkul Software.
* @package  Mobikul Single App
* @Category Webkul
* @author Webkul <support@webkul.com>
* FileName: CategoryPageSubCategoryNoonTableViewCell.swift
* @Copyright (c) 2010-2019 Webkul Software Private Limited (https://webkul.com)
* @license https://store.webkul.com/license.html ASL Licence
* @link https://store.webkul.com/license.html

*/


import UIKit

class CategoryPageSubCategoryNoonTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var headingView: UIView!
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var collapseImg: UIImageView!
    @IBOutlet weak var subCategoryCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subCategoryCollectionView.register(cellType: SubCategoriesCollectionViewCell.self)
//        subCategoryCollectionView.delegate = self
//                   subCategoryCollectionView.dataSource = self
//                   subCategoryCollectionView.reloadData()
        // Initialization code
    }

    
    var categoriesList: [ChildCategory]? {
        didSet {
            subCategoryCollectionView.delegate = self
            subCategoryCollectionView.dataSource = self
            subCategoryCollectionView.reloadData()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoriesList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubCategoriesCollectionViewCell.identifier, for: indexPath)as? SubCategoriesCollectionViewCell {
            cell.categoryName.text = self.categoriesList?[indexPath.row].name ?? ""
            cell.categoryImg.setImage(fromURL: self.categoriesList?[indexPath.row].thumbnail ?? "")
            //cell.imageHeight.constant = (collectionView.frame.size.width / 3)
            return cell
        }
        return UICollectionViewCell()
    }
    
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return CGSize(width: ((AppDimensions.screenWidth - 100 ) / 3) - 16, height: (4*((AppDimensions.screenWidth - 116 ) / 3) / 5) + 50)
   }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if categoriesList?[indexPath.row].hasChildren ?? false {
            let viewController = SubCategoriesViewController.instantiate(fromAppStoryboard: .product)
            viewController.categoryId = categoriesList?[indexPath.row].id ?? ""
            viewController.categoryName = categoriesList?[indexPath.row].name ?? ""
            self.viewContainingController?.navigationController?.pushViewController(viewController, animated: true)
        } else {
            let nextController = CategoryProductsViewController.instantiate(fromAppStoryboard: .product)
            nextController.categoryId = categoriesList?[indexPath.row].id ?? ""
            if categoriesList?[indexPath.row].viewAllCategoryCheck ??  false {
                nextController.titleName = categoriesList?[indexPath.row].title
                    ?? ""
            } else {
            nextController.titleName = categoriesList?[indexPath.row].name ?? ""
            }
            nextController.categoryType = "category"
            self.viewContainingController?.navigationController?.pushViewController(nextController, animated: true)
        }
    }
}
