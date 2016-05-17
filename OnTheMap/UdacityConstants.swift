//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Reagan Wood on 5/16/16.
//  Copyright © 2016 RW Software. All rights reserved.
//

import Foundation

extension UdacityClient {

    struct Constants {
        static let coreUdacityURL = "https://www.udacity.com/api/"
        static let coreUdacitySignUpURL = "https://www.udacity.com/account/auth#!/signup"
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com/api"
        
    }
    
    struct Methods {
        static let Session = "session"
        //static let User = "users/<user_id>"
    } // end method
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let ApiKey = "api_key"
        static let SessionID = "session_id"
        static let RequestToken = "request_token"
        static let Query = "query"
        static let UserName = "username"
        static let Udacity = "udacity"
        static let Password = "password"
    }
    
    struct JSONResponseKeys {
        static let Account = "account"
        static let Key = "key"
        static let SessionKey = "session"
        static let SessionID = "id"
    }
} // end extension