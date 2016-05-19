//
//  PARSEClient.swift
//  OnTheMap
//
//  Created by Reagan Wood on 5/18/16.
//  Copyright © 2016 RW Software. All rights reserved.
//

import Foundation

class PARSEClient: NSObject {
    
    var session = NSURLSession.sharedSession()
    var udacityStudentInformation: [PARSEStudentInformation] = [PARSEStudentInformation]()
    
    // gets information from the PARSE server
    func taskForGETMethod (method: String?, completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionTask{
        
        let url = Constants.coreParseURL + method!
        let mutableRequest = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        mutableRequest.addValue(Constants.PareseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        mutableRequest.addValue(Constants.ParseRestfulApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = session.dataTaskWithRequest(mutableRequest) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGET(result: nil, error: NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
        
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            self.parseJSONData(data, completionHandler: completionHandlerForGET)
        } // end task closure
        
        // resume the task
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
    
    class func sharedInstance() -> PARSEClient {
        struct Singleton {
            static var sharedInstance = PARSEClient()
        }
        return Singleton.sharedInstance
    }
} // end PARSEClient class
