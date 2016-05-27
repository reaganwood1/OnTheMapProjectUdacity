//
//  StudentData.swift
//  OnTheMap
//
//  Created by Reagan Wood on 5/26/16.
//  Copyright © 2016 RW Software. All rights reserved.
//

import Foundation

// This class is a model that stores student data to be used throughout the program
class StudentData {
    
    // stores the student objects
    var udacityStudentInformation: [PARSEStudentInformation] = [PARSEStudentInformation]()
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> StudentData {
        struct Singleton {
            static var sharedInstance = StudentData()
        }
        return Singleton.sharedInstance
    }
}
