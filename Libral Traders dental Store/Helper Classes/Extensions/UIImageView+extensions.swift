//
/**
 Mobikul_Magento2V3_App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: UIImageView+extensions.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import Kingfisher
import UIKit

extension UIImageView {
    func addBlackGradientLayer(frame: CGRect, colors: [UIColor]) {
        let gradient = CAGradientLayer()
        gradient.frame = frame
        
        gradient.colors = colors.map {$0.cgColor}
        self.layer.addSublayer(gradient)
    }
    
    func setImage(fromURL url: String?, dominantColor: String? = "", placeholder: UIImage? = nil) {
        if let urlString = url, let url = URL(string: urlString) {
            var placeHolder = placeholder
            #if GROCERY
            placeHolder = UIImage(named: "placeholder-Grocery")
            #endif
            let resource = ImageResource(downloadURL: url, cacheKey: urlString)
            if let dominantColor = dominantColor, dominantColor.count > 0 {
                self.backgroundColor = UIColor().hexToColor(hexString: dominantColor)
            } else {
               // placeHolder = UIImage(named: "placeholder")
            }
            self.kf.setImage(with: resource, placeholder: placeHolder, options: nil, progressBlock: nil) { (_) in
                self.backgroundColor = UIColor.white
            }
        } else {
            #if GROCERY
            self.image = UIImage(named: "placeholder-Grocery")
            #else
            self.image = UIImage(named: "placeholder")
            #endif
        }
    }
    func setImageHomeLogo(fromURL url: String?, dominantColor: String? = "", placeholder: UIImage? = nil) {
        if let urlString = url, let url = URL(string: urlString) {
            var placeHolder = placeholder
         #if GROCERY
         placeHolder = UIImage(named: "placeholder-Grocery")
         #endif
            let resource = ImageResource(downloadURL: url, cacheKey: urlString)
            if let dominantColor = dominantColor, dominantColor.count > 0 {
                self.backgroundColor = UIColor().hexToColor(hexString: dominantColor)
            } else {
             #if GROCERY
             placeHolder = UIImage(named: "placeholder-Grocery")
             #else
             placeHolder = UIImage(named: "placeholder")
             #endif
            }
            self.kf.setImage(with: resource, placeholder: placeHolder, options: nil, progressBlock: nil) { (_) in
                //self.backgroundColor = UIColor.white
            }
        } else {
            self.image = UIImage(named: "placeholder")
        }
    }
}

let imageCache = NSCache<AnyObject, AnyObject>()

class ImageLoader: UIImageView {

    var imageURL: URL?

    let activityIndicator = UIActivityIndicatorView()

    func loadImageWithUrl(_ url: URL, _ dominantColor: String = "", _ backGroundColor: String = "") {

        // setup activityIndicator...
        activityIndicator.color = .white
        activityIndicator.isHidden = true
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        imageURL = url
   self.backgroundColor = UIColor().hexToColor(hexString: dominantColor)
        image = nil
        //activityIndicator.startAnimating()

        // retrieves image if already available in cache
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.backgroundColor = UIColor.clear
            self.image = imageFromCache
            //activityIndicator.stopAnimating()
            return
        }

        // image does not available in cache.. so retrieving it from url...
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in

            if error != nil {
                print(error as Any)
                DispatchQueue.main.async(execute: {
                    //self.activityIndicator.stopAnimating()
                })
                return
            }

            DispatchQueue.main.async(execute: {

                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {

                    if self.imageURL == url {
                        self.backgroundColor = UIColor.clear
                        self.image = imageToCache
                    }

                    imageCache.setObject(imageToCache, forKey: url as AnyObject)
                }
                //self.activityIndicator.stopAnimating()
            })
        }).resume()
    }
}

public enum ImageAnimation {
    case flipFromLeft
    case flipFromRight
    case fade
    
    /// Kingfisher transition. This keeps all animation code together rather than distributed in the codebase.
    /// Makes it easier to hadle it and modify it in the future
    ///
    /// - Returns: current third party library animator. Currently: ImageTransition
    func convert(withDuration duration: TimeInterval) -> ImageTransition {
        switch self {
        case .flipFromLeft:
            return ImageTransition.flipFromLeft(duration)
        case .flipFromRight:
            return ImageTransition.flipFromRight(duration)
        case .fade:
            return ImageTransition.fade(duration)
        }
    }
}
extension UIImageView {
func roundCorners(corners: UIRectCorner, radius: CGFloat) {
     let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
     let mask = CAShapeLayer()
     mask.path = path.cgPath
     layer.mask = mask
 }
}
