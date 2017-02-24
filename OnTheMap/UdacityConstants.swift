//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Dylan Miller on 1/22/17.
//  Copyright © 2017 Dylan Miller. All rights reserved.
//

extension UdacityClient {
    
    // MARK: Constants
    struct Constants {
        
        // Mark: Sign Up
        static let signUpUrl = "https://www.udacity.com/account/auth#!/signup"
        
        // MARK: URLs
        static let apiScheme = "https"
        static let apiHost = "www.udacity.com"
        static let apiPath = "/api"
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: Session
        static let session = "/session"
        
        // MARK: User Data
        static let users = "/users"
    }
    
    // MARK: Headers
    struct Headers {
        
        static let accept = "Accept"
        static let contentType = "Content-Type"
        static let applicationJson = "application/json"
        static let xsrfToken = "X-XSRF-TOKEN"
    }
    
    // MARK: JSON Body Keys
    struct JsonBodyKeys {
        
        // MARK: Session
        static let udacity = "udacity"
        static let userName = "username"
        static let password = "password"
    }
    
    // MARK: JSON Response Keys
    struct JsonResponseKeys {
        
        // MARK: Session
        static let account = "account"
        static let key = "key"
        static let session = "session"
        static let id = "id"
        
        // MARK: User Data
        static let user = "user"
        static let firstName = "first_name"
        static let lastName = "last_name"
    }

    // MARK: Cookies
    struct Cookies {
        
        static let xsrfToken = "XSRF-TOKEN"
    }
}
