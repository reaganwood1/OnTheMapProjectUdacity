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
    
    // stores the student objects
    var udacityStudentInformation: [PARSEStudentInformation] = [PARSEStudentInformation]()
    
    // stores the object for the student if it is found in the PARSE database
    var objectID: String? = nil
    
    // gets information from the PARSE server
    func taskForGETMethod (method: String?, completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionTask{
        
        let url = Constants.coreParseURL + method!
        let mutableRequest = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        mutableRequest.addValue(Constants.PareseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        mutableRequest.addValue(Constants.ParseRestfulApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = session.dataTaskWithRequest(mutableRequest) { (data, response, error) in
            
            // functoin for displaying error
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGET(result: nil, error: NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
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
            
            // parse the data
            self.parseJSONData(data, completionHandler: completionHandlerForGET)
        } // end task closure
        
        // resume the task
        task.resume()
        
        // return the closure
        return task
    }
    
    // posts data to the PARSE server
    func taskForPostMethod (method: String?, jsonBody: [String:AnyObject!], completionHandlerForPost: (data: AnyObject!, error: NSError?) -> Void) -> NSURLSessionTask{
        
        // create the url
        let urlForPost = Constants.coreParseURL + method!
        let url = NSURL(string: urlForPost)!
        
        // create a mutable request
        let request = NSMutableURLRequest(URL: url)
        
        // create method and values for the request
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }
        catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not serialize the jsonBody data"]
            completionHandlerForPost(data: nil, error: NSError(domain: "parseJSONData", code: 1, userInfo: userInfo))
        }
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            // function for displaying error message
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPost(data: nil, error: NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
            }
            
            // check for error
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            // check for successful response status code
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            // check for good data
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }

            // parse the data
            self.parseJSONData(data, completionHandler: completionHandlerForPost)
        }
        
        // resume the task
        task.resume()
        
        // return the closure with data
        return task
    }
    
    // Updates data in the PARSE database
    func taskForPutMethod (method: String?, jsonBody: [String:AnyObject!], completionHandlerForPut: (data: AnyObject!, error: NSError?) -> Void) -> NSURLSessionTask{
        
        
        // create the url
        let urlForPost = Constants.coreParseURL + method!
        let url = NSURL(string: urlForPost)!
        
        // create the mutable request
        let request = NSMutableURLRequest(URL: url)
        
        // create method and values for the request
        request.HTTPMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // try to serialize the json body
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }
        catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not serialize the jsonBody data"]
            completionHandlerForPut(data: nil, error: NSError(domain: "parseJSONData", code: 1, userInfo: userInfo))
        }

        // create task to retrieve the data from the PARSE server
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            // function for displaying error info
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPut(data: nil, error: NSError(domain: "taskForPutMethod", code: 1, userInfo: userInfo))
            }
            
            // check for erro
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            // check for correct status code for task
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            // check for good data
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // parse the data
            self.parseJSONData(data, completionHandler: completionHandlerForPut)
    
        }
        
        // resume task
        task.resume()
        
        // return the closure
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
