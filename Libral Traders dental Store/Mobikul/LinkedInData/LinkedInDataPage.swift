//
//  LinkedInDataPage.swift
//  LinkedInSocialLogin
//
//  Created by siddhant on 22/02/21.
//

import Foundation

class LinkedInDataPage {
    
    var callBack: ([String: Any]) -> Void
    fileprivate var loginDict = [String: Any]()
    
    init(callBack: @escaping (([String: Any]) -> Void)) {
        self.callBack = callBack
    }
    
    func RequestForCallbackURL(request: URLRequest) {
        // Get the authorization code string after the '?code=' and before '&state='
        let requestURLString = (request.url?.absoluteString)! as String
        
        if requestURLString.hasPrefix(LinkedInConstants.REDIRECT_URI) {
            if requestURLString.contains("?code=") {
                if let range = requestURLString.range(of: "=") {
                    let linkedinCode = requestURLString[range.upperBound...]
                    if let range = linkedinCode.range(of: "&state=") {
                        let linkedinCodeFinal = linkedinCode[..<range.lowerBound]
                        handleAuth(linkedInAuthorizationCode: String(linkedinCodeFinal))
                    }
                }
            }
        }
    }
    
    func handleAuth(linkedInAuthorizationCode: String) {
        linkedinRequestForAccessToken(authCode: linkedInAuthorizationCode)
    }
    
    func linkedinRequestForAccessToken(authCode: String) {
        let grantType = "authorization_code"
        
        // Set the POST parameters.
        let postParams = "grant_type=" + grantType + "&code=" + authCode + "&redirect_uri=" + LinkedInConstants.REDIRECT_URI + "&client_id=" + LinkedInConstants.CLIENT_ID + "&client_secret=" + LinkedInConstants.CLIENT_SECRET
        let postData = postParams.data(using: String.Encoding.utf8)
        let request = NSMutableURLRequest(url: URL(string: LinkedInConstants.TOKENURL)!)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode == 200 {
                let results = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [AnyHashable: Any]
                
                let accessToken = results?["access_token"] as! String
                print("accessToken is: \(accessToken)")
                
                let expiresIn = results?["expires_in"] as! Int
                print("expires in: \(expiresIn)")
                
                // Get user's id, first name, last name, profile pic url
                self.fetchLinkedInUserProfile(accessToken: accessToken)
            }
        }
        task.resume()
    }
    
    func fetchLinkedInUserProfile(accessToken: String) {
        let tokenURLFull = "https://api.linkedin.com/v2/me?projection=(id,firstName,lastName,profilePicture(displayImage~:playableStreams))&oauth2_access_token=\(accessToken)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let verify: NSURL = NSURL(string: tokenURLFull!)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error == nil {
                let linkedInProfileModel = try? JSONDecoder().decode(LinkedInProfileModel.self, from: data!)
                
                //AccessToken
                print("LinkedIn Access Token: \(accessToken)")
                
                // LinkedIn Id
                let linkedinId: String! = linkedInProfileModel?.id
                print("LinkedIn Id: \(linkedinId ?? "")")
                self.loginDict["authUserId"] = linkedinId
                self.loginDict["authProvider"] = "LINKEDIN"
                self.loginDict["isSocialLogin"] = true
                
                // LinkedIn First Name
                let linkedinFirstName: String! = linkedInProfileModel?.firstName.localized.enUS
                print("LinkedIn First Name: \(linkedinFirstName ?? "")")
                self.loginDict["name"] = linkedinFirstName
                
                // LinkedIn Last Name
                let linkedinLastName: String! = linkedInProfileModel?.lastName.localized.enUS
                print("LinkedIn Last Name: \(linkedinLastName ?? "")")
                self.loginDict["lastname"] = linkedinLastName
                // LinkedIn Profile Picture URL
                let linkedinProfilePic: String!

                /*
                 Change row of the 'elements' array to get diffrent size of the profile url
                 elements[0] = 100x100
                 elements[1] = 200x200
                 elements[2] = 400x400
                 elements[3] = 800x800
                 */
                if let pictureUrls = linkedInProfileModel?.profilePicture.displayImage.elements[2].identifiers[0].identifier {
                    linkedinProfilePic = pictureUrls
                } else {
                    linkedinProfilePic = "Not exists"
                }
                print("LinkedIn Profile Avatar URL: \(linkedinProfilePic ?? "")")
                self.loginDict["pictureURL"] = linkedinProfilePic
                // Get user's email address
                self.fetchLinkedInEmailAddress(accessToken: accessToken)
            }
        }
        task.resume()
    }
    
    func fetchLinkedInEmailAddress(accessToken: String) {
        let tokenURLFull = "https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))&oauth2_access_token=\(accessToken)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let verify: NSURL = NSURL(string: tokenURLFull!)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error == nil {
                let linkedInEmailModel = try? JSONDecoder().decode(LinkedInEmailModel.self, from: data!)
                
                // LinkedIn Email
                let linkedinEmail: String! = linkedInEmailModel?.elements[0].elementHandle.emailAddress
                print("LinkedIn Email: \(linkedinEmail ?? "")")
                self.loginDict["email"] = linkedinEmail
                
                self.callBack(self.loginDict)
            }
        }
        task.resume()
    }
}
