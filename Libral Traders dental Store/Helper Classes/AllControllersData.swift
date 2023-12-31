//
/**
 Mobikul Single App
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: AllControllersData.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit

enum AppStoryboard: String {
    case main = "Main"
    case customer = "Customer"
    case product = "Product"
    case checkout = "Checkout"
    case search = "Search"
    case more = "More"
    case seller = "Seller"
    case marketplace = "Marketplace"
    case b2b = "B2B"
    case quickorder = "QuickOrder"
    case buyingleads = "BuyingLeads"
    case supplierquote = "SupplierQuote"
    case hyperlocal = "HyperlocalStoryboard"
    case arStoryboard = "ArMeasureStoryboard"
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T: UIViewController>(viewControllerClass: T.Type, function: String = #function, line: Int = #line, file: String = #file) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        return scene
    }
    
    func initialViewController() -> UIViewController? {
        
        return instance.instantiateInitialViewController()
    }
}

enum AllControllers: String {
    case homeController = "ViewController"
    case signInController = "CustomerLoginViewController"
    case signUpController = "CreateAccount"
    case myProfile = "MyProfileController"
    case socialLogin = "SocialLoginViewController"
    case productcategory = "Productcategory"
    case commentsController
    case wishlistDataViewController = "WishlistDataViewController"
    case orderAgainViewController = "OrderAgainViewController"
    case orderCancelVC = "OrderCancelVC"
    case addressBookListViewController = "AddressBookListViewController"
    case myOrders = "MyOrders"
    case qrCode
    case liveChat
    case dashboardViewController = "DashboardDataViewController"
    case downloadViewController = "DownloadableProductDataViewController"
    case contactUsController = "ContactUsDataViewController"
    case accountInformation = "AccountInformationViewController"
    case productReviewList = "ProductReviewListViewController"
    case orderDetailsDataViewController = "OrderDetailsDataViewController"
    case reOrder = "ReOrder"
    case removeCompare
    case addToCart
    case addToWishlist
    case removeFromWishlist
    case reloadTableView
    case none = " "
    case compareListViewController = "CompareListViewController"
    case allReviews = "AllReviewsDataViewController"
    case reviewDetails = "ProductReviewDetailDataViewController"
    case orderReview = "OrderReviewListProductViewController"
    case productPage = "ProductPageDataViewController"
    case orderReturn = "OrderAndReturnsDataViewController"
    case newAddress = "NewAddressDataViewController"
    case checkout = "CheckoutDataViewController"
    case orderListViewController = "OrderListViewController"
    case orderTrackViewController = "OrderTrackViewController"
    
    #if MARKETPLACE || BTOB || HYPERLOCAL
    #if BTOB
    case requestQuote = "RequestQuoteViewController"
    case myRequestedQuote = "MyRequestedQuoteViewController"
    case supplierMessageList = "SupplierListViewController"
    case customerMessageList = "customerListViewController"
    case supplierCustomerChat = "SupplierCustomerChatViewController"
    case supplierRegisteration = "SupplierRegisterationViewController"
    case supplierLogin = "LoginViewController"
    case quickOrderForm = "QuickOrderFormViewController"
    case buyingLeads = "BuyingLeadsListViewController"
    case supplierQuote = "QuotesListViewController"
    case supplierSettings = "SupplierSettingViewController"
    case verification = "VerificationViewController"
    #endif
    
    #if HYPERLOCAL
    case shippingArea = "AddShippingAreaController"
    case sellerShippingOrigin = "AddShippingOriginController"
    case shipRate = "ShipRateController"
    #endif
    case marketPlace = "MarketPlaceViewController"
    case sellerDashboard = "SellerDashboardDetailsViewController"
    case sellerInfo = "SellerInfoViewController"
    case askAdmin = "AskAdminViewController"
    case sellerList = "SellerListViewController"
    case sellerContactUs = "SellerContactUsViewController"
    case createAttribute = "CreateAttributeViewController"
    case invoiceTemplate = "InvoiceTemplateViewController"
    case editSellerProfile = "SellerEditProfileViewController"
    case addNewProduct = "AddProductViewController"
    case sellerProducts = "SellerProductsViewController"
    case sellerOrders = "SellerOrdersViewController"
    case transactions = "TransactionsViewController"
    case becomeSeller = "BecomeSellerViewController"
    case chat = "ChatViewController"
    case chatSellerList = "ChatSellerListController"
    case customerList = "CustomerListViewController"
    #else
    #endif
}
