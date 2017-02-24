//
//  HttpClient.swift
//  OnTheMap
//
//  Created by Dylan Miller on 2/15/17.
//  Copyright © 2017 Dylan Miller. All rights reserved.
//

import Foundation

// Base class for classes using HTTP client functionality.
class HttpClient {
    
    // Shared session.
    let session = URLSession.shared
    
    // Execute an HTTP GET task for the specified method, passing the result to
    // the appropriate completion handler.
    func taskForGetMethod(_ method: String, parameters: [String:AnyObject]? = nil, success: @escaping (_ result: AnyObject) -> Void, failure: @escaping (_ error: Error) -> Void) -> URLSessionDataTask {
        
        return taskForHttpMethod(httpMethod: "GET", method: method, parameters: parameters, jsonBody: nil, success: success, failure: failure)
    }
    
    // Execute an HTTP POST task for the specified method, passing the result to
    // the appropriate completion handler.
    func taskForPostMethod(_ method: String, parameters: [String:AnyObject]? = nil, jsonBody: String, success: @escaping (_ result: AnyObject) -> Void, failure: @escaping (_ error: Error) -> Void) -> URLSessionDataTask {
        
        return taskForHttpMethod(httpMethod: "POST", method: method, parameters: parameters, jsonBody: jsonBody, success: success, failure: failure)
    }
    
    // Execute an HTTP PUT task for the specified method, passing the result to
    // the appropriate completion handler.
    func taskForPutMethod(_ method: String, parameters: [String:AnyObject]? = nil, jsonBody: String, success: @escaping (_ result: AnyObject) -> Void, failure: @escaping (_ error: Error) -> Void) -> URLSessionDataTask {
        
        return taskForHttpMethod(httpMethod: "PUT", method: method, parameters: parameters, jsonBody: jsonBody, success: success, failure: failure)
    }
    
    // Execute an HTTP DELETE task for the specified method, passing the result to
    // the appropriate completion handler.
    func taskForDeleteMethod(_ method: String, parameters: [String:AnyObject]? = nil, success: @escaping (_ result: AnyObject) -> Void, failure: @escaping (_ error: Error) -> Void) -> URLSessionDataTask {
        
        return taskForHttpMethod(httpMethod: "DELETE", method: method, parameters: parameters, jsonBody: nil, success: success, failure: failure)
    }
    
    // Execute an HTTP GET/POST/PUT task for the specified method, passing the
    // result to the appropriate completion handler.
    func taskForHttpMethod(httpMethod: String, method: String, parameters: [String:AnyObject]? = nil, jsonBody: String?, success: @escaping (_ result: AnyObject) -> Void, failure: @escaping (_ error: Error) -> Void) -> URLSessionDataTask {
        
        // Create the URL and the request.
        let request = NSMutableURLRequest(url: getUrl(withPathExtension: method, parameters: parameters))
        if httpMethod != "GET" {
            
            request.httpMethod = httpMethod
        }
        addHeadersToRequest(httpMethod: httpMethod, request: request)
        if let jsonBody = jsonBody {
            
            request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        }
        
        // Make the request.
        let task = session.dataTask(with: request as URLRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            
            func sendError(_ errorString: String) {
                
                let userInfo = [NSLocalizedDescriptionKey : errorString]
                failure(NSError(domain: "taskForHttpMethod", code: 1, userInfo: userInfo))
            }
            
            // GUARD: Was there an error?
            guard (error == nil) else {
                
                sendError("There was an error with your request: \(error)")
                return
            }
            
            // GUARD: Did we get a successful 2XX response?
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            guard let code = statusCode, code >= 200 && code <= 299 else {
                
                if let statusCode = statusCode {
                    
                    sendError("\(statusCode): \(HTTPURLResponse.localizedString(forStatusCode: statusCode))")
                }
                else {
                    
                    sendError("Your request returned a status code other than 2xx!")
                }
                return
            }
            
            // GUARD: Was there any data returned?
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // Adjust the response data as appropriate.
            let newData = self.fixResponseData(data)
            //print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            
            // Parse the JSON data and pass the object to the completion handler.
            self.convertJsonToAnyObject(newData, success: success, failure: failure)
        }
        
        // Start the request.
        task.resume()
        
        return task
    }

    // Convert raw JSON to AnyObject, calling the appropriate completion handler.
    func convertJsonToAnyObject(_ data: Data, success: @escaping (_ result: AnyObject) -> Void, failure: @escaping (_ error: Error) -> Void) {
        
        var parsedObject: AnyObject! = nil
        do {
            
            parsedObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        }
        catch {
            
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON. \(error): '\(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)'"]
            failure(NSError(domain: "convertJsonToAnyObject", code: 1, userInfo: userInfo))
            return
        }
        
        success(parsedObject)
    }
    
    // Create an API URL using the specified path extension and parameters.
    func getUrl(withPathExtension: String? = nil, parameters: [String:AnyObject]? = nil) -> URL {
        
        fatalError("Must Override")
    }

    // Add appropriate HTTP headers to the specified request.
    func addHeadersToRequest(httpMethod: String, request: NSMutableURLRequest) {
        
        fatalError("Must Override")
    }
    
    // Adjust the response data as appropriate.
    func fixResponseData(_ data: Data) -> Data {
        
        return data
    }
}
