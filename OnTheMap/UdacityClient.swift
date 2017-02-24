//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Dylan Miller on 1/10/17.
//  Copyright © 2017 Dylan Miller. All rights reserved.
//

import Foundation

// Manages communications with the Udacity API.
class UdacityClient: HttpClient {
    
    // Shared instance.
    static let shared = UdacityClient()

    var sessionId: String?
    var userKey: String?

    // Create the Udacity session using the specified user name and password.
    func createSession(userName: String, password: String, success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
        
        // Specify parameters, method, and HTTP body.
        // Required Parameters:
        //    udacity - (Dictionary) a dictionary containing a username/password
        //              pair used for authentication.
        //    username - (String) the username (email) for a Udacity student.
        //    password - (String) the password for a Udacity student.
        let method = Methods.session
        let jsonBody = "{\"\(JsonBodyKeys.udacity)\": {\"\(JsonBodyKeys.userName)\": \"\(userName)\", \"\(JsonBodyKeys.password)\": \"\(password)\"}}"
                
        // Make the request.
        let paramSuccess = success
        let paramFailure = failure
        let _ = taskForPostMethod(
            method,
            jsonBody: jsonBody,
            success: { (result: AnyObject) in
                
                // Save the user ID.
                let accountDict = result[JsonResponseKeys.account] as AnyObject
                self.userKey = accountDict[JsonResponseKeys.key] as? String
                
                // Save the Udacity session ID.
                let sessionDict = result[JsonResponseKeys.session] as AnyObject
                self.sessionId = sessionDict[JsonResponseKeys.id] as? String
                
                paramSuccess()
            },
            failure: { (error: Error) in
                
                paramFailure(error)            
            })
    }

    // Delete the Udacity session.
    func deleteSession(success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
        
        // Specify parameters, method, and HTTP body.
        let method = Methods.session
        
        // Make the request.
        let paramSuccess = success
        let paramFailure = failure
        let _ = taskForDeleteMethod(
            method,
            success: { (result: AnyObject) in
                
                paramSuccess()
            },
            failure: { (error: Error) in
                
                paramFailure(error)
            })
    }
    
    // Get basic user information for the logged in user.
    func getUserData(success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
        
        if let userKey = userKey {
            
            // Specify parameters, method, and HTTP body.
            let method = Methods.users + "/\(userKey)"
            
            // Make the request.
            let paramSuccess = success
            let paramFailure = failure
            let _ = taskForGetMethod(
                method,
                success: { (result: AnyObject) in
                    
                    // Get the user.
                    if let userDict = result[JsonResponseKeys.user] as? [String:AnyObject] {
                        
                        User.current = User(userDict: userDict)
                        paramSuccess()
                    }
                    else {
                        
                        let userInfo = [NSLocalizedDescriptionKey : "Could not get user data."]
                        paramFailure(NSError(domain: "getUserData", code: 1, userInfo: userInfo))
                    }
                },
                failure: { (error: Error) in
                    
                    paramFailure(error)
                })
        }
    }

    // Create a Udacity API URL using the specified path extension and parameters.
    override func getUrl(withPathExtension: String? = nil, parameters: [String:AnyObject]? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.apiScheme
        components.host = Constants.apiHost
        components.path = Constants.apiPath + (withPathExtension ?? "")
        if let parameters = parameters {
            
            components.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        return components.url!
    }
    
    // Add appropriate HTTP headers to the specified request.
    override func addHeadersToRequest(httpMethod: String, request: NSMutableURLRequest) {
        
        if httpMethod == "POST" {
            
            request.addValue(Headers.applicationJson, forHTTPHeaderField: Headers.accept)
            request.addValue(Headers.applicationJson, forHTTPHeaderField: Headers.contentType)
        }
        else if httpMethod == "DELETE" {
            
            for cookie in HTTPCookieStorage.shared.cookies! {
                
                if cookie.name == Cookies.xsrfToken {
                    
                    request.addValue(cookie.value, forHTTPHeaderField: Headers.xsrfToken)
                    break
                }
            }
        }
    }
    
    // Adjust the response data as appropriate.
    override func fixResponseData(_ data: Data) -> Data {
        
        // For all responses from the Udacity API, skip the first 5 chars of
        // the response, which are used for security purposes.
        let range = Range(uncheckedBounds: (5, data.count))
        let newData = data.subdata(in: range)
        return newData
    }
}
