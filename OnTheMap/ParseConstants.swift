//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Dylan Miller on 2/16/17.
//  Copyright © 2017 Dylan Miller. All rights reserved.
//

extension ParseClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: API Key
        static let parseApplicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let restApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: URLs
        static let apiScheme = "https"
        static let apiHost = "parse.udacity.com"
        static let apiPath = "/parse/classes"
    }

    // MARK: Methods
    struct Methods {
        
        // MARK: Student Location
        static let studentLocation = "/StudentLocation"
    }

    // MARK: Parameter Keys
    struct ParameterKeys {
        
        // MARK: Student Location
        static let limit = "limit"
        static let order = "order"
        static let _where = "where"
    }
    
    // MARK: Parameter Values
    struct ParameterValues {
        
        // MARK: Student Location
        static let updatedAt = "-updatedAt"
        static let uniqueKey = "uniqueKey"
    }
    
    // MARK: Headers
    struct Headers {
        
        static let parseApplicationId = "X-Parse-Application-Id"
        static let restApiKey = "X-Parse-REST-API-Key"
        static let contentType = "Content-Type"
        static let applicationJson = "application/json"
    }
    
    // MARK: JSON Body Keys
    struct JsonBodyKeys {
        
        // MARK: Student Location
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mapString = "mapString"
        static let mediaUrl = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
    }
    
    // MARK: JSON Response Keys
    struct JsonResponseKeys {
        
        // MARK: StudentLocation
        static let objectId = "objectId"
        static let results = "results"
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mapString = "mapString"
        static let mediaUrl = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let createdAt = "createdAt"
        static let updatedAt = "updatedAt"
    }
}
