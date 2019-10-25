//
//  AudacityClient.swift
//  On The Map
//
//  Created by Mohamed Shiha on 7/8/19.
//  Copyright © 2019 Mohamed Shiha. All rights reserved.
//

import Foundation

class UdacityClient {
    
    
    let session = URLSession.shared
    
    var objectID : String? = nil
    var sessionID : String? = nil
    var userID : String? = nil
    
     func authenticateUser(username : String, password: String, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
         
         getSessionID(username: username, password: password) { (success, sessionID, error) in }
        
         getUserID(username: username, password: password) { (success, userID, error) in
            completionHandlerForAuth(success, "Server couldn't authenticate the user due to unknown error")
         }
     }
    
    
    // Mark: Create a session
    
    private func createSession(username: String, password: String, completionHandler : @escaping( _ data: [String:AnyObject]?, _ errorMessage: String?) -> Void) {
        
        var sessionData : [String:AnyObject]! = nil
        let httpbody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        
        let _ = postRequestMethod(Methods.Session, jsonBody: httpbody) { (result, error) in
            if error != nil {
                completionHandler(nil, "No data was returned")
                return
            } else {
                
                if let result = result {

                    let parsedData = result as? Data
                    let range = 5 ..< (parsedData?.count)!
                    let subData = parsedData?.subdata(in: range)
                    
                    do {
                        sessionData = try JSONSerialization.jsonObject(with: subData!, options: []) as? [String:AnyObject]
                        } catch {
                        completionHandler(nil, "Coudn't parse data")
                        return
                    }
                    completionHandler(sessionData, nil)
                }
            }
        }
    }
    
    
    // Mark: Get session ID
    
    private func getSessionID(username: String, password: String ,completionHandler: @escaping (_ success: Bool, _ sessionID: String?, _ errorMeesange : String?) -> Void) {
        
        createSession(username: username, password: password) { (sessionData, error) in
            
            if let session = sessionData?[JsonResponseKeys.Session] as? [String:AnyObject]{
                if let sessionID = session[JsonResponseKeys.SessionID] as? String {
                    UdacityClient.sharedInstance().sessionID = sessionID
                    completionHandler(true, sessionID, nil)
                } else {
                    completionHandler(false, nil, "Couldn't find key \(JsonResponseKeys.SessionID)")
                }
            } else {
                completionHandler(false, nil, "Couldn't find key \(JsonResponseKeys.Session)")
                return
            }
        }
    }
    
    
    // Mark : Get user ID
    
    private func getUserID(username: String, password: String ,completionHandler: @escaping (_ success: Bool, _ sessionID: String?, _ errorMeesange : String?) -> Void) {

        createSession(username: username, password: password) { (sessionData, error) in

            if let account = sessionData?[JsonResponseKeys.Account] as? [String:AnyObject] {

                if let accountKey = account[JsonResponseKeys.AccountKey] as? String {
                    UdacityClient.sharedInstance().userID = accountKey
                    completionHandler(true, accountKey, nil)
                } else {
                    completionHandler(false, nil, "Couldn't find key \(JsonResponseKeys.AccountKey)")
                }
            } else {
                completionHandler(false, nil, "Couldn't find key \(JsonResponseKeys.Account)")
            }
        }
    }
    
    
    // Mark: Delete Session
    
    func deleteSession(completionHandler: @escaping(_ success: Bool, _ errorMessage: String?) -> Void) {
        
        let _ = deleteRequestMethod(Methods.Session) { (result, error) in
            
            if error != nil {
                UdacityClient.sharedInstance().sessionID = nil
                completionHandler(false, error?.localizedDescription)
                return
            }
            
            if result != nil {
                completionHandler(true, nil)
                return
            }
        }
    }
    
    
    // Mark: Singleton Shared Instance
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}
