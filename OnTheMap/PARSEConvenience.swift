//
//  PARSEConvenience.swift
//  OnTheMap
//
//  Created by Reagan Wood on 5/18/16.
//  Copyright © 2016 RW Software. All rights reserved.
//

import Foundation

extension PARSEClient {

    func getStudentInfo(completionHandlerForStudentInfo: (retrieved: Bool, error: String?) -> Void) {
        
        let methods = Methods.StudentLocations
        
        taskForGETMethod(methods) { (result, error) in
            
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
    
    func getStudents(studentResults: [[String: AnyObject]]) -> [PARSEStudentInformation]{
        
        var udacityStudents = [PARSEStudentInformation]()
        
        for student in studentResults {
            udacityStudents.append(PARSEStudentInformation(newInfo: student))
        }
        
        return udacityStudents
    }
    
    func sendToParseServerStudentInfo(latitude: Double?, name: String?, locationString: String?, mediaURL: String?, longitude: Double?, completionHandlerPostSuccess: (success: Bool, error: String?) -> Void){
        
        let methods = Methods.StudentLocations
        
        var jsonBody: [String: AnyObject]
        jsonBody = [JSONResponseKeys.UniqueKey: UdacityClient.sharedInstance().sessionID!, JSONResponseKeys.FirstName: UdacityClient.sharedInstance().userFirstName!, JSONResponseKeys.LastName:UdacityClient.sharedInstance().userLastname!, JSONResponseKeys.MapString:  locationString!, JSONResponseKeys.MediaURL: mediaURL!, JSONResponseKeys.Latitude: latitude!, JSONResponseKeys.Longitude: longitude!]
    
        taskForPostMethod(methods, jsonBody: jsonBody) { (data, error) in
            if (error == nil){
                print("success")
            }else {
                completionHandlerPostSuccess(success: false, error: "error")
            }
        }
        
    } // end function
    
    func sendToParseServerUpdatedStudentInfo(latitude: Double?, name: String?, locationString: String?, mediaURL: String?, longitude: Double?, completionHandlerPostSuccess: (success: Bool, error: String?) -> Void){
        
        let methods = Methods.StudentLocations + "/" + objectID!
        print(methods)
        var jsonBody: [String: AnyObject]
        jsonBody = [JSONResponseKeys.UniqueKey: UdacityClient.sharedInstance().sessionID!, JSONResponseKeys.FirstName: UdacityClient.sharedInstance().userFirstName!, JSONResponseKeys.LastName:UdacityClient.sharedInstance().userLastname!, JSONResponseKeys.MapString:  locationString!, JSONResponseKeys.MediaURL: mediaURL!, JSONResponseKeys.Latitude: latitude!, JSONResponseKeys.Longitude: longitude!]
        
        taskForPutMethod(methods, jsonBody: jsonBody) { (data, error) in
            if (error == nil){
                completionHandlerPostSuccess(success: true, error: nil)
            }else {
                completionHandlerPostSuccess(success: false, error: "error")
            }
        }
        
    }
} // end class