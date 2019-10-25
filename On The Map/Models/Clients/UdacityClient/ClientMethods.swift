//
//  ApiRequestMethods.swift
//  On The Map
//
//  Created by Mohamed Shiha on 7/10/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation


extension UdacityClient {
    
    // Build a url based on components
    func buildUrl(parameters:[String:AnyObject]?, withPathExtension : String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Constsants.ApiScheme
        components.host = Constsants.ApiHost
        components.path = Constsants.ApiPath + (withPathExtension ?? "")
        
        if let params = parameters {
            
            components.queryItems = [URLQueryItem]()
            for (key, value) in params {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        return components.url!
    }
    
    
    // Mark: Request Methods
    
    typealias dataTaskCompletionHandler = (_ result: AnyObject?, _ error : NSError?) -> Void
    
    // Mark: Get Method
    func getRequestMethod(_ method: String, parameters : [String:AnyObject], completionHandlerForGET: @escaping dataTaskCompletionHandler ) -> URLSessionTask {
        
        let url = buildUrl(parameters: parameters, withPathExtension: method)
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("There was an error with your request: \(error)")
                return
            }
            
            completionHandlerForGET(data as AnyObject?, error as NSError?)
        }
        task.resume()
        
        return task
    }
    
    
    // Mark: Post Method
    func postRequestMethod(_ method: String, jsonBody: String, completionHandlerForPOST: @escaping dataTaskCompletionHandler) -> URLSessionTask {
        
        let url = buildUrl(parameters: nil, withPathExtension: method)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: .utf8)
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("There was an error with your request: \(error)")
                return
            }
            completionHandlerForPOST(data as AnyObject?, error as NSError?)
        }
        task.resume()
        
        return task
    }
    
    
    // Mark: Put Method
    func putRequestMethod(_ method: String, _ parameters:[String:AnyObject], jsonBody: String, completionHandlerForPUT: @escaping dataTaskCompletionHandler) -> URLSessionTask {
        
        let url = buildUrl(parameters: parameters, withPathExtension: method)
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: .utf8)
        
        let task = session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("There was an error with your request: \(error)")
                return
            }
            completionHandlerForPUT(data as AnyObject?, error as NSError?)
        }
        task.resume()
        
        return task
    }
    
    
    // Mark: Delete Method
    func deleteRequestMethod(_ method: String, completionHandlerForDELETE: @escaping dataTaskCompletionHandler) -> URLSessionTask {
        
        let url = buildUrl(parameters: nil, withPathExtension: method)
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            completionHandlerForDELETE(data as AnyObject?, error as NSError?)
        }
        task.resume()
        
        return task
    }
    
    
    
    // Mark: Helpers
    
    // substitute the key for the value that is contained within the method name
    private func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "<\(key)>") != nil {
            return method.replacingOccurrences(of: "<\(key)>}", with: value)
        } else {
            return nil
        }
    }
}
