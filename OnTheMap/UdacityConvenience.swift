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
            // user post data
            if (error == nil){
                if let sessionInfo = result[JSONResponseKeys.Account] as? [String:AnyObject] {
                    if let sessionid = sessionInfo[JSONResponseKeys.Key] as? String{
                        self.sessionID = sessionid
                        completionHandler(sessionCreated: true, error: nil)
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
    
    // Gets the first and last name of the individual logging in
    func getFirstAndLastName (completionHandler: (nameRetrieved: Bool, error: String?) -> Void) {
        
        let methods = UdacityClient.Methods.Users + sessionID!
        
        taskForGETMethod(methods) { (result, error) in
            
            if (error == nil) {
                if let userInfo = result[JSONResponseKeys.User] as? [String:AnyObject] {
                    if let firstName = userInfo[JSONResponseKeys.FirstName] as? String? {
                        self.userFirstName = firstName // set the name data
                        if let lastName = userInfo[JSONResponseKeys.LastName] as? String? {
                            self.userLastname = lastName
                            completionHandler(nameRetrieved: true, error: nil)
                        } else {
                            self.userFirstName = nil
                            completionHandler(nameRetrieved: false, error: "first name retrived, but not the last name")
                        }
                    } else {
                        completionHandler(nameRetrieved: false, error: "There was an error retrieving the first name")
                    }
                } else {
                    completionHandler(nameRetrieved: false, error: "There was an error present parsing the name data")
                }
            } else {
                completionHandler(nameRetrieved: false, error: "There was an error present from getting the name data")
            } // end else
        }
    } // end function
    
    // function effectively logs out of Udacity
    func logoutOfUdacity (completionHandlerForLogout: (loggedOut: Bool?) -> Void) {
       
        // reset all defaults
        userLastname = nil
        userFirstName = nil
        sessionID = nil
        
    }
}