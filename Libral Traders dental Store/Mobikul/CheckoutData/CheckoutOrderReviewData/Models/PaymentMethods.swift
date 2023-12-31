//
//  PaymentMethods.swift
//
//  Created by bhavuk.chawla on 25/01/19
//  Copyright (c) . All rights reserved.
//

import Foundation

public struct PaymentMethods {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let extraInformation = "extraInformation"
        static let code = "code"
        static let title = "title"
        //webview payment
        static let webview = "webview"
        static let redirectUrl = "redirectUrl"
        static let successUrl = "successUrl"
        static let cancelUrl = "cancelUrl"
        static let failureUrl = "failureUrl"
    }
    
    // MARK: Properties
    public var extraInformation: String!
    public var code: String!
    public var title: String!
    public var webview: Bool = false
    public var redirectUrl: String?
    public var successUrl: [String]?
    public var cancelUrl: [String]?
    public var failureUrl: [String]?
    
    // MARK: SwiftyJSON Initializers
    /// Initiates the instance based on the object.
    ///
    /// - parameter object: The object of either Dictionary or Array kind that was passed.
    /// - returns: An initialized instance of the class.
    public init(object: Any) {
        self.init(json: JSON(object))
    }
    
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    public init(json: JSON) {
        extraInformation = json[SerializationKeys.extraInformation].stringValue
        code = json[SerializationKeys.code].stringValue
        title = json[SerializationKeys.title].stringValue
        
        webview = json[SerializationKeys.webview].boolValue
        redirectUrl = json[SerializationKeys.redirectUrl].stringValue
        if let items = json[SerializationKeys.successUrl].array { successUrl = items.map { $0.stringValue } }
        if let items = json[SerializationKeys.cancelUrl].array { cancelUrl = items.map { $0.stringValue } }
        if let items = json[SerializationKeys.failureUrl].array { failureUrl = items.map { $0.stringValue } }
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = extraInformation { dictionary[SerializationKeys.extraInformation] = value }
        if let value = code { dictionary[SerializationKeys.code] = value }
        if let value = title { dictionary[SerializationKeys.title] = value }
        return dictionary
    }
    
}
public struct RazorpayData {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let extraInformation = "extraInformation"
        static let code = "code"
        static let title = "title"
        //webview payment
        static let webview = "webview"
        static let redirectUrl = "redirectUrl"
        static let successUrl = "successUrl"
        static let cancelUrl = "cancelUrl"
        static let failureUrl = "failureUrl"
    }
    
    // MARK: Properties
    public var customer_phone_number: String?
    public var razorpay_order_id: String?
    public var razorpay_title: String?
    public var amount: String?
    public var razorpay_webhookSecret: String?
    public var customer_email: String?
    public var razorpay_enable: String?
    public var customer_lastname: String?
    public var razorpay_keyId: String?
    public var razorpay_webhook: String?
    public var razorpay_action: String?
    public var razorpay_merchantName: String?
    public var razorpay_KeySecret: String?
    public var customer_name: String?
   
    
    // MARK: SwiftyJSON Initializers
    /// Initiates the instance based on the object.
    ///
    /// - parameter object: The object of either Dictionary or Array kind that was passed.
    /// - returns: An initialized instance of the class.
    public init(object: Any) {
        self.init(json: JSON(object))
    }
    
    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    public init(json: JSON) {
        customer_phone_number = json["customer_phone_number"].stringValue
        razorpay_order_id = json["razorpay_order_id"].stringValue
        razorpay_title = json["razorpay_title"].stringValue
        amount = json["amount"].stringValue
        razorpay_webhookSecret = json["razorpay_webhookSecret"].stringValue
        customer_email = json["customer_email"].stringValue
        razorpay_enable = json["razorpay_enable"].stringValue
        customer_lastname = json["customer_lastname"].stringValue
        razorpay_keyId = json["razorpay_keyId"].stringValue
        razorpay_webhook = json["razorpay_webhook"].stringValue
        razorpay_action = json["razorpay_action"].stringValue
        razorpay_merchantName = json["razorpay_merchantName"].stringValue
        razorpay_KeySecret = json["razorpay_KeySecret"].stringValue
        customer_name = json["customer_name"].stringValue
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
//        if let value = extraInformation { dictionary[SerializationKeys.extraInformation] = value }
//        if let value = code { dictionary[SerializationKeys.code] = value }
//        if let value = title { dictionary[SerializationKeys.title] = value }
        return dictionary
    }
    
}
