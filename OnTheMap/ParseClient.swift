//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Dylan Miller on 1/9/17.
//  Copyright © 2017 Dylan Miller. All rights reserved.
//

import Foundation

// Manages communications with the Parse API.
class ParseClient: HttpClient {
    
    // Shared instance.
    static let shared = ParseClient()
    
    // Create a new student location.
    func addStudentLocation(studentLocation: StudentLocation, success: @escaping (_ objectId: String?) -> Void, failure: @escaping (_ error: Error) -> Void) {
        
        // Specify parameters, method, and HTTP body.
        let method = Methods.studentLocation
        let jsonBody = "{\"\(JsonBodyKeys.uniqueKey)\": \"\(studentLocation.uniqueKey)\", \"\(JsonBodyKeys.firstName)\": \"\(studentLocation.firstName)\", \"\(JsonBodyKeys.lastName)\": \"\(studentLocation.lastName)\",\"\(JsonBodyKeys.mapString)\": \"\(studentLocation.mapString)\", \"\(JsonBodyKeys.mediaUrl)\": \"\(studentLocation.mediaUrl)\",\"\(JsonBodyKeys.latitude)\": \(studentLocation.latitude), \"\(JsonBodyKeys.longitude)\": \(studentLocation.longitude)}"
        
        // Make the request.
        let paramSuccess = success
        let paramFailure = failure
        let _ = taskForPostMethod(
            method,
            jsonBody: jsonBody,
            success: { (result: AnyObject) in
                
                // Get the object ID.
                let objectId = result[JsonResponseKeys.objectId] as? String
                
                paramSuccess(objectId)
                
            },
            failure: { (error: Error) in
                
                paramFailure(error)
            })
    }
    
    // Update an existing student location.
    func updateStudentLocation(studentLocation: StudentLocation, success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
        
        // Specify parameters, method, and HTTP body.
        // Required Parameters:
        //      objectId - (String) the object ID of the StudentLocation to
        //      update; specify the object ID right after StudentLocation in URL.
        // Example: https://parse.udacity.com/parse/classes/StudentLocation/8ZExGR5uX8
        let method = Methods.studentLocation + "/\(studentLocation.objectId)"
        let jsonBody = "{\"\(JsonBodyKeys.uniqueKey)\": \"\(studentLocation.uniqueKey)\", \"\(JsonBodyKeys.firstName)\": \"\(studentLocation.firstName)\", \"\(JsonBodyKeys.lastName)\": \"\(studentLocation.lastName)\",\"\(JsonBodyKeys.mapString)\": \"\(studentLocation.mapString)\", \"\(JsonBodyKeys.mediaUrl)\": \"\(studentLocation.mediaUrl)\",\"\(JsonBodyKeys.latitude)\": \(studentLocation.latitude), \"\(JsonBodyKeys.longitude)\": \(studentLocation.longitude)}"
        
        // Make the request.
        let paramSuccess = success
        let paramFailure = failure
        let _ = taskForPutMethod(
            method,
            jsonBody: jsonBody,
            success: { (result: AnyObject) in
                
                paramSuccess()
                
            },
            failure: { (error: Error) in
                
                paramFailure(error)
            })
    }


    // Get multiple student locations.
    func getStudentLocations(limit: Int, success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
        
        // Specify parameters, method, and HTTP body.
        // Optional Parameters:
        //    limit - (Number) specifies the maximum number of StudentLocation
        //            objects to return in the JSON response.
        //            Example: https://parse.udacity.com/parse/classes/StudentLocation?limit=100
        //    skip - (Number) use this parameter with limit to paginate through
        //           results.
        //           Example: https://parse.udacity.com/parse/classes/StudentLocation?limit=200&skip=400
        //    order - (String) a comma-separate list of key names that specify
        //            the sorted order of the results. Prefixing a key name with
        //            a negative sign reverses the order (default order is
        //            ascending)
        //            Example: https://parse.udacity.com/parse/classes/StudentLocation?order=-updatedAt
        let method = Methods.studentLocation
        var parameters = [ParseClient.ParameterKeys.limit: "\(limit)"]
        parameters[ParseClient.ParameterKeys.order] = ParseClient.ParameterValues.updatedAt
        
        // Make the request.
        let paramSuccess = success
        let paramFailure = failure
        let _ = taskForGetMethod(
            method,
            parameters: parameters as [String:AnyObject],
            success: { (result: AnyObject) in
                
                // Get the student locations.
                if let results = result[JsonResponseKeys.results] as? [[String:AnyObject]] {
                    
                    StudentLocation.setStudentLocations(results: results)
                    paramSuccess()
                }
                else {

                    let userInfo = [NSLocalizedDescriptionKey : "Could not get student locations."]
                    paramFailure(NSError(domain: "getStudentLocations", code: 1, userInfo: userInfo))
                }
            },
            failure: { (error: Error) in
                
                paramFailure(error)
            })
    }
    
    // Get a single student location.
    func getStudentLocation(uniqueKey: String, success: @escaping (_ studentLocation: StudentLocation?) -> Void, failure: @escaping (_ error: Error) -> Void) {

        // Specify parameters, method, and HTTP body.
        // Required Parameters:
        //    where - (Parse Query) a SQL-like query allowing you to check if
        //    an object value matches some target value
        //    Example: https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%221234%22%7D
        //    The above URL is the escaped form of: https://parse.udacity.com/parse/classes/StudentLocation?where={"uniqueKey":"1234"}
        let method = Methods.studentLocation
        var parameters = [ParseClient.ParameterKeys._where: "{\"\(ParseClient.ParameterValues.uniqueKey)\":\"\(uniqueKey)\"}"]
        parameters[ParseClient.ParameterKeys.order] = ParseClient.ParameterValues.updatedAt
        
        // Make the request.
        let paramSuccess = success
        let paramFailure = failure
        let _ = taskForGetMethod(
            method,
            parameters: parameters as [String:AnyObject],
            success: { (result: AnyObject) in
                
                // Get the first student location.
                if let results = result[JsonResponseKeys.results] as? [[String:AnyObject]] {
                    
                    if let studentLocationDict = results.first {
                        
                        let studentLocation = StudentLocation(studentLocationDict: studentLocationDict)
                        paramSuccess(studentLocation)
                    }
                    else {
                        
                        paramSuccess(nil)
                    }
                }
                else {
                    
                    let userInfo = [NSLocalizedDescriptionKey : "Could not get student location."]
                    paramFailure(NSError(domain: "getStudentLocation", code: 1, userInfo: userInfo))
                }
            },
            failure: { (error: Error) in
                
                paramFailure(error)
            })
    }

    // Create a Parse API URL using the specified path extension and parameters.
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
        
        request.addValue(Constants.parseApplicationId, forHTTPHeaderField: Headers.parseApplicationId)
        request.addValue(Constants.restApiKey, forHTTPHeaderField: Headers.restApiKey)
        if httpMethod == "POST" || httpMethod == "PUT" {
            
            request.addValue(Headers.applicationJson, forHTTPHeaderField: Headers.contentType)
        }
    }
}
