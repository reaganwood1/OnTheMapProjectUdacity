//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Reagan Wood on 5/16/16.
//  Copyright © 2016 RW Software. All rights reserved.
//

import Foundation

class UdacityClient: NSObject{

    // shared session
    var session = NSURLSession.sharedSession()
    
    // variables for interacting with the API
    var userFirstName: String? = nil
    var userLastname: String? = nil
    var sessionID: String? = nil
    
    func taskForPostMethod(method: String, jsonBody: [String:[String:AnyObject]],completionHandlerForPOST:(result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionTask {
    
        // create url
        let urlForPost = UdacityClient.Constants.coreUdacityURL + method
        let url = NSURL(string: urlForPost)!
        
        // create muteable request
        let request = NSMutableURLRequest(URL: url)
        
        // set method and values
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do { // try to create
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }
        catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not create jsonbody"]
            completionHandlerForPOST(result: nil, error: NSError(domain: "parseJSONData", code: 1, userInfo: userInfo))
        }
        
        // Make a request
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            // function for creating error messages
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPOST(result: nil, error: NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
            }
            
            // check for error
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            // check for successful status code
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            // get the data
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // get the data in the correct range
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            // parse the data
            self.parseJSONData(newData, completionHandler: completionHandlerForPOST)

        } // end closure
        
        // resume the task
        task.resume()
        
        return task
    }
    
    // get method for gettting info from the udacity server
    func taskForGETMethod (method: String, taskForGetHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionTask {
        
        // create the url
        let url = Constants.coreUdacityURL + method
        let nsurl = NSURL (string: url)
        
        // create request
        let request = NSURLRequest(URL: nsurl!)
        let mutableRequest = NSMutableURLRequest(URL: nsurl!)
       
        // create a session to parse the data
        let task = session.dataTaskWithRequest(mutableRequest) { data, response, error in
            
            // function for printing and setting error info
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                taskForGetHandler(result: nil, error: NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
            }
            
            // check for error
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            // check for successful status code
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            // set the data
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // get data in range and parse it
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            self.parseJSONData(newData, completionHandler: taskForGetHandler)
            
        } // end task
        
        task.resume()
        
        return task
    }
    
    // function parses JSON data
    func parseJSONData (data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        // Parse the JSON data and return through the completion handler
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            completionHandler(result: parsedResult, error: nil)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONData", code: 1, userInfo: userInfo))
        }
    }
  
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}