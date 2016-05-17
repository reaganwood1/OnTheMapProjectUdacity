//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Reagan Wood on 5/16/16.
//  Copyright © 2016 RW Software. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func createLoginSessionWithUdacity (username: String, password: String, completionHandler: (sessionCreated: Bool, error: String?) -> Void) {
        
        // create jsonBody info
        var jsonBody: [String: [String: AnyObject]]
        jsonBody = [ParameterKeys.Udacity: [ParameterKeys.UserName: username, ParameterKeys.Password: password]]
        
        // get post data
        taskForPostMethod(Methods.Session, jsonBody: jsonBody) { (result, error) in
            print (result)
            // user post data
            if (error == nil){
                if let sessionInfo = result[JSONResponseKeys.SessionKey] as? [String:AnyObject] {
                    if let sessionid = sessionInfo[JSONResponseKeys.SessionID] as? String{
                        completionHandler(sessionCreated: true, error: nil)
                        self.sessionID = sessionid
                    } else {
                        completionHandler(sessionCreated: false, error: "sessionKey not found")
                    }
                }else{
                    completionHandler(sessionCreated: false, error: "session info not retrieved")
                }
            } else {
                completionHandler(sessionCreated: false, error: "The session was not created")
            }
        } // end taskForPostMethod
    } // end createLoginSessionWithUdacity
}