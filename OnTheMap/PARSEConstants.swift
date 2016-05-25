//
//  PARSEConstants.swift
//  OnTheMap
//
//  Created by Reagan Wood on 5/18/16.
//  Copyright © 2016 RW Software. All rights reserved.
//

import Foundation

extension PARSEClient{

    struct Constants {
        static let PareseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ParseRestfulApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let coreParseURL = "https://api.parse.com/1/classes/"
        static let udacityURL = "https://udacity.com"
    }
    
    struct Methods {
        static let StudentLocations = "StudentLocation"
    }
    
    struct JSONResponseKeys {
        static let Results = "results"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let ObjectID = "objectId"
        static let UniqueKey = "uniqueKey"
    }
    
    
}