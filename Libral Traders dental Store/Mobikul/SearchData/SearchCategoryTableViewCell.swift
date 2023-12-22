//
//  SearchCategoryTableViewCell.swift
//  Mobikul Single App
//
//  Created by akash on 08/02/19.
//  Copyright © 2019 kunal. All rights reserved.
//

import UIKit

class SearchCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    var categories = [Categories]()
    weak var delegate: SeachProtocols?
    override func awakeFromNib() {
        super.awakeFromNib()
        let layout = NCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        categoryCollectionView.collectionViewLayout = layout
        categoryCollectionView.showsHorizontalScrollIndicator = false
        categoryCollectionView.register(cellType: SearchCategoryCollectionViewCell.self)
        self.categoryCollectionView.delegate = self
        self.categoryCollectionView.dataSource = self
        self.categoryCollectionView.isScrollEnabled = false
    }
    
    override func layoutSubviews() {
            super.layoutSubviews()
            layoutIfNeeded()
      }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension SearchCategoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return  self.configureCategoryCell(collectionView: collectionView, indexPath: indexPath)
    }
    
    func configureCategoryCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(with: SearchCategoryCollectionViewCell.self, for: indexPath) {
            cell.nameLbl.text = String.init(format: "%@", categories[indexPath.row].name)
           
            if #available(iOS 12.0, *) {
                if self.traitCollection.userInterfaceStyle == .dark {
                    cell.nameLbl.backgroundColor = AppStaticColors.darkButtonBackGroundColor
                    cell.nameLbl.textColor = AppStaticColors.darkButtonTextColor
                } else {
                    cell.nameLbl.backgroundColor = AppStaticColors.buttonBackGroundColor
                    cell.nameLbl.textColor = AppStaticColors.buttonTextColor
                }
            } else {
                cell.nameLbl.backgroundColor = AppStaticColors.buttonBackGroundColor
                cell.nameLbl.textColor = AppStaticColors.buttonTextColor
            }
            cell.nameLbl.layer.cornerRadius = 8
            cell.nameLbl.layer.masksToBounds = true
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 100
        if width < (String.init(format: "%@", categories[indexPath.row].name)).widthOfString(usingFont: UIFont.boldSystemFont(ofSize: 14)) + 30 {
            width = (String.init(format: "%@", categories[indexPath.row].name)).widthOfString(usingFont: UIFont.boldSystemFont(ofSize: 14)) + 30
        }
        return CGSize(width: width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if categories[indexPath.row].hasChildren {
            delegate?.productFromSubCategory(id: categories[indexPath.row].id, name: categories[indexPath.row].name)
        } else {
            delegate?.productListFromCategory(id: categories[indexPath.row].id, name: categories[indexPath.row].name)
        }
    }
}

class NCollectionViewFlowLayout: UICollectionViewFlowLayout {
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let answer = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        let count = answer.count
        if count > 0 {
            for i in 1..<count {
                let currentLayoutAttributes = answer[i]
                let prevLayoutAttributes = answer[i-1]
                let origin = prevLayoutAttributes.frame.maxX
                if (origin + CGFloat(0) + currentLayoutAttributes.frame.size.width) < self.collectionViewContentSize.width && currentLayoutAttributes.frame.origin.x > prevLayoutAttributes.frame.origin.x {
                    var frame = currentLayoutAttributes.frame
                    frame.origin.x = origin + CGFloat(0)
                    currentLayoutAttributes.frame = frame
                }
            }
        }
        return answer
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
