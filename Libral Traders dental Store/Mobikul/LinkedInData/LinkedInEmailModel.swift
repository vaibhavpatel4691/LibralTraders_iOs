//
//  LinkedInEmailModel.swift
//  LinkedInSocialLogin
//
//  Created by siddhant on 22/02/21.
//

import Foundation

// MARK: - LinkedInEmailModel
struct LinkedInEmailModel: Codable {
    let elements: [Element]
}

// MARK: - Element
struct Element: Codable {
    let elementHandle: Handle
    let handle: String
    
    enum CodingKeys: String, CodingKey {
        case elementHandle = "handle~"
        case handle
    }
}

// MARK: - Handle
struct Handle: Codable {
    let emailAddress: String
}
