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
    
        /* 1 Set the parameters */
        let urlForPost = UdacityClient.Constants.coreUdacityURL + method
        let url = NSURL(string: urlForPost)!
        
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }
        catch {
            print ("json error: \(error)")
        }
        
        // Make a request
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPOST(result: nil, error: NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
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
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            self.parseJSONData(newData, completionHandler: completionHandlerForPOST)

        } // end closure
        
        // resume the task
        task.resume()
        
        return task
    }
    
    // get method for gettting info from the udacity server
    func taskForGETMethod (method: String, taskForGetHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionTask {
        
        let url = Constants.coreUdacityURL + method
        let nsurl = NSURL (string: url)
        
        let request = NSURLRequest(URL: nsurl!)
        let mutableRequest = NSMutableURLRequest(URL: nsurl!)
        
        print (url)
        let task = session.dataTaskWithRequest(mutableRequest) { data, response, error in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                taskForGetHandler(result: nil, error: NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
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
    // create a URL from parameters
    private func udacityURLFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = UdacityClient.Constants.ApiHost
        //components.path = UdacityClient.Constants.ApiPath + (withPathExtension ?? "")
        components.path = withPathExtension ?? ""
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}