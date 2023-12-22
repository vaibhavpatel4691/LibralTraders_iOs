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

class WalkThroughViewController: UIViewController {
    
    @IBOutlet weak var page: UIView!
    @IBOutlet weak var pagingViewBottom: NSLayoutConstraint!
    @IBOutlet weak var walkThroughCollectionView: UICollectionView!
    var homeJsonData: JSON = ""
    var pageControlView = CHIPageControlFresno()
    var index = 0
    
    @IBOutlet weak var mainView: UIView!
    var scroollY = CGFloat(0.0)
    var walkThroughArray = [WalkthroughData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        pageControlView =  CHIPageControlFresno(frame: page.frame)
        pageControlView.radius = 4
        pageControlView.tintColor = .gray
        pageControlView.borderWidth = 1
        pageControlView.layer.borderColor = UIColor.white.cgColor
        pageControlView.currentPageTintColor = AppStaticColors.blackColor
        pageControlView.center = CGPoint(x: AppDimensions.screenWidth/2, y: 0)
        page.addSubview(pageControlView)
        if !(UIDevice().hasNotch) {
            pagingViewBottom.constant = 8
        }
        walkThroughCollectionView.register(cellType: WalkThroughCollectionViewCell.self)
        self.navigationController?.isNavigationBarHidden = true
        if walkThroughArray.count > 0 {
            if Defaults.walkThroughVersion == 0.0 {
                GlobalVariables.walkThroughFirstTime = true
            }
            walkThroughCollectionView.delegate = self
            walkThroughCollectionView.dataSource = self
            walkThroughCollectionView.reloadData()
            walkThroughCollectionView.layoutIfNeeded()
            
        } else {
            self.performSegue(withIdentifier: "moveToWalkThroughHome", sender: self)
        }
        for views in self.mainView.subviews {
            views.semanticContentAttribute = .forceLeftToRight
        }
        walkThroughCollectionView.semanticContentAttribute = .forceLeftToRight
        mainView.semanticContentAttribute = .forceLeftToRight
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewWillLayoutSubviews() {
        
        
    }
    
    
}
extension WalkThroughViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: AppDimensions.screenWidth, height: (UIScreen.main.bounds.size.height) )
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControlView.numberOfPages = walkThroughArray.count
        return walkThroughArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WalkThroughCollectionViewCell.identifier, for: indexPath) as? WalkThroughCollectionViewCell {
            cell.walkThroughDataValue = walkThroughArray[indexPath.row]
            cell.backgroundColor = UIColor().hexToColor(hexString: walkThroughArray[indexPath.row].colorCode ?? "#E5E5E5")
            self.mainView.backgroundColor = UIColor().hexToColor(hexString: walkThroughArray[indexPath.row].colorCode ?? "#E5E5E5")
            self.walkThroughCollectionView.backgroundColor = UIColor().hexToColor(hexString: walkThroughArray[indexPath.row].colorCode ?? "#E5E5E5")
            if (indexPath.row + 1) == walkThroughArray.count {
                cell.nextStepBtn.setTitle("Done".localized, for: .normal)
                cell.nextArrow.isHidden = true
                
                cell.skipView.isHidden = true
                cell.skip.isHidden = true
                
            } else {
                cell.nextStepBtn.setTitle("Next".localized, for: .normal)
                cell.nextArrow.isHidden = false
                cell.skipView.isHidden = false
                cell.skip.isHidden = false
            }
            if (indexPath.row) != 0 {
                cell.previous.setTitle("Prev".localized, for: .normal)
                cell.previousView.isHidden = false
            } else {
                cell.previous.setTitle("", for: .normal)
                cell.previousView.isHidden = true
            }
            cell.callBack = { type in
                if type == "skip" {
                    self.performSegue(withIdentifier: "moveToWalkThroughHome", sender: self)
                } else if type == "next" {
                    if self.index < self.walkThroughArray.count {
                        self.index += 1
                        if (indexPath.row + 1) == self.walkThroughArray.count {
                            self.performSegue(withIdentifier: "moveToWalkThroughHome", sender: self)
                        } else {
                            collectionView.contentOffset.x = ((AppDimensions.screenWidth) * CGFloat(self.index))
                            self.pageControlView.set(progress: Int(collectionView.contentOffset.x /  AppDimensions.screenWidth), animated: true)
                        }
                        collectionView.reloadData()
                    } else {
                        self.performSegue(withIdentifier: "moveToWalkThroughHome", sender: self)
                    }
                } else {
                    if self.index != 0 {
                        collectionView.contentOffset.x = ((AppDimensions.screenWidth) * CGFloat(self.index - 1))
                        self.pageControlView.set(progress: Int(collectionView.contentOffset.x /  AppDimensions.screenWidth), animated: true)
                        self.index -= 1
                        collectionView.reloadData()
                    }
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "moveToWalkThroughHome",
                let tabbar = segue.destination as? UITabBarController,
                let navCont = tabbar.viewControllers?[0] as? UINavigationController ,
                let viewController = navCont.topViewController as? ViewController {
                print(viewController)
                viewController.homeJsonData = self.homeJsonData
            }
          
            // Get the new view controller using segue.destinationViewController.
            // Pass the selected object to the new view controller.
        }
}
