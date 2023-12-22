import UIKit
import Alamofire
import Foundation

import ImageIO
import Kingfisher
import QuartzCore

let isIPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

protocol MoveController: class {
    func moveController(id: String, name: String, dict: [String: Any], jsonData: JSON, type: String, controller: AllControllers)
}

public typealias DictType = [String: Any]
typealias MoveDelegate = (id: String, name: String, dict: [String: Any], jsonData: JSON, type: String, controller: AllControllers)

enum WhichApiCall: String {
    //MARK:- M2 Default API
    case registerDevice = "mobikulhttp/extra/registerDevice"
    case loadHome = "mobikulhttp/catalog/homePageData"
    case logout = "mobikulhttp/extra/logout"
    case scanQr = "mobikul/qrcodelogin/savecustomertoken"
    case forgetPassword = "mobikulhttp/customer/forgotpassword"
    case login = "mobikulhttp/customer/logIn"
    case deleteAccount = "/rest/V1/deletecustomer"
    case createAccount = "mobikulhttp/customer/createAccount"
    case createAccountFormData = "mobikulhttp/customer/createAccountFormData"
    case newProductList = "mobikulhttp/catalog/newProductList"
    case featuredProductList = "mobikulhttp/catalog/featuredProductList"
    case hotDealsList = "mobikulhttp/catalog/hotDealList"
    case customCollection = "mobikulhttp/extra/customcollection"
    case categoryProductList = "mobikulhttp/catalog/productCollection"
    case addToWishList = "mobikulhttp/catalog/addtoWishlist"
    case addToCompare = "mobikulhttp/catalog/addtocompare"
    case removeFromWishList = "mobikulhttp/customer/removefromWishlist"
    case addToCart = "mobikulhttp/checkout/addtoCart"
    case notificationList = "mobikulhttp/extra/notificationList"
    case searchTermList = "mobikulhttp/extra/searchTermList"
    case advancedSearchFormData = "mobikulhttp/catalog/advancedsearchformdata"
    case removeFromCompare = "mobikulhttp/catalog/removefromcompare"
    case compareList = "mobikulhttp/catalog/comparelist"
    case contactPost = "mobikulhttp/contact/post"
    case cmsData = "mobikulhttp/extra/cmsData"
    case reorder = "mobikulhttp/customer/reOrder"
    case guestReoder = "mobikulhttp/sales/guestreorder"
    case orderDetailsList = "mobikulhttp/customer/orderList"
    case orderDetails = "mobikulhttp/customer/orderDetails"
    case customerReviewList = "mobikulhttp/customer/ReviewList"
    case cartData = "mobikulhttp/checkout/cartDetails"
    case removeProductFromData = "mobikulhttp/checkout/removeCartItem"
    case wishlistData = "mobikulhttp/customer/Wishlist"
    case wishlistToCart = "mobikulhttp/customer/WishlistToCart"
    case walkThrough = "mobikulhttp/catalog/walkthrough"
    case checkoutAddress = "mobikulhttp/checkout/checkoutaddress"
    case checkoutShippping = "mobikulhttp/checkout/ShippingMethods"
    case selectedPayment = "cod/paymentmethod/selectpaymentmethod"
    case deleteAddress = "mobikulhttp/customer/deleteAddress"
    case addressBook = "mobikulhttp/customer/addressBookData"
    case getAddress = "mobikulhttp/customer/addressformData"
    case saveAddress = "mobikulhttp/customer/saveAddress"
    case checkoutOrderReview = "mobikulhttp/checkout/reviewandpayment"
    case placeOrder = "mobikulhttp/checkout/PlaceOrder"
    case productPage = "mobikulhttp/catalog/productPageData"
    case changerazorpayorderstatus = "mobikulhttp/checkout/changeorderstatus"
    case downloadProductList = "mobikulhttp/customer/MyDownloadsList"
    case saveReview = "mobikulhttp/customer/saveReview"
    case reportSellerProduct = "mobikulmphttp/marketplace/saveproductreport"
    case reportSeller = "mobikulmphttp/marketplace/savesellerreport"
    case wishlistFromCart = "mobikulhttp/Checkout/WishlistFromCart"
    case couponForCart = "mobikulhttp/Checkout/ApplyCoupon"
    case removeCoupon = "removeCoupon"
    case addToWishlist = "mobikulhttp/Catalog/AddToWishlist"
    case ratingFormData = "mobikulhttp/catalog/ratingformdata"
    case subCategoryData = "mobikulhttp/catalog/categoryPageData"
    case accountinfoData = "mobikulhttp/customer/accountinfoData"
    case searchSuggestion = "mobikulhttp/extra/searchSuggestion"
    case updateCart = "mobikulhttp/checkout/updateCart"
    case updateWishlist = "mobikulhttp/customer/UpdateWishlist"
    case emptyCart = "mobikulhttp/checkout/EmptyCart"
    case allReviews = "mobikulhttp/catalog/reviewsandratings"
    case inVoiceDetails = "mobikulhttp/customer/invoiceview"
    case shipmentDetails = "mobikulhttp/customer/shipmentview"
    case signout = "mobikulhttp/extra/logOut"
    case downloadProduct = "mobikulhttp/customer/downloadProduct"
    case reviewDetails = "mobikulhttp/customer/reviewDetails"
    case guestview = "mobikulhttp/sales/guestview"
    case updateitemoptions = "mobikulhttp/checkout/updateitemoptions"
    case saveAccountInfo = "mobikulhttp/customer/saveAccountInfo"
    case checkCustomerByEmail = "mobikulhttp/customer/checkCustomerByEmail"
    case accountcreate = "mobikulhttp/checkout/accountcreate"
    case GetDeliveryboyLocation = "expressdelivery/api/getLocation"
    case chatWithAdmin = "https://us-central1-mobikul-magento2-app.cloudfunctions.net/updateTokenToDataBase"
    case deleteChatToken = "https://us-central1-mobikul-magento2-app.cloudfunctions.net/deleteTokenFromDataBase"
    case shareWishList = "mobikulhttp/sales/sharewishlist"
    case addAllToCart = "mobikulhttp/sales/alltocart"
    case uploadBannerPic = "mobikulhttp/index/uploadBannerPic"
    case uploadProfilePic = "mobikulhttp/index/uploadprofilepic"
    case notifyPrice = "mobikulhttp/productalert/price"
    case notifyStock = "mobikulhttp/productalert/stock"
    case saveDeliveryboyReview = "expressdelivery/api_customer/addreview"
    case none = ""
    case setAddress = "mobikulmphl/catalog/setaddress"
    case cancelOrder = "rest/all/V1/cancelorder/cancelorder"
    case trackOrder = "rest/all/V1/ordertracking/gettrackdata"
    case orderList = "rest/all/V1/reorder/listproductreorder"
    // OTP login
    
