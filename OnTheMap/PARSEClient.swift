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
    var objectID: String? = nil
    
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
    
    func taskForPostMethod (method: String?, jsonBody: [String:AnyObject!], completionHandlerForPost: (data: AnyObject!, error: NSError?) -> Void) -> NSURLSessionTask{
        
        
        /* 1 Set the parameters */
        let urlForPost = Constants.coreParseURL + method!
        print (urlForPost)
        let url = NSURL(string: urlForPost)!
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print("\(jsonBody)")
//        request.HTTPBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".dataUsingEncoding(NSUTF8StringEncoding)
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }
        catch {
            print ("json error: \(error)")
        }
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPost(data: nil, error: NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
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

            //println(NSString(data: data, encoding: NSUTF8StringEncoding))
        }
        task.resume()
        
        return task
    }
    
    func taskForPutMethod (method: String?, jsonBody: [String:AnyObject!], completionHandlerForPut: (data: AnyObject!, error: NSError?) -> Void) -> NSURLSessionTask{
        
        
        /* 1 Set the parameters */
        let urlForPost = Constants.coreParseURL + method!
        print (urlForPost)
        let url = NSURL(string: urlForPost)!
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print("\(jsonBody)")
//                request.HTTPBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".dataUsingEncoding(NSUTF8StringEncoding)
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }
        catch {
            print ("json error: \(error)")
        }
//        request.HTTPBody = "{\"uniqueKey\": \"\(UdacityClient.sharedInstance().sessionID)\", \"firstName\": \"Reagan\", \"lastName\": \"Wood\",\"mapString\": \"Oklahoma\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 35.7324119, \"longitude\": -97.3867978}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPut(data: nil, error: NSError(domain: "taskForPutMethod", code: 1, userInfo: userInfo))
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
            
            self.parseJSONData(data, completionHandler: completionHandlerForPut)
            //println(NSString(data: data, encoding: NSUTF8StringEncoding))
        }
        task.resume()
        
        return task
    }
    
    // function parses JSON data
    func parseJSONData (data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        // Parse the JSON data and return through the completion handler
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            print (parsedResult)
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
