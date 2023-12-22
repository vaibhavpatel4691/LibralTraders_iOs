//
//  CategoryHeaderCollectionReusableView.swift
//  Mobikul Single App
//
//  Created by akash on 11/02/19.
//  Copyright © 2019 kunal. All rights reserved.
//

import UIKit

class CategoryHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var sortFilterGridListView: SortFilterGridListView!
    var categories = [String]()
    var dominantColor: String = ""
    @IBOutlet weak var pageController: CHIPageControlFresno!
    
    var banner = [BannerImages]()
    var timer: Timer?
    var item = 0
    
    @IBOutlet weak var page: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        categoryCollectionView.register(cellType: SliderImageCollectionViewCell.self)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        pageController.radius = 4
        pageController.tintColor = .white
        pageController.borderWidth = 1
        pageController.layer.borderColor = UIColor.white.cgColor
        pageController.currentPageTintColor = .white
        pageController.tintColor = AppStaticColors.accentColor
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (_) in
            if self.banner.count > 0 {
                if self.banner.count > self.item {
                    self.pageController?.set(progress: (self.item), animated: true)
                    self.categoryCollectionView.scrollToItem(at: IndexPath(item: self.item, section: 0), at: .centeredHorizontally, animated: true)
                } else {
                    self.item = 0
                    self.pageController?.set(progress: (self.item), animated: true)
                    self.categoryCollectionView.scrollToItem(at: IndexPath(item: self.item, section: 0), at: .centeredHorizontally, animated: true)
                }
                self.item += 1
            }
        })
    }
    deinit {
        timer?.invalidate()
    }
}


extension CategoryHeaderCollectionReusableView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageController.numberOfPages = banner.count
        return banner.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderImageCollectionViewCell", for: indexPath) as? SliderImageCollectionViewCell {
            cell.sliderImg.setImage(fromURL: banner[indexPath.row].url, dominantColor: banner[indexPath.row].dominantColor)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
           return CGSize(width: AppDimensions.screenWidth, height: 2*AppDimensions.screenWidth / 3)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

extension CategoryHeaderCollectionReusableView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            pageController?.set(progress: Int(scrollView.contentOffset.x / AppDimensions.screenWidth), animated: true)
        }    }
    
   
}
