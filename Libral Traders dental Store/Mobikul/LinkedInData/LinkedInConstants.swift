//
//  LinkedInConstants.swift
//  LinkedInSocialLogin
//
//  Created by siddhant on 22/02/21.
//

import Foundation

struct LinkedInConstants {
    
    static let CLIENT_ID = "81d8qlzriblr64"
    static let CLIENT_SECRET = "szo7ZMuZ5Ec9pwcp"
    static let REDIRECT_URI = "http://52.18.4.133:8077/login/callback"
    static let SCOPE = "r_liteprofile%20r_emailaddress" //Get lite profile info and e-mail address
    
    static let AUTHURL = "https://www.linkedin.com/oauth/v2/authorization"
    static let TOKENURL = "https://www.linkedin.com/oauth/v2/accessToken"
}
