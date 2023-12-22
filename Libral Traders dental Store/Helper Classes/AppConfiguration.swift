import UIKit

//test site credential
//var baseDomain = "https://dev.libraltraders.com/"
//var hostName = baseDomain//+"/index.php/"
//var apiUserName  = "mobikul"
//var apiKey = "97wKSntaT80w"


//live credential
var baseDomain = "https://www.libraltraders.com/"
var hostName = baseDomain//+"/index.php/"
var apiUserName  = "mobikul"
var apiKey = "97wKSntaT80w"

var API_AUTH_TYPE = "sha256"

var applicationName: String {
    get {
        
        return "applicationname".localized
      
    }
}

var applicationNameSmall: String {
    get {
       
        return "applicationname".localized
        
    }
}

var socialLoginApplicationName: String {
    get {
        
        return "applicationname".localized
        
    }
}

var homeDataFileName: String {
    get {
        
        return "HomeJsonData".localized
       
    }
}
