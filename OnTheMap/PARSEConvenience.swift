//
//  PARSEConvenience.swift
//  OnTheMap
//
//  Created by Reagan Wood on 5/18/16.
//  Copyright © 2016 RW Software. All rights reserved.
//

import Foundation

// this extension is contains convenience methods for interacting with the PARSE database
extension PARSEClient {

    // function retrieves student information from the PARSE database
    func getStudentInfo(completionHandlerForStudentInfo: (retrieved: Bool, error: String?) -> Void) {
        
        // set the methods
        let methods = Methods.StudentLocations + "?order=-updatedAt"
        
        // get the data
        taskForGETMethod(methods) { (result, error) in
            
            // if no error, get the student objects and assign them to the client variable
            if (error == nil){
                if let studentDictionaries = result[JSONResponseKeys.Results] as? [[String:AnyObject]]{
                    self.udacityStudentInformation = self.getStudents(studentDictionaries)
                    completionHandlerForStudentInfo(retrieved: true, error: nil)
                } else {
                    completionHandlerForStudentInfo(retrieved: false, error: "data not parsed correctly")
                }
            } else {
                completionHandlerForStudentInfo(retrieved: false, error: "The result was not retrieved")
            }
        }
    }
    
    // get each student and append it to the studnet object array
    func getStudents(studentResults: [[String: AnyObject]]) -> [PARSEStudentInformation]{
        
        var udacityStudents = [PARSEStudentInformation]()
        
        for student in studentResults {
            udacityStudents.append(PARSEStudentInformation(newInfo: student))
        }
        
        return udacityStudents
    }
    
    // create a student object in the PARSE server
    func sendToParseServerStudentInfo(latitude: Double?, name: String?, locationString: String?, mediaURL: String?, longitude: Double?, completionHandlerPostSuccess: (success: Bool, error: String?) -> Void){
        
        // set the methods
        let methods = Methods.StudentLocations
        
        // set the jsonBody
        var jsonBody: [String: AnyObject]
        jsonBody = [JSONResponseKeys.UniqueKey: UdacityClient.sharedInstance().sessionID!, JSONResponseKeys.FirstName: UdacityClient.sharedInstance().userFirstName!, JSONResponseKeys.LastName:UdacityClient.sharedInstance().userLastname!, JSONResponseKeys.MapString:  locationString!, JSONResponseKeys.MediaURL: mediaURL!, JSONResponseKeys.Latitude: latitude!, JSONResponseKeys.Longitude: longitude!]
    
        // post to the PARSE server
        taskForPostMethod(methods, jsonBody: jsonBody) { (data, error) in
            if (error == nil){
                completionHandlerPostSuccess(success: true, error: nil)
            }else {
                completionHandlerPostSuccess(success: false, error: "data could not be retrieved")
            }
        }
        
    } // end function
    
    // Update PARSE info
    func sendToParseServerUpdatedStudentInfo(latitude: Double?, name: String?, locationString: String?, mediaURL: String?, longitude: Double?, completionHandlerPostSuccess: (success: Bool, error: String?) -> Void){
        
        // set the methods
        let methods = Methods.StudentLocations + "/" + objectID!
        
        // set the jsonBody
        var jsonBody: [String: AnyObject]
        jsonBody = [JSONResponseKeys.UniqueKey: UdacityClient.sharedInstance().sessionID!, JSONResponseKeys.FirstName: UdacityClient.sharedInstance().userFirstName!, JSONResponseKeys.LastName:UdacityClient.sharedInstance().userLastname!, JSONResponseKeys.MapString:  locationString!, JSONResponseKeys.MediaURL: mediaURL!, JSONResponseKeys.Latitude: latitude!, JSONResponseKeys.Longitude: longitude!]
        
        taskForPutMethod(methods, jsonBody: jsonBody) { (data, error) in
            if (error == nil){
                completionHandlerPostSuccess(success: true, error: nil)
            }else {
                completionHandlerPostSuccess(success: false, error: "Could not update PARSE server")
            }
        }
        
    }
} // end class