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
}