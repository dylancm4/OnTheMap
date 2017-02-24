//
//  User.swift
//  OnTheMap
//
//  Created by Dylan Miller on 2/23/17.
//  Copyright © 2017 Dylan Miller. All rights reserved.
//

import Foundation

// Contains settings for a user.
class User {
    
    // Shared instance.
    static var current: User?

    var userKey: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var studentLocationObjectId: String?
    
    // Create a User object based on the specified dictionary.
    init(userDict: [String:AnyObject]) {
        
        if let userKey = userDict[UdacityClient.JsonResponseKeys.key] as? String {
            
            self.userKey = userKey
        }
        if let firstName = userDict[UdacityClient.JsonResponseKeys.firstName] as? String {
            
            self.firstName = firstName
        }
        else {
            
            self.firstName = "[No First Name]"
        }
        if let lastName = userDict[UdacityClient.JsonResponseKeys.lastName] as? String {
            
            self.lastName = lastName
        }
        else {
            
            self.lastName = "[No Last Name]"
        }
    }
}