    case sendOTP = "otpsystem/customer/sendotp"
    case VerifyOTP = "otpsystem/customer/verifyotp"
    case countryCode = "otpsystem/customer/countrycode"
    
    
    #if MARKETPLACE || BTOB || HYPERLOCAL
    #if BTOB
    //MARK:- B2B API
    case myQuoteList = "mobikulb2b/customer/QuotesRequests"//"mobikulb2b/customer_quote/quoteList"
    case supplierMessageList = "mobikulb2b/supplier/messagelist"
    case customerMessageList = "mobikulb2b/customer/messagelist"
    case supplierMessages = "mobikulb2b/supplier/fetch"
    case quoteAddToCart = "mobikulb2b/customer_quote/purchase"
    case customerMessages = "mobikulb2b/customer/fetch"
    case sendCustomerMessage = "mobikulb2b/customer/sendmessage"
    case sendSupplierMessage = "mobikulb2b/supplier/sendMessage"
    case sendChatMessage = "mobikulb2b/message/send"
    case quoteCategories = "mobikulb2b/customer_quote/requestquoteformdata"
    case uploadSampleProductImage = "mobikulb2b/customer_quote/productImageUpload"
    case uploadAttechment = "mobikulb2b/customer_quote/fileupload"
    case createQuote = "mobikulb2b/customer_quote/create"
    case createSupplier = "mobikulb2b/supplier/CreateAccount"
    case searchProductSku = "mobikulb2b/customer_quote/searchProductSku"
    case createAccountFormDataSupplier = "mobikulb2b/supplier/createaccountformdata"
    case estimateShipping = "mobikulb2b/customer_quickorder/estimateshipping"
    case buyingLeads = "mobikulb2b/supplier/buyingleads"
    //case sendQuotation = "mobikulb2b/supplier_quote/sendquotation"
    case sendQuotation = "mobikulb2b/supplier_quote/requestpost"
    case rfqList = "mobikulb2b/supplier/rfqlist"
    case quoteData = "mobikulb2b/supplier/quotedata"
    case customerQuoteData = "mobikulb2b/customer_quote/quoteData"
    case sendMessage = "mobikulb2b/supplier/quotemessagepost"
    case approveQuote = "mobikulb2b/customer_quote/approve"
    case customerSendMessage = "mobikulb2b/customer_quoterequests/sendmessage"
    case buyingLeadsSendMessage = "mobikulb2b/supplier/buyingleadsmessagepost"
    case supplierResponse = "mobikulb2b/customer_quote/supplierresponse"
    case viewQuoteData = "mobikulb2b/customer_quote/viewquoteData"
    case supplierSettings = "mobikulb2b/supplier/settings"
    case verificationDetails = "mobikulb2b/supplier/verificationdata"
    case sendVerificationMail = "mobikulb2b/supplier/verificationsend"
    case updateSettingsData = "mobikulb2b/supplier_info/update"
    case urlRewrite = "mobikulmphttp/seller/rewriteurlpost"
    #endif
    //MARK:- M2MP API
    case askQuestiontoAdmin = "mobikulmphttp/marketplace/askquestiontoadmin"
    case sellerProfile = "mobikulmphttp/marketplace/SellerProfile"
    case sellerLandingPageData = "mobikulmphttp/marketplace/landingpagedata"
    case sellerDashboard = "mobikulmphttp/marketplace/dashboard"
    case sellerList = "mobikulmphttp/marketplace/sellerlist"
    case saveAttribute = "mobikulmphttp/product/saveattribute"
    case pdfHeaderFormData = "mobikulmphttp/marketplace/pdfHeaderFormData"
    case savePdfHeader = "mobikulmphttp/marketplace/savePdfHeader"
    case sellerProfileFormData = "mobikulmphttp/marketplace/profileFormData"
    case deleteSellerImage = "mobikulmphttp/marketplace/deleteSellerImage"
    case saveSellerProfile = "mobikulmphttp/marketplace/SaveProfile"
    case getdeliveryboylist = "expressdelivery/api_admin/getdeliveryboylist"
    case assignOrder = "expressdelivery/api_admin/assignorder"
    case addProductForm = "mobikulmphttp/product/newformdata"
    case uploadProductImage = "mobikulmphttp/product/UploadProductImage"
    case saveProduct = "mobikulmphttp/product/SaveProduct"
    case checkSKU = "mobikulmphttp/product/checkSku"
    case sellerProductList = "mobikulmphttp/marketplace/productlist"
    case deleteProduct = "mobikulmphttp/marketplace/ProductDelete"
    case sellerOrderList = "mobikulmphttp/marketplace/orderlist"
    case relatedProducts = "mobikulmphttp/product/relatedproductdata"
    case upSellProducts = "mobikulmphttp/product/upsellproductdata"
    case crossSellProducts = "mobikulmphttp/product/crosssellproductdata"
    case transactionList = "mobikulmphttp/marketplace/transactionList"
    case requestWithdrawal = "mobikulmphttp/marketplace/withdrawalRequest"
    case transactionDetails = "mobikulmphttp/marketplace/viewtransaction"
    case becomeSeller  = "mobikulmphttp/marketplace/becomeseller"
    case notifyAdmin = "mobikulmphttp/chat/notifyAdmin"
    case chatSellerList = "mobikulmphttp/chat/sellerList"
    case sellerOrderDetails = "mobikulmphttp/marketplace/vieworder"
    case sellerSendMail = "mobikulmphttp/marketplace/sendorderemail"
    case createSellerShipment = "mobikulmphttp/marketplace/createShipment"
    case createSellerInvoice = "mobikulmphttp/marketplace/createinvoice"
    case cancelSellerOrder = "mobikulmphttp/marketplace/cancelorder"
    case sellerInvoiceDetails = "mobikulmphttp/marketplace/viewinvoice"
    case sellerShipmentDetails = "mobikulmphttp/marketplace/viewshipment"
    case deleteTrackingInfo = "mobikulmphttp/marketplace/deleteTrackinginfo"
    case addtrackingInfo = "mobikulmphttp/marketplace/addtrackinginfo"
    case sendTrackingInfo = "mobikulmphttp/marketplace/sendTrackinginfo"
    case creditMemoFormData = "mobikulmphttp/marketplace/creditMemoFormData"
    case createCreditMemo = "mobikulmphttp/marketplace/createcreditmemo"
    case creditMemoList = "mobikulmphttp/marketplace/creditmemolist"
    case viewCreditMemo = "mobikulmphttp/marketplace/viewCreditMemo"
    case customerList = "mobikulmphttp/seller/CustomerList"//"mobikulb2b/supplier/CustomerList"
    case sellerCollection = "mobikulmphttp/marketplace/SellerCollection"
    case uploadPoroductFile = "mobikulmphttp/product/DownloadableFileUpload"
    case contactSeller = "mobikulmphttp/marketplace/contactSeller"
    case downloadTransactionList = "mobikulmphttp/marketplace/downloadTransactionList"
    case saveSellerReview = "mobikulmphttp/marketplace/saveReview"
    case shippingAreaList = "mobikulmphl/seller/shiparealist"
    case deleteShippingAreaList = "mobikulmphl/seller/deleteshiparea"
    case saveShippingArea =  "mobikulmphl/seller/saveshiparea"
    case sellerShippingOrigin = "mobikulmphl/seller/getSellerShippingOrigin";
    case savesellerShippingOrigin = "mobikulmphl/seller/savesellershippingorigin"
    case shippingRateList = "mobikulmphl/seller/shippingratelist";
    case uploadShippingrateFile = "mobikulmphl/seller/uploadshippingrate"
    case deleteShippingRateList = "mobikulmphl/seller/deleteshippingrate"
    #else
    #endif
}

/*{
  "canReorder" : true,
  "incrementId" : "000000081",
  "showCreateAccountLink" : true,
  "orderId" : "88",
  "message" : "",
  "email" : "tester@webkul.com",
  "success" : true,
  "customerDetails" : {
    "groupId" : 0,
    "guestCustomer" : 1,
    "email" : "tester@webkul.com",
    "lastname" : "jdjdjdj",
    "firstname" : "hdhdh"
  },
  "cartCount" : 1
}*/
