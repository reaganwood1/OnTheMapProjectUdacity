//
//  PARSEStudentInformation.swift
//  OnTheMap
//
//  Created by Reagan Wood on 5/18/16.
//  Copyright © 2016 RW Software. All rights reserved.
//

import Foundation

struct PARSEStudentInformation {
    
    var firstName: String? = nil
    var lastName: String? = nil
    var latitude: Double? = nil
    var longitude: Double? = nil
    var mapString: String? = nil
    var mediaURL: String? = nil
    var objectID: String? = nil
    
    init(newInfo: [String:AnyObject]){
        firstName = newInfo[PARSEClient.JSONResponseKeys.FirstName] as! String
        lastName = newInfo[PARSEClient.JSONResponseKeys.LastName] as! String
        latitude = newInfo[PARSEClient.JSONResponseKeys.Latitude] as! Double
        longitude = newInfo[PARSEClient.JSONResponseKeys.Longitude] as! Double
        mapString = newInfo[PARSEClient.JSONResponseKeys.MapString] as! String
        mediaURL = newInfo[PARSEClient.JSONResponseKeys.MediaURL] as! String
        objectID = newInfo[PARSEClient.JSONResponseKeys.ObjectID] as! String
    }
}