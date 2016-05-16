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
    }
    
    struct Methods {
        static let Session = "session"
        static let User = "users/<user_id>"
    } // end method
    
} // end extension